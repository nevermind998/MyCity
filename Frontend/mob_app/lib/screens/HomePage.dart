import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as io;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:image_picker/image_picker.dart';
import 'package:mob_app/Map/prikaz_mape2.dart';
import 'package:mob_app/models/AktivnostiKorisnika.dart';
import 'package:mob_app/models/Dislajk.dart';
import 'package:mob_app/models/Grad.dart';
import 'package:mob_app/models/KategorijaObjave.dart';
import 'package:mob_app/models/Komentar.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/models/Lajk.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:mob_app/models/RazlogReporta.dart';
import 'package:mob_app/models/Report.dart';
import 'package:mob_app/screens/Calendar.dart';
import 'package:mob_app/screens/ListOfComments.dart';
import 'package:mob_app/screens/ListOfDislikes.dart';
import 'package:mob_app/screens/ListOfLikes.dart';
import 'package:mob_app/screens/ListaObavestenja.dart';
import 'package:mob_app/screens/LoginPage.dart';
import 'package:mob_app/screens/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/TekstualnaObjava.dart';
import '../services/api_services.dart';
import 'ListOfResenihComments.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _commentController = new TextEditingController();

  var now = DateTime.now();
  String token = '';
  Korisnik user;
  List<TekstualnaObjava> tekstualne_objave;
  api_services servis = api_services();
  List<Objava> objave;
  List<AktivnostiKorisnika> aktivnosti;
  Future<File> file_comment;
  Position position;
  double latitude;
  double longitude;
  File tmpfile;
  int poslata_slika = 0;
  List<RazlogReporta> razlozi;
  RazlogReporta selected;
  List<Grad> gradovi = List<Grad>();
  Grad selectedGrad;
  List<int> odabranGrad = List<int>();
  CalendarController _calendarController;
  bool prikazi_filter = false;
  String datum;
  String filter = 'najnoviji';
  TextEditingController _izmenaController = TextEditingController();
  List<Grad> gradoviKorisnika = List<Grad>();
  int brojObavestenja = 0;
  ScrollController _scrollController = new ScrollController();

  getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    
    if(preferences.containsKey('user') == false){
      print('prazan je');
      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context) => MyLoginPage()),
                        (Route<dynamic> route) => false);
    }else{
      print('nije prazan');
      String _token = preferences.getString('token');
      Map<String, dynamic> jsonObject =
          json.decode(preferences.getString('user'));
      Korisnik extractedUser = new Korisnik();
      extractedUser = Korisnik.fromObject(jsonObject);
      setState(() {
        token = _token;
        user = extractedUser;
        print('token je ' + token);
        
        //print(user);
      });
      dajGradoveKorisnika();
      _brojObavestenja();
    }
    
  }

  initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
    getToken();
    dajGradove();
    _calendarController = CalendarController();
  }

  

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
          setState((){

          });
      }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
          setState(() {
            
          });
      }
  }

  void _brojObavestenja(){
    servis.dajbrojObavestenja(user.id).then((response){
      setState(() {
        brojObavestenja = int.parse(response.body);
      });
    });
  }

  void getObjave() {
    servis.fetchObjave(user.id).then(
      (response) {
        print('status code kod getObjave je ' + response.statusCode.toString());
        if (response.statusCode == 401) {
          print('Problem prilikom autorizacije');
          
        } else {
          Iterable list = json.decode(response.body);
          List<Objava> objaveList = List<Objava>();
          objaveList = list.map((model) => Objava.fromObject(model)).toList();
          setState(
            () {
              objave = objaveList;
              prikazi_filter = false;
              filter = 'najnoviji';
            },
          );
        }
      },
    );

    dajRazloge();
  }

  void dajGradoveKorisnika() {
    servis.dajGradoveZaKorisnika(user.id).then((response) {
      print('response status je ' + response.statusCode.toString());
      print('Gradovi su: ' + response.body);
      Iterable list = json.decode(response.body);
      setState(() {
        gradoviKorisnika = list.map((model) => Grad.fromObject(model)).toList();
        gradoviKorisnika.forEach((element) {
          print(element.naziv_grada_lat);
        });
      });
    });
  }

  void dajObjaveZaDatum(String datum) {
    servis.fetchObjaveZaDatum(user.id, datum).then(
      (response) {
        if (response.statusCode == 401) {
          print('Problem prilikom autorizacije');
        } else {
          Iterable list = json.decode(response.body);
          List<Objava> objaveList = List<Objava>();
          objaveList = list.map((model) => Objava.fromObject(model)).toList();
          setState(
            () {
              objave = objaveList;
              prikazi_filter = false;
              filter = 'datum';
            },
          );
        }
      },
    );

    dajRazloge();
  }

  void getNajpopularnijeObjave() {
    servis.fetchNajpopularnijeObjave(user.id).then(
      (response) {
        if (response.statusCode == 401) {
          print('Problem prilikom autorizacije');
        } else {
          Iterable list = json.decode(response.body);
          List<Objava> objaveList = List<Objava>();
          objaveList = list.map((model) => Objava.fromObject(model)).toList();
          setState(
            () {
              objave = objaveList;
              prikazi_filter = false;
              filter = 'najpopularnije';
            },
          );
        }
      },
    );
  }

  void getNajnepopularnijeObjave() {
    servis.fetchNajnepopularnijeObjave(user.id).then(
      (response) {
        if (response.statusCode == 401) {
          print('Problem prilikom autorizacije');
        } else {
          Iterable list = json.decode(response.body);
          List<Objava> objaveList = List<Objava>();
          objaveList = list.map((model) => Objava.fromObject(model)).toList();
          setState(
            () {
              objave = objaveList;
              prikazi_filter = false;
              filter = 'najnepopularnije';
            },
          );
        }
      },
    );
  }

  void dajObjaveZaGrad() {
    servis.fetchObjaveZaGrad(odabranGrad, user.id).then(
      (response) {
        if (response.statusCode == 401) {
          print('Problem prilikom autorizacije');
        } else {
          Iterable list = json.decode(response.body);
          List<Objava> objaveList = List<Objava>();
          objaveList = list.map((model) => Objava.fromObject(model)).toList();
          setState(
            () {
              objave = objaveList;
              prikazi_filter = false;
              filter = 'grad';
            },
          );
        }
      },
    );
  }

  Widget buildText(String str) {
    return Text(
      str,
      style: gf.GoogleFonts.ubuntu(),
    );
  }

  Widget buildWhiteText(String str) {
    return Text(
      str,
      style: gf.GoogleFonts.ubuntu(color: Colors.white),
    );
  }

  void _showDialog(int idObjave) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Obriši objavu'),
            content:
                buildText('Da li ste sigurni da želite da obrišete ovu objavu'),
            actions: <Widget>[
              FlatButton(
                child: buildText('Odustani'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: buildText('Obriši'),
                onPressed: () {
                  servis.deletePost(idObjave).then((value){
                    print(idObjave);
                  setState(() {
                    if (filter == 'najnoviji')
                      getObjave();
                    else if (filter == 'najpopularnije')
                      getNajpopularnijeObjave();
                    else if (filter == 'najnepopularnije')
                      getNajnepopularnijeObjave();
                    else if (filter == 'datum')
                      dajObjaveZaDatum(datum);
                    else
                      dajObjaveZaGrad();
                  });
                  Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
  }

  void _showDialogIzmena(Objava objava) {
    
    if(objava.tekstualna_objava != null){
      _izmenaController.text = objava.tekstualna_objava.tekst;
    }else if(objava.slika != null){
      _izmenaController.text = objava.slika.opis_slike;
    }else{
      _izmenaController.text = "";
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Izmeni objavu'),
            content:
                Container(
                  child:Column(
                    mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Text('Unesite novi tekst',
                        style: gf.GoogleFonts.ubuntu()
                      )
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: TextFormField(
                        controller: _izmenaController,
                        textCapitalization: TextCapitalization.sentences,
                            textAlign: TextAlign.start,
                            cursorWidth: 2.0,
                            autofocus: false,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                hintText: "Unesite željeni tekst...",
                                labelText: 'Tekst'),
                            maxLines: 3,
                      )
                    )
                  ],
                )),
            actions: <Widget>[
              FlatButton(
                child: buildText('Odustani'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: buildText('Izmeni'),
                onPressed: () {

                  if(objava.tekstualna_objava != null){
                    print('usao u tekstulanu objavu');
                    servis.editTextPost(objava.id, _izmenaController.text).then((value){
                      setState(() {
                          if (filter == 'najnoviji')
                            getObjave();
                          else if (filter == 'najpopularnije')
                            getNajpopularnijeObjave();
                          else if (filter == 'najnepopularnije')
                            getNajnepopularnijeObjave();
                          else if (filter == 'datum')
                            dajObjaveZaDatum(datum);
                          else
                            dajObjaveZaGrad();
                        });
                      Navigator.of(context).pop();
                    });
                  }else if(objava.slika != null){
                    print('usao u sliku');
                    servis.editOpisSlike(objava.id, _izmenaController.text).then((value){
                      setState(() {
                          if (filter == 'najnoviji')
                            getObjave();
                          else if (filter == 'najpopularnije')
                            getNajpopularnijeObjave();
                          else if (filter == 'najnepopularnije')
                            getNajnepopularnijeObjave();
                          else if (filter == 'datum')
                            dajObjaveZaDatum(datum);
                          else
                            dajObjaveZaGrad();
                        });
                      Navigator.of(context).pop();
                    });
                  }else{
                    print('nije usao nigde');
                    Navigator.of(context).pop();
                  }

                  
                },
              ),
            ],
          );
        });
  }

  void _showDialogCalendar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Odaberite datum'),
            content: Column(
              children: <Widget>[
                TableCalendar(
                  calendarController: _calendarController,
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: buildText('Potvrdi'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: buildText('Odustani'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget maliGrad(String ime) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
      padding: EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
      child: Row(children: <Widget>[
        Text(ime, style: gf.GoogleFonts.ubuntu(color: Colors.white)),
      ]),
      decoration: BoxDecoration(
          color: Color(0xFF49c486),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 3.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                4.0, // horizontal, move right 10
                2.0, // vertical, move down 10
              ),
            )
          ]),
    );
  }

  Widget listaImenaGradova() {
    if (gradoviKorisnika == null) {
      return CircularProgressIndicator();
    } else
      return new SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: gradoviKorisnika
                  .map((grad) => maliGrad(grad.naziv_grada_lat))
                  .toList()));
  }

  Widget contextObjave(int index) {
    var _buildText;

    if (objave[index].resena > 0) {
      _buildText = buildWhiteText;
    } else {
      _buildText = buildText;
    }

    if (objave[index].tekstualna_objava != null) {
      return new Container(
          margin: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
          child: _buildText(objave[index].tekstualna_objava.tekst));
    } else if (objave[index].slika != null) {
      return new Container(
        child: Column(
          children: <Widget>[
            objave[index].slika.opis_slike != null
                ? _buildText(objave[index].slika.opis_slike)
                : _buildText(' '),
            SizedBox(height:10),
            Image.network(
              api_services.url_za_slike + objave[index].slika.urlSlike,
            )
          ],
        ),
        margin: EdgeInsets.only(right: 20.0, left: 20.0),
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0, bottom: 20.0),
        /*decoration: new BoxDecoration(
            border: Border(top:BorderSide(color: Colors.black54,), bottom: BorderSide(color: Colors.black54)))*/
      );
    } else {
      return Text('');
    }
  }

  Widget _simplePopup(Objava objava){ 
    List<PopupMenuItem<int>> popupovi = List<PopupMenuItem<int>>();

    popupovi.add(
      PopupMenuItem(
            value: 1,
            child: buildText("Obriši objavu"),
          )
    );

    popupovi.add(
      PopupMenuItem(
        value: 3,
        child: buildText("Izmeni objavu")
      )
    );

    if(objava.lepaKategorija == null){
      popupovi.add(
        PopupMenuItem(
            value: 2,
            child: buildText("Označi problem kao rešen"),
          )
      );
    }

    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: objava.resena > 0? Colors.white: Colors.black),
        itemBuilder: (context) => popupovi,
        onSelected: (value) {
          if (value == 1) {
            _showDialog(objava.id);
          } else if (value == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ListOfResenihComments(objava.id, user.id)
                    /*prikazMape(latitude, longitude)*/)).then((value){
                      //_showDialogObavestenje('Uspešno ste označili objavu da je rešena.',context);
                      if(value == 1){
                        Fluttertoast.showToast(
                          msg: "Uspešno ste označili problem kao rešen.",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFF49c486),
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      }
                      setState(() {
                          if (filter == 'najnoviji')
                            getObjave();
                          else if (filter == 'najpopularnije')
                            getNajpopularnijeObjave();
                          else if (filter == 'najnepopularnije')
                            getNajnepopularnijeObjave();
                          else if (filter == 'datum')
                            dajObjaveZaDatum(datum);
                          else
                            dajObjaveZaGrad();
                        });
                    });
          } else if( value == 3){
            _showDialogIzmena(objava);
          }
        },
      );
  }

  void _showDialogObavestenje(String text, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Obaveštenje'),
            content:
                buildText(text),
            actions: <Widget>[
              FlatButton(
                child: buildText('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget _simplePopup2(Objava objava) => PopupMenuButton<int>(
    icon: Icon(Icons.more_vert, color: objava.resena > 0? Colors.white: Colors.black),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: buildText("Obriši objavu"),
          ),
          PopupMenuItem(
            value: 2,
            child: buildText("Izmeni objavu")
          )
        ],
        onSelected: (value) {
          if (value == 1) {
            _showDialog(objava.id);
          }else if(value == 2){
            _showDialogIzmena(objava);
          }
        },
      );

  List<DropdownMenuItem<RazlogReporta>> buildDropdownMenuItems(List _razlozi) {
    List<DropdownMenuItem<RazlogReporta>> items = List();
    for (RazlogReporta razlog in _razlozi) {
      items.add(
        DropdownMenuItem(
          value: razlog,
          child: Text(razlog.razlog),
        ),
      );
    }
    return items;
  }

  void dajRazloge() {
    servis.dajRazlogePrijave().then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        razlozi = list.map((model) => RazlogReporta.fromObject(model)).toList();
        selected = razlozi[0];
      });
    });
  }

  reportObjave(Objava objava) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: buildText('Razlog prijavljivanja objave'),
                content: Container(
                    height: 90,
                    child: Column(
                      children: <Widget>[
                        buildText('Odaberite razlog prijavljivanja objave:'),
                        Container(
                            child: DropdownButton(
                                items: buildDropdownMenuItems(razlozi),
                                value: selected,
                                onChanged: (value) {
                                  print(value.razlog);
                                  setState(() {
                                    selected = value;
                                  });
                                }))
                      ],
                    )),

                /*Container(
                    child:DropdownButton(
                        items: buildDropdownMenuItems(razlozi),
                        value: selected,
                        onChanged: (value) {
                          print(value.razlog);
                          setState(() {
                            selected = value;
                          });
                        })
                  )*/

                actions: <Widget>[
                  FlatButton(
                    child: buildText('Odustani'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: buildText('Prijavi'),
                    onPressed: () {
                      servis
                          .reportPost(objava.id, selected.id, user.id)
                          .then((value) {
                        print(value.body);
                        setState(() {
                          if (filter == 'najnoviji')
                            getObjave();
                          else if (filter == 'najpopularnije')
                            getNajpopularnijeObjave();
                          else if (filter == 'najnepopularnije')
                            getNajnepopularnijeObjave();
                          else if (filter == 'datum')
                            dajObjaveZaDatum(datum);
                          else
                            dajObjaveZaGrad();
                        });
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  Widget malaKategorija(String ime, int resena) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 7.0, 5.0),
      padding: EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
      child: Row(children: <Widget>[
        Text(ime, style: gf.GoogleFonts.ubuntu(color: resena ==0 ? Colors.white: Color(0xFF49c486))),
      ]),
      decoration: BoxDecoration(
          color: resena==0? Color(0xFF49c486): Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: resena >0 ? Color(0xFF3ca36f): Colors.grey[300],
              blurRadius: 3.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                4.0, // horizontal, move right 10
                2.0, // vertical, move down 10
              ),
            )
          ]),
    );
  }

  Widget listaKategorija(List<KategorijaObjave> kategorije, int resena) {
    return new Container(
        margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                child: Row(
                    children: kategorije
                        .map((kategorija) =>
                            malaKategorija(kategorija.kategorija, resena))
                        .toList()))));
  }

  Widget objava(int index){

    var _buildText = buildText;

    if (objave[index].resena > 0) {
          _buildText = buildWhiteText;
        } else {
          _buildText = buildText;
        }

        Widget slika;

        if (objave[index].vlasnik.url_slike != '') {
          slika = Container(
            width: 40.0,
            height: 40.0,
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                      api_services.url_za_slike +
                          objave[index].vlasnik.url_slike,
                    ),
                    fit: BoxFit.fill)),
          );
        } else {
          slika = Container(
              margin: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.account_circle, size: 25.0));
        }

    return Container(
          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          //height: visible_comment_section[index] ?  340 : 250,
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[350],
                    blurRadius: 10.0, // has the effect of softening the shadow
                    spreadRadius: 3.0, // has the effect of extending the shadow
                    offset: Offset(
                      10.0, // horizontal, move right 10
                      10.0, // vertical, move down 10
                    )),
              ],
              //border: Border.all(color: Colors.grey),
              color:
                  objave[index].resena > 0 ? Color(0xFF49c486) : Colors.white),
          child: new Column(
            //jedna kolona, koja ce da sadrzi 2 ili 3 reda
            children: <Widget>[
              new Container(
                  //decoration: BoxDecoration(border: Border.all(width:1)),

                  child: Row(
                //prvi red slika i ime i prezime
                children: <Widget>[
                  GestureDetector(
                      onTap: (){
                        Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ProfilePage.withUser(objave[index].vlasnik)
                                            /*prikazMape(latitude, longitude)*/));
                      },
                    child:new Container(
                      child: new SizedBox(
                        child: slika,
                      ),
                      margin: EdgeInsets.only(
                          left: 20.0, top: 10.0, right: 5.0, bottom: 10.0),
                    ),
                  ),
                  new Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap:(){
                              Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ProfilePage.withUser(objave[index].vlasnik)
                                            /*prikazMape(latitude, longitude)*/));
                            },
                            child: Container(
                              child: objave[index].vlasnik != null
                                  ? objave[index].vlasnik.id == user.id
                                      ?
                                      //ako jeste logovan
                                      Text('@' + objave[index].vlasnik.username,
                                          style: gf.GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              color: objave[index].resena > 0
                                                  ? Colors.white
                                                  : Colors.black))
                                      :
                                      //ako nije logovan
                                      Text('@' + objave[index].vlasnik.username,
                                          style: gf.GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              color: objave[index].resena > 0
                                                  ? Colors.white
                                                  : Colors.black))
                                  : _buildText("Null je vlasnik"),
                            ),
                          ),
                          
                          Container(
                            child: _buildText(objave[index].vlasnik.ime +
                                " " +
                                objave[index].vlasnik.prezime),
                            margin: EdgeInsets.only(
                                left: 0.0, top: 0.0, right: 0.0, bottom: 2.0),
                          ),
                          Container(
                            child: objave[index].vreme != null
                                ? _buildText(objave[index].vreme)
                                : _buildText(''),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(90.0, 0.0, 0.0, 0.0),
                      child: user.id == objave[index].vlasnik.id
                          ? objave[index].resena == 0
                              ? _simplePopup(objave[index])
                              : _simplePopup2(objave[index])
                          : _buildText('')),
                ],
              )),
              /*Container(
                  height: 0.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey[300], width: 1.5)))),*/
              Container(
                  margin: EdgeInsets.only(top: 0, bottom: 10),
                  child: objave[index].kategorije == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(objave[index].lepaKategorija.kategorija,
                                style: gf.GoogleFonts.ubuntu(
                                    color: objave[index].lepaKategorija.boja,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 5),
                            Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: objave[index]
                                            .lepaKategorija
                                            .stiker)))
                          ],
                        )
                      : listaKategorija(objave[index].kategorije, objave[index].resena)),
              Container(
                  height: 0.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey[300], width: 1.5)))),
              SizedBox(
                height: 20.0,
              ),
              contextObjave(index), // vraca tekst ili sliku
              new Row(
                children: <Widget>[
                  new Container(
                    child: new IconButton(
                      icon: new Icon(Icons.thumb_up),
                      color: objave[index].korisnikLajkovao == 1
                          ? Colors.blue
                          : objave[index].resena > 0? Colors.white : Colors.black,
                      onPressed: () {
                        servis.addLike(user.id, objave[index].id).then((value) {
                          print(value.body);
                          setState(() {
                            if (filter == 'najnoviji')
                              getObjave();
                            else if (filter == 'najpopularnije')
                              getNajpopularnijeObjave();
                            else if (filter == 'najnepopularnije')
                              getNajnepopularnijeObjave();
                            else if (filter == 'datum')
                              dajObjaveZaDatum(datum);
                            else
                              dajObjaveZaGrad();
                          });
                        });
                      },
                    ),
                    //margin:EdgeInsets.only(left:70.0),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
                  ),
                  new Container(
                    child: new IconButton(
                      icon: new Icon(Icons.thumb_down),
                      color: objave[index].korisnikaDislajkovao == 1
                          ? Colors.red
                          : objave[index].resena > 0? Colors.white : Colors.black,
                      onPressed: () {
                        servis
                            .addDislike(user.id, objave[index].id)
                            .then((value) {
                          print(value.body);
                          setState(() {
                            if (filter == 'najnoviji')
                              getObjave();
                            else if (filter == 'najpopularnije')
                              getNajpopularnijeObjave();
                            else if (filter == 'najnepopularnije')
                              getNajnepopularnijeObjave();
                            else if (filter == 'datum')
                              dajObjaveZaDatum(datum);
                            else
                              dajObjaveZaGrad();
                          });
                        });
                      },
                    ),
                    //margin:EdgeInsets.all(20.0),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
                  ),
                  new Container(
                    child: new IconButton(
                      icon: new Icon(Icons.comment),
                      color: objave[index].resena > 0? Colors.white: Colors.black,
                      onPressed: () {
                        Future<int> broj_novih_komentara;
                        broj_novih_komentara = Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ListOfComments(objave[index], user.id)
                                /*prikazMape(latitude, longitude)*/)).then((value){
                                  print('broj novih komentara je ' + value.toString());
                                  setState(() {
                                    objave[index].brojKomentara += value;
                                  });
                                });
                      },
                    ),
                    //margin:EdgeInsets.all(20.0),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
                  ),
                  new Container(
                    child: new IconButton(
                      icon: new Icon(Icons.report),
                      color: objave[index].korisnikReportovao == 1
                          ? Colors.red
                          : objave[index].resena > 0? Colors.white : Colors.black,
                      onPressed: () {
                        reportObjave(objave[index]);
                      },
                    ),
                    //margin:EdgeInsets.all(20.0),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Container(
                    child: GestureDetector(
                        child: _buildText(objave[index].brojLajkova.toString()),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListOfLikes(objave[index].id)
                                  /*prikazMape(latitude, longitude)*/));
                        }),
                    //margin:EdgeInsets.only(left:70.0),
                    padding: EdgeInsets.only(left: 39.0, right: 15.0, top: 0.0),
                  ),
                  new Container(
                    child: GestureDetector(
                        child:
                            _buildText(objave[index].brojDislajkova.toString()),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListOfDislikes(objave[index].id)
                                  /*prikazMape(latitude, longitude)*/));
                        }),
                    //margin:EdgeInsets.only(left:70.0),
                    padding: EdgeInsets.only(left: 63.0, right: 15.0, top: 0.0),
                  ),
                  new Container(
                    child: GestureDetector(
                        child:
                            _buildText(objave[index].brojKomentara.toString()),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListOfComments(objave[index], user.id)
                                  /*prikazMape(latitude, longitude)*/));
                        }),
                    //margin:EdgeInsets.only(left:70.0),
                    padding: EdgeInsets.only(left: 57.0, right: 15.0, top: 0.0),
                  ),
                ],
              ),
            ],
          ),
        );
  }

  Widget printObjave() {
    if (objave == null) {
      return Center(
          child: Container(
        child: new CircularProgressIndicator(),
        padding: EdgeInsets.all(10.0),
      ));
    }

    

    return ListView.builder(
      controller: _scrollController,
      itemCount: objave.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      //physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return objava(index);
      },
    );
  }

  void pokupiLokaciju() {
    Future<Position> _position = servis.getCurrentLocation().then((value) {
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
      });
    });
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      objave = [];
    });
    getObjave();
    _brojObavestenja();
    return null;
  }

  void dajGradove() {
    servis.dajGradove().then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        gradovi = list.map((model) => Grad.fromObject(model)).toList();
        selectedGrad = gradovi[0];
      });
    });
  }

  List<DropdownMenuItem<Grad>> buildDropdownMenuItemsGradovi(List _gradovi) {
    List<DropdownMenuItem<Grad>> items = List();
    for (Grad grad in _gradovi) {
      items.add(
        DropdownMenuItem(
          value: grad,
          child: Text(
            grad.naziv_grada_lat,
            style: gf.GoogleFonts.ubuntu(),
          ),
        ),
      );
    }
    return items;
  }

  Widget filteri(BuildContext context) {
    return Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[350],
                    blurRadius: 10.0, // has the effect of softening the shadow
                    spreadRadius: 3.0, // has the effect of extending the shadow
                    offset: Offset(
                      10.0, // horizontal, move right 10
                      10.0, // vertical, move down 10
                    )),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          prikazi_filter = false;
                        });
                      },
                    )),
                Text('Prikaz objava po filterima',
                    style: gf.GoogleFonts.ubuntu(fontSize: 15)),
                    new SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 10),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0),
                                    
                                    side: filter == 'najnoviji'? BorderSide(color: Colors.orange, width: 3.0)
                                    :BorderSide(color: Colors.white, width: 0.0)
                                  ),
                                  child: Text('Najnovije',
                                      style:
                                          gf.GoogleFonts.ubuntu(fontSize: 15)),
                                  onPressed: () {
                                    getObjave();
                                  }),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0),
                                    
                                    side: filter == 'najpopularnije'? BorderSide(color: Colors.orange, width: 3.0)
                                    :BorderSide(color: Colors.white, width: 0.0)
                                  ),
                                  child: Text('Najpopularnije',
                                      style:
                                          gf.GoogleFonts.ubuntu(fontSize: 15,
                                          
                                          )),
                                  onPressed: () {
                                    getNajpopularnijeObjave();
                                  }),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0),
                                    
                                    side: filter == 'najnepopularnije'? BorderSide(color: Colors.orange, width: 3.0)
                                    :BorderSide(color: Colors.white, width: 0.0)
                                  ),
                              child: Text('Najnepopularnije',
                                  style: gf.GoogleFonts.ubuntu(fontSize: 15)),
                              onPressed: () {
                                getNajnepopularnijeObjave();
                              }),
                        ),
                        SizedBox(width: 20),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Container(
                                  margin: EdgeInsets.only(
                                      right: 20, bottom: 20, left: 20),
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[350],
                                          blurRadius:
                                              10.0, // has the effect of softening the shadow
                                          spreadRadius:
                                              3.0, // has the effect of extending the shadow
                                          offset: Offset(
                                            -5.0, // horizontal, move right 10
                                            5.0, // vertical, move down 10
                                          )),
                                    ],
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          child: Text(
                                              'Prikaži objave za odabrani grad',
                                              style: gf.GoogleFonts.ubuntu(
                                                  fontSize: 15))),
                                      new DropdownButton(
                                          items: buildDropdownMenuItemsGradovi(
                                              gradovi),
                                          value: selectedGrad,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedGrad = value;
                                            });
                                          }),
                                      Container(
                                          child: RaisedButton(
                                              child: Text('Prikaži',
                                                  style: gf.GoogleFonts.ubuntu(
                                                      fontSize: 15)),
                                              onPressed: () {
                                                if (odabranGrad.length != 0) {
                                                  odabranGrad.removeAt(0);
                                                }
                                                odabranGrad
                                                    .add(selectedGrad.id);

                                                dajObjaveZaGrad();
                                              }))
                                    ],
                                  )),
                              Container(
                                alignment: Alignment.center,
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Po datumu:',
                                          style: gf.GoogleFonts.ubuntu(
                                              fontSize: 15)),
                                      SizedBox(width: 20),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xFF49c486),
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                            icon: Icon(Icons.calendar_today,
                                                color: Colors.white),
                                            onPressed: () {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Calendar()))
                                                  .then((value) {
                                                if (value != null) {
                                                  setState(() {
                                                    datum = value
                                                        .toString()
                                                        .split(' ')[0];
                                                  });
                                                  dajObjaveZaDatum(datum);
                                                } else {
                                                  print('null je');
                                                }
                                              });
                                            },
                                          ))
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    )

                    )
                
              ],
            ));
  }

  Widget trenutniFilter(){
    return Container(
                child:Column(
                  children: filter == 'najnoviji'? 
                  <Widget>[
                    Text('Trenutno gledate objave za sledeće gradove:',
                      style: gf.GoogleFonts.ubuntu()
                    ),
                    Container(
                      child: listaImenaGradova()
                    ),
                  ]:
                  filter == 'najpopularnije'?
                  <Widget>[
                    Text('Trenutno gledate najpopularnije objave za sledeće gradove:',
                      style: gf.GoogleFonts.ubuntu()
                    ),
                    Container(
                      child: listaImenaGradova()
                    ),
                  ]:
                  filter == 'najnepopularnije'?
                  <Widget>[
                    Text('Trenutno gledate najnepopularnije objave za sledeće gradove:',
                      style: gf.GoogleFonts.ubuntu()
                    ),
                    Container(
                      child: listaImenaGradova()
                    ),
                  ]:
                  filter == 'grad'? 
                  <Widget>[
                    Text('Trenutno gledate najnovije objave za ' + selectedGrad.naziv_grada_lat + ':',
                      style: gf.GoogleFonts.ubuntu()
                    ),
                  ]:
                  filter == 'datum'?
                  <Widget>[
                    Text('Trenutno gledate od ' + datum + ' datuma za sledeće gradove:',
                      style: gf.GoogleFonts.ubuntu()
                    ),
                    Container(
                      child: listaImenaGradova()
                    ),
                  ]:
                  <Widget>[
                    SizedBox(height:0.0)
                  ]

                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[350],
                        blurRadius:
                            10.0, // has the effect of softening the shadow
                        spreadRadius:
                            3.0, // has the effect of extending the shadow
                        offset: Offset(
                          -5.0, // horizontal, move right 10
                          5.0, // vertical, move down 10
                        )),
                  ],
                )
              );
  }

  Widget filter_notifikacije(){
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text('',
                style: gf.GoogleFonts.ubuntu(
                    fontSize: 35,
                    color: Colors.greenAccent[700])),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.filter_list, size: 30),
                    onPressed: () {
                      setState(() {
                        prikazi_filter = true;
                      });
                    },
                  )),
                Container(
                  alignment: Alignment.topRight,
                  child:IconButton(
                    icon: Icon(Icons.notifications, size: 30),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListaObavestenja()
                            /*prikazMape(latitude, longitude)*/)).then((value){
                              servis.potvrdiObavestenja(user.id);
                            });
                    },
                  )
                ),
                brojObavestenja!=0?
                Container(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(brojObavestenja.toString(), style: gf.GoogleFonts.ubuntu(
                      color: Colors.white
                    ))
                  ),
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.red
                  )
                ):
                SizedBox()
              ],
            )
          )
          
        ],
      ));
  }

  @override
  Widget build(BuildContext context) {
    
    if (user != null) {
      //servis.logOut(user.id, context);
      if (objave == null) {
        getObjave();
      }
    }
    /*if (latitude == null) {
      pokupiLokaciju();
    }*/

    if(gradoviKorisnika == null){
      dajGradoveKorisnika();
    }

    return new GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
              child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              prikazi_filter == true
                  ? filteri(context)
                  : Container(
                      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text('',
                                style: gf.GoogleFonts.ubuntu(
                                    fontSize: 35,
                                    color: Colors.greenAccent[700])),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: Icon(Icons.filter_list, size: 30),
                                    onPressed: () {
                                      setState(() {
                                        prikazi_filter = true;
                                      });
                                    },
                                  )),
                                Container(
                                  alignment: Alignment.topRight,
                                  child:IconButton(
                                    icon: Icon(Icons.notifications, size: 30),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ListaObavestenja()
                                            /*prikazMape(latitude, longitude)*/)).then((value){
                                              servis.potvrdiObavestenja(user.id);
                                            });
                                    },
                                  )
                                ),
                                brojObavestenja!=0?
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(brojObavestenja.toString(), style: gf.GoogleFonts.ubuntu(
                                      color: Colors.white
                                    ))
                                  ),
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.red
                                  )
                                ):
                                SizedBox()
                              ],
                            )
                          )
                          
                        ],
                      )),
              Container(
                child:Column(
                  children: filter == 'najnoviji'? 
                  <Widget>[
                    Text('Trenutno gledate objave za sledeće gradove:',
                      style: gf.GoogleFonts.ubuntu()
                    ),
                    Container(
                      child: listaImenaGradova()
                    ),
                  ]:
                  filter == 'najpopularnije'?
                  <Widget>[
                    Text('Trenutno gledate najpopularnije objave za sledeće gradove:',
                      style: gf.GoogleFonts.ubuntu()
                    ),
                    Container(
                      child: listaImenaGradova()
                    ),
                  ]:
                  filter == 'najnepopularnije'?
                  <Widget>[
                    Text('Trenutno gledate najnepopularnije objave za sledeće gradove:',
                      style: gf.GoogleFonts.ubuntu()
                    ),
                    Container(
                      child: listaImenaGradova()
                    ),
                  ]:
                  filter == 'grad'? 
                  <Widget>[
                    Text('Trenutno gledate najpopularnije objave za ' + selectedGrad.naziv_grada_lat + ':',
                      style: gf.GoogleFonts.ubuntu()
                    ),
                  ]:
                  filter == 'datum'?
                  <Widget>[
                    Text('Trenutno gledate od ' + datum + ' datuma za sledeće gradove:',
                      style: gf.GoogleFonts.ubuntu()
                    ),
                    Container(
                      child: listaImenaGradova()
                    ),
                  ]:
                  <Widget>[
                    SizedBox(height:0.0)
                  ]

                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[350],
                        blurRadius:
                            10.0, // has the effect of softening the shadow
                        spreadRadius:
                            3.0, // has the effect of extending the shadow
                        offset: Offset(
                          -5.0, // horizontal, move right 10
                          5.0, // vertical, move down 10
                        )),
                  ],
                )
              ),
              
              
              printObjave(),
              SizedBox(
                height: 50,
              )
            ],
          )),
        ),


        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Mapa(objave)
                    /*prikazMape(latitude, longitude)*/));
          },
          child: Icon(Icons.map),
          backgroundColor: Color(0xFF49c486),
        )));
  }
}
