import 'dart:convert';
import 'package:mob_app/models/BojaProfila.dart';
import 'package:mob_app/models/BojeKorisnika.dart';
import 'package:mob_app/models/Grad.dart';
import 'package:mob_app/models/KategorijaObjave.dart';
import 'package:mob_app/models/RazlogReporta.dart';
import 'package:mob_app/screens/AzuriranjeProfila.dart';
import 'package:flutter/material.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:mob_app/screens/BottomBar.dart';
import 'package:mob_app/screens/ListOfComments.dart';
import 'package:mob_app/screens/ListOfDislikes.dart';
import 'package:mob_app/screens/ListOfLikes.dart';
import 'package:mob_app/screens/ListOfResenihComments.dart';
import 'package:mob_app/screens/LoginPage.dart';
import 'package:mob_app/screens/OdvojenaObjava.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  Korisnik user;
  _ProfilePageState profil;
  api_services servis = api_services();

  void get_localUser() async {
    Korisnik _user = await api_services().getUser();
    this.user = _user;
  }

  ProfilePage() {
    servis.getUser().then((value) {
      this.user = value;
      print(user.prezime + user.prezime);
    });
  }

  ProfilePage.withUser(Korisnik _user) {
    print('usaoo u drugi konstruktor');
    this.user = _user;
    print('print u konstruktoru ' + user.ime);
    /*servis.getUser().then((value) {
      this.user = value;
      print('prezimena u konstruktoru ' + user.prezime + user.prezime);
    });*/
  }

  @override
  _ProfilePageState createState() => _ProfilePageState(user);
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState(Korisnik _user) {

      this._id = _user.id;
    

    servis.fetchKorisnikaPoId(_id).then((response){
      String jsonString = '[' + response.body + ']';
      Iterable list = json.decode(jsonString);

      List<Korisnik> pomocna = List<Korisnik>();
      
      pomocna = list.map((model) => Korisnik.fromObject(model)).toList();
      this.user2 = pomocna[0];
    });



    this.user = _user;
  }
  @override
  int institucija;
  int _id;
  Korisnik logovan_user;
  Korisnik user;
  Korisnik user2;
  api_services servis = api_services();
  List<Objava> objave;
  List<Grad> gradoviKorisnika = List<Grad>();
  bool prikazi_boje = false;
  double razlika_poena = 10;
  List<KategorijaObjave> kategorijeInstitucije = List<KategorijaObjave>();
  List<BojeKorisnika> bojaProfila = List<BojeKorisnika>();
  BojeKorisnika bojaKorisnika = BojeKorisnika();
  List<BojaProfila> boje = List<BojaProfila>();
  List<RazlogReporta> razlozi;
  RazlogReporta selected;
  TextEditingController _izmenaController = new TextEditingController();

  static Color svetlo_zelena = Color(0xFFb3f2b4);
  static Color svetlo_zelena_gradovi = Color(0xFF88ba89);
  static Color svetlo_zelena_senke_gradova = Colors.grey[500];
  static Color svetlo_zelena_edit = Color(0xFF88ba89);


  Color boja_gradova = svetlo_zelena_gradovi;
  Color boja_senke_gradova = svetlo_zelena_senke_gradova;
  Color boja_pozadine = svetlo_zelena;
  Color boja_edita = svetlo_zelena_edit;

  String obavestenje="";

  void initState() {
    // TODO: implement initState
    super.initState();
    provera();
    get_localUser();
    dajBoje();

  }

  void provera() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey('user') == false){
      print('prazan je');
      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context) => MyLoginPage()),
                        (Route<dynamic> route) => false);
    }
  }

  void dajBoje(){
    servis.dajBoje(user.id).then((response) {
      print('dajBoje response body je ' + response.body);
      String noviString = response.body.toString();
      
      String jsonString = '[' + noviString + ']';
      Iterable list = json.decode(jsonString);
      setState(() {
        bojaProfila = list.map((model) => BojeKorisnika.fromObject(model)).toList();
        bojaKorisnika = bojaProfila[0];

        String valueString;
        int pom;

        if(bojaKorisnika.bojaKorisnika != null){
          valueString = bojaKorisnika.bojaKorisnika.main_boja.split('0x')[1];
          pom = int.parse(valueString, radix: 16);
          this.boja_pozadine = Color(pom);
       

        valueString = bojaKorisnika.bojaKorisnika.tamnija_boja.split('0x')[1];
        pom = int.parse(valueString, radix: 16);
        this.boja_gradova = Color(pom);
        this.boja_edita = Color(pom);

        this.boja_senke_gradova = Colors.grey[int.parse(bojaKorisnika.bojaKorisnika.senka)];

        this.boje = bojaKorisnika.boje;
        }
        else{
          this.boja_pozadine = Color(0xFFb3f2b4);
          this.boja_gradova = Color(0xFF88ba89);
          this.boja_senke_gradova = Colors.grey[500];
          this.boja_edita = Color(0xFF88ba89);
        }
      });
    });
  }


  void dajGradoveKorisnika() {
    servis.dajGradoveZaKorisnika(user.id).then((response) {
      print(response.body);
      Iterable list = json.decode(response.body);
      setState(() {
        gradoviKorisnika = list.map((model) => Grad.fromObject(model)).toList();
        gradoviKorisnika.forEach((element) {
          print(element.naziv_grada_lat);
        });
      });
    });
  }

  void dajKategorijeInstitucije() {
    servis.fetchKategorijeInstitucije(user.id).then((response) {
      print(response.body);
      Iterable list = json.decode(response.body);
      setState(() {
        kategorijeInstitucije =
            list.map((model) => KategorijaObjave.fromObject(model)).toList();
        kategorijeInstitucije.forEach((element) {
          print(element.kategorija);
        });
      });
    });
  }

  void get_localUser() {
    api_services().getUser().then((value) {
      setState(() {
        logovan_user = value;

        print('logovan user id je : ' + logovan_user.id.toString());
        dajGradoveKorisnika();
        dajKategorijeInstitucije();
      });
    });
  }

  Widget malaKategorija(String ime, int resena) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 7.0, 5.0),
      padding: EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
      child: Row(children: <Widget>[
        Text(ime, style: gf.GoogleFonts.ubuntu(color: resena!=1? Colors.white:Color(0xFF49c486))),
      ]),
      decoration: BoxDecoration(
          color: resena!=1? this.boja_gradova: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: resena == 1? Color(0xFF3ca36f): Colors.grey[300],
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

  Widget contextObjave(int index) {
    var _buildText;

    if (objave[index].resena == 1) {
      _buildText = buildWhiteText;
    } else {
      _buildText = buildText;
    }

    if (objave[index].tekstualna_objava != null) {
      return new Container(
        margin: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
        child: _buildText(objave[index].tekstualna_objava.tekst),
      );
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

  void getObjave() {
    obavestenje = "Trenutno gledate objave koje je institucija '" + user.ime + "' rešila";
    print('uloga je ' + user.uloga);
    if(user.uloga == "institucija"){

      print('user id je ' + user.id.toString());
      print('logovan user id je ' + logovan_user.id.toString());
      servis.fetchObjaveByIdInstitucija(user.id, logovan_user.id).then(
        (response) {
          Iterable list = json.decode(response.body);
          List<Objava> objaveList = List<Objava>();
          objaveList = list.map((model) => Objava.fromObject(model)).toList();
          setState(
            () {
              objave = objaveList;
              //objave = objave.reversed.toList();
            },
          );
        },
      );
    }else{
      servis.fetchObjaveByIdKorisnika(user.id).then(
        (response) {
          Iterable list = json.decode(response.body);
          List<Objava> objaveList = List<Objava>();
          objaveList = list.map((model) => Objava.fromObject(model)).toList();
          setState(
            () {
              objave = objaveList;
              //objave = objave.reversed.toList();
            },
          );
        },
      );
    }
    dajRazloge();
  }

  void _showDialog(int idObjave) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Obriši objavu'),
            content: Text('Da li ste sigurni da želite da obrišete ovu objavu?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Odustani'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Obriši'),
                onPressed: () {
                  servis.deletePost(idObjave).then((value) {
                    setState(() {
                      getObjave();
                    });
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showOptions(int idObjave) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Obriši objavu'),
            content: Text('Da li ste sigurni da želite da obrišete ovu objavu?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Odustani'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Obriši'),
                onPressed: () {
                  servis.deletePost(idObjave);
                  _handleRefresh();
                  print(idObjave);
                  Navigator.of(context).pop();
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

                        getObjave();



                        });
                      Navigator.of(context).pop();
                    });
                  }else if(objava.slika != null){
                    print('usao u sliku');
                    servis.editOpisSlike(objava.id, _izmenaController.text).then((value){
                      setState(() {

                        getObjave();




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

  Widget _simplePopup(Objava objava) => PopupMenuButton<int>(
        icon: Icon(Icons.more_vert, color: objava.resena == 1? Colors.white: Colors.black),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text("Obriši objavu"),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Označi kao rešen problem"),
          ),
          PopupMenuItem(
            value: 3,
            child: Text("Prikažite objavu detaljno"),
          ),
          PopupMenuItem(
            value: 4,
            child: Text("Izmeni objavu"),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            _showDialog(objava.id);
          } else if (value == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ListOfResenihComments(objava.id, user.id))).then((value){
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
                            getObjave();
                          });
                        });
          } else if (value == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OdvojenaObjava(objava)
                    /*prikazMape(latitude, longitude)*/));
          }else if(value == 4){
            _showDialogIzmena(objava);
          }
        },
      );

  Widget _simplePopup2(Objava objava) => PopupMenuButton<int>(
    icon: Icon(Icons.more_vert, color: objava.resena == 1? Colors.white: Colors.black),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text("Obriši objavu"),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Prikažite objavu detaljno"),
          ),
          PopupMenuItem(
            value: 3,
            child: Text("Izmeni objavu"),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            _showDialog(objava.id);
          } else if (value == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OdvojenaObjava(objava)
                    /*prikazMape(latitude, longitude)*/));
          } else if(value == 3){
            _showDialogIzmena(objava);
          }
        },
      );

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



  Widget printObjave() {
    if (objave == null) {
      return new CircularProgressIndicator();
    }

    void prijaviObjavu() {
      print("prijava");
    }

    var _buildText = buildText;

    return ListView.builder(
      itemCount: objave.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (objave[index].resena == 1) {
          _buildText = buildWhiteText;
        } else {
          _buildText = buildText;
        }

        Widget slika;

        if (user2.url_slike != '') {
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
          margin: EdgeInsets.all(10.0),
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
                  objave[index].resena == 1 ? Color(0xFF49c486) : Colors.white),
          child: new Column(
            //jedna kolona, koja ce da sadrzi 2 ili 3 reda
            children: <Widget>[
              new Container(
                  //decoration: BoxDecoration(border: Border.all(width:1)),

                  child: Row(
                //prvi red slika i ime i prezime
                children: <Widget>[
                  new Container(
                    child: new SizedBox(
                      child: slika,
                    ),
                    margin: EdgeInsets.only(
                        left: 20.0, top: 10.0, right: 5.0, bottom: 10.0),
                  ),
                  new Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: objave[index].vlasnik != null
                            ? objave[index].vlasnik.id == user.id
                                ? Text(
                                    objave[index].vlasnik.ime +
                                        " " +
                                        objave[index].vlasnik.prezime,
                                    style: gf.GoogleFonts.ubuntu(
                                        fontWeight: FontWeight.bold,
                                        color: objave[index].resena == 1
                                            ? Colors.white
                                            : Colors.black))
                                : _buildText(objave[index].vlasnik.ime +
                                    " " +
                                    objave[index].vlasnik.prezime)
                            : _buildText("Null je vlasnik"),
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
                      margin: EdgeInsets.fromLTRB(80.0, 0.0, 0.0, 0.0),
                      child: user.id == logovan_user.id
                          ? objave[index].resena == 1 ||
                                  objave[index].lepaKategorija != null
                              ? _simplePopup2(objave[index])
                              : _simplePopup(objave[index])
                          : _buildText('')),
                ],
              )),

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      new Container(
                        child: new IconButton(
                          icon: new Icon(Icons.thumb_up),
                          color: objave[index].korisnikLajkovao == 1
                              ? Colors.blue
                              : objave[index].resena == 1? Colors.white :Colors.black,
                          onPressed: () {
                            servis.addLike(user.id, objave[index].id).then((value) {
                              setState(() {
                                getObjave();
                              });
                            });
                          },
                        ),
                        //margin:EdgeInsets.only(left:70.0),
                        padding:
                            EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
                      ),

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
                        padding: EdgeInsets.only(left: 17.0, right: 15.0, top: 0.0),
                      ),

                    ],
                  ),

                  Column(
                    children: <Widget>[
                      new Container(
                        child: new IconButton(
                          icon: new Icon(Icons.thumb_down),
                          color: objave[index].korisnikaDislajkovao == 1
                              ? Colors.red
                              : objave[index].resena == 1? Colors.white :Colors.black,
                          onPressed: () {
                            servis
                                .addDislike(user.id, objave[index].id)
                                .then((value) {
                              setState(() {
                                getObjave();
                              });
                            });
                          },
                        ),
                        //margin:EdgeInsets.all(20.0),
                        padding:
                            EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
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
                        padding: EdgeInsets.only(left: 7.0, right: 0.0, top: 0.0),
                      ),

                    ],
                  ),

                  Column(
                    children: <Widget>[
                      new Container(
                        child: new IconButton(
                          icon: new Icon(Icons.comment,
                            color: objave[index].resena == 1? Colors.white: Colors.black
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListOfComments(objave[index], logovan_user.id)
                                    /*prikazMape(latitude, longitude)*/)).then((value){
                                      setState(() {
                                        objave[index].brojKomentara += value;
                                      });
                                    });
                          },
                        ),
                        //margin:EdgeInsets.all(20.0),
                        padding:
                            EdgeInsets.only(left: 20.0, right: 0.0, top: 10.0),
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
                        padding: EdgeInsets.only(left: 20.0, right: 0.0, top: 0.0),
                      ),

                    ],
                  ),
                  
                  
                  
                  objave[index].vlasnik.id != logovan_user.id
                      ? new Column(children: <Widget>[
                        Container(
                          child: new IconButton(
                            icon: new Icon(Icons.report),
                            color: objave[index].korisnikReportovao == 1
                                ? Colors.red
                                : Colors.black,
                            onPressed: () {
                              reportObjave(objave[index]);
                            },
                          ),
                          //margin:EdgeInsets.all(20.0),
                          padding: EdgeInsets.only(
                              left: 20.0, right: 15.0, top: 10.0),
                        ),
                        Text('')
                      ]
                      )
                      : buildText('')
                ],
              ),
            ],
          ),
        );
      },
    );
  }

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
                      Fluttertoast.showToast(
                          msg: "Prijavljivanje objave je u toku... Molimo sačekajte",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFF49c486),
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      servis
                          .reportPost(objava.id, selected.id, user.id)
                          .then((value) {
                        print(value.body);
                        setState(() {
                          getObjave();
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

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    setState(() {
      objave = [];
    });
    getObjave();
    servis.fetchKorisnikaPoId(_id).then((response){
      String jsonString = '[' + response.body + ']';
      Iterable list = json.decode(jsonString);

      List<Korisnik> pomocna = List<Korisnik>();
      
      pomocna = list.map((model) => Korisnik.fromObject(model)).toList();
      this.user2 = pomocna[0];
    });
    return null;
  }

  Widget maliGrad(String ime) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 3.0, 10.0),
      padding: EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
      child: Row(children: <Widget>[
        Text(ime, style: gf.GoogleFonts.ubuntu(color: Colors.white)),
      ]),
      decoration: BoxDecoration(
          color: boja_gradova,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: boja_senke_gradova,
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

  Widget listaImenaKategorija() {
    if (kategorijeInstitucije == null) {
      return CircularProgressIndicator();
    } else
      return new SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: kategorijeInstitucije
                  .map((grad) => maliGrad(grad.kategorija))
                  .toList()));
  }

  Widget build(BuildContext context) {
    if (user != null) {
      if (logovan_user == null || user2 == null) return Center(child:CircularProgressIndicator());
      /*if(this.user.uloga != "institucija"){
        if(logovan_user == null)
          return CircularProgressIndicator();
      }else{
        return CircularProgressIndicator();
      }*/
    }

    if (objave == null && this.user.uloga != "intitucija") {
      getObjave();
    }

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    double dajProcenatSirine(double broj) {
      return _width * broj / 100;
    }

    Widget malaBoja(String boja) {

      String valueString = boja.split('0x')[1];
      int pom = int.parse(valueString, radix: 16);
      Color _boja = Color(pom);

      return Container(
          width: dajProcenatSirine(80) / (boje.length),
          decoration: BoxDecoration(
              color: _boja,
              border: boja_pozadine == boja
                  ? Border.all(color: Colors.yellow, width: 5.0)
                  : Border.all(width: 0.1, color: Colors.white)));
    }

    Widget kontejneriBoja() {
      return Row(children: boje.map((boja) => malaBoja(boja.main_boja)).toList());
    }

    DecorationImage slika_mala;
    DecorationImage slika_velika;

    if (user2.url_slike != '') {
      slika_mala = new DecorationImage(
          image: NetworkImage(api_services.url_za_slike + user2.url_slike),
          fit: BoxFit.fill);

      slika_velika = new DecorationImage(
          colorFilter: ColorFilter.linearToSrgbGamma(),
          image: NetworkImage(api_services.url_za_slike + user2.url_slike),
          fit: BoxFit.fill);
    } else {
      slika_mala = new DecorationImage(
          image: AssetImage('images/profilna_slika.jpg'), fit: BoxFit.fill);

      slika_velika = new DecorationImage(
          colorFilter: ColorFilter.linearToSrgbGamma(),
          image: AssetImage('images/profilna_slika.jpg'),
          fit: BoxFit.fill);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profil korisnika",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          //backgroundColor:Colors.green,
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: /*this.user.uloga == "institucija"? Center(child:Container(child: Text('Profil institucija još uvek nije implementiran'))): */
            this.user2 == null? Center(child:Container(child: CircularProgressIndicator())):
              Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topCenter,
                      /*padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .48,
                        right: 20.0,
                        left: 20.0),*/
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      decoration: new BoxDecoration(image: slika_velika)),
                  Container(
                      alignment: Alignment.topCenter,
                      /*padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .48,
                        right: 20.0,
                        left: 20.0),*/
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      decoration: new BoxDecoration(
                          color: Color(0xFFD7E1E9).withOpacity(0.2))),
                  Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(0.0, 200.0, 0.0, 10.0),
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.1, color: Colors.grey[200]),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50.0),
                                  topRight: Radius.circular(50.0)),
                              color: boja_pozadine,
                              boxShadow: [
                                BoxShadow(
                                  color: boja_pozadine,
                                  blurRadius:
                                      20.0, // has the effect of softening the shadow
                                  spreadRadius:
                                      30.0, // has the effect of extending the shadow
                                  offset: Offset(
                                    0.0, // horizontal, move right 10
                                    80.0, // vertical, move down 10
                                  ),
                                )
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: AlignmentDirectional.topStart,
                                margin: EdgeInsets.fromLTRB(
                                    dajProcenatSirine(50), 15.0, 0.0, 6.0),
                                child: Text(
                                  '@' + user2.username,
                                  style: gf.GoogleFonts.ubuntu(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                
                                alignment: AlignmentDirectional.topStart,
                                margin: EdgeInsets.fromLTRB(
                                    dajProcenatSirine(50), 0.0, 0.0, 10.0),
                                child: user.prezime != null
                                    ? Text(
                                        user2.ime + ' ' + user2.prezime,
                                        style: gf.GoogleFonts.ubuntu(
                                            fontSize: 17.0),
                                      )
                                    : Text(
                                        user2.ime,
                                        style: gf.GoogleFonts.ubuntu(
                                            fontSize: 17.0),
                                      ),
                              ),
                              user.uloga != 'institucija'
                                  ? Row(
                                      children: <Widget>[
                                        Container(
                                            alignment:
                                                AlignmentDirectional.topStart,
                                            margin: EdgeInsets.fromLTRB(
                                                20.0, 30.0, 0.0, 0.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  'Broj poena: ',
                                                  style: gf.GoogleFonts.ubuntu(
                                                      fontSize: 17.0),
                                                ),
                                                Container(
                                                    child: Text(
                                                  user2.poeni.toString(),
                                                  style: gf.GoogleFonts.ubuntu(
                                                      fontSize: 17.0),
                                                )),
                                                user.id == logovan_user.id?
                                                IconButton(
                                                  icon: Icon(Icons.help,
                                                      size: 20),
                                                  onPressed: () {
                                                    setState(() {
                                                      prikazi_boje =
                                                          !prikazi_boje;
                                                    });
                                                  },
                                                ):SizedBox()
                                              ],
                                            )),
                                      ],
                                    )
                                  : Text(''),
                              prikazi_boje == true
                                  ? Container(
                                    
                                      margin: EdgeInsets.fromLTRB(
                                          20.0, 0.0, 20.0, 0.0),
                                      padding: EdgeInsets.fromLTRB(
                                          10.0, 20.0, 20.0, 10.0),
                                      decoration: BoxDecoration(
                                        
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  svetlo_zelena_senke_gradova,
                                              blurRadius:
                                                  5.0, // has the effect of softening the shadow
                                              spreadRadius:
                                                  3.0, // has the effect of extending the shadow
                                              offset: Offset(
                                                2.0, // horizontal, move right 10
                                                2.0, // vertical, move down 10
                                              )),
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Text('Trenutno imate ' +
                                              user2.poeni.toString() +
                                              ' poena, i potrebno vam je još ' +
                                              bojaKorisnika.razlika.toString() +
                                              ' do nove boje profila.'),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0.0, 0.0, 0.0, 0.0),
                                              width: dajProcenatSirine(80) + 2,
                                              height: 30,
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                children: <Widget>[
                                                  kontejneriBoja()
                                                ],
                                              ))
                                        ],
                                      ))
                                  : SizedBox(height: 0.0),
                                  user2.email != null
                                  ? Container(
                                      alignment: AlignmentDirectional.topStart,
                                      margin: EdgeInsets.fromLTRB(
                                          20.0, 0.0, 0.0, 10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text('E-mail:  ',style: gf.GoogleFonts.ubuntu(fontSize: 17)),
                                          Text(user2.email, style: gf.GoogleFonts.ubuntu())
                                        ],
                                      )
                                  )
                                  : Text(''),
                              user.uloga != 'institucija'
                                  ? Container(
                                      alignment: AlignmentDirectional.topStart,
                                      margin: EdgeInsets.fromLTRB(
                                          20.0, 0.0, 0.0, 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            'Gradovi: ',
                                            style: gf.GoogleFonts.ubuntu(
                                                fontSize: 17.0),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 0.0, 10.0, 0.0),
                                            child: listaImenaGradova(),
                                          )
                                        ],
                                      ))
                                  : Container(
                                      alignment: AlignmentDirectional.topStart,
                                      margin: EdgeInsets.fromLTRB(
                                          20.0, 30.0, 0.0, 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            'Kategorije: ',
                                            style: gf.GoogleFonts.ubuntu(
                                                fontSize: 17.0),
                                          ),
                                          kategorijeInstitucije.length != 0
                                              ? Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0.0, 0.0, 20.0, 0.0),
                                                  child: listaImenaKategorija(),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: Text(
                                                      'Ova institucija nažalost još uvek nema kategorije problema kojima se bavi',
                                                      style: gf.GoogleFonts
                                                          .ubuntu()))
                                        ],
                                      )),
                              
                              user2.biografija != null
                                  ? Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 0.0, 0.0, 0.0),
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 10.0, 0.0, 10.0),
                                      child: Column(
                                        children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              'O korisniku: ',
                                              style: gf.GoogleFonts.ubuntu(
                                                  fontSize: 20.0),
                                            )),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(
                                                5.0, 0.0, 10.0, 5.0),
                                            padding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 10.0),
                                            child: Text(user2.biografija)),
                                      ]))
                                  : SizedBox(),
                              user.id == logovan_user.id
                                  ? Container(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      20.0, 0.0, 0.0, 0.0),
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Colors.grey[600],
                                                          blurRadius:
                                                              3.0, // has the effect of softening the shadow
                                                          spreadRadius:
                                                              1.0, // has the effect of extending the shadow
                                                          offset: Offset(
                                                            2.0, // horizontal, move right 10
                                                            2.0, // vertical, move down 10
                                                          ),
                                                        )
                                                      ]),
                                                  child: IconButton(
                                                    icon:
                                                        Icon(Icons.exit_to_app),
                                                    color: boja_edita,
                                                    iconSize: 30.0,
                                                    onPressed: () {
                                                      Future<int> value;
                                                      _odjavaDialog(
                                                          user.id, context);
                                                    },
                                                  )),
                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 10.0, 0.0, 0.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Odjavite se',
                                                      style:
                                                          gf.GoogleFonts.ubuntu(
                                                              color: Colors
                                                                  .black)))
                                            ],
                                          ),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  dajProcenatSirine(60),
                                                  0.0,
                                                  0.0,
                                                  0.0),
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: boja_edita,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey[600],
                                                      blurRadius:
                                                          3.0, // has the effect of softening the shadow
                                                      spreadRadius:
                                                          1.0, // has the effect of extending the shadow
                                                      offset: Offset(
                                                        2.0, // horizontal, move right 10
                                                        2.0, // vertical, move down 10
                                                      ),
                                                    )
                                                  ]),
                                              child: IconButton(
                                                icon: Icon(Icons.edit),
                                                color: Colors.white,
                                                iconSize: 25.0,
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AzuriranjeProfila())).then((value){
                                                                servis.fetchKorisnikaPoId(user.id).then((response){
                                                                    String jsonString = '[' + response.body + ']';
                                                                    Iterable list = json.decode(jsonString);

                                                                    List<Korisnik> pomocna = List<Korisnik>();
                                                                    
                                                                    pomocna = list.map((model) => Korisnik.fromObject(model)).toList();
                                                                setState(() {
                                                                    this.user2 = pomocna[0];
                                                                    dajGradoveKorisnika();
                                                                  });
                                                                });
                                                              });
                                                },
                                              ))
                                        ],
                                      ))
                                  : SizedBox(),
                            ],
                          )),
                          objave !=null?
                            user.uloga == "institucija" && objave.length > 0?
                            
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom:10),
                                child:Text(obavestenje, textAlign: TextAlign.center,style:gf.GoogleFonts.ubuntu(
                                  fontSize:17,
                                ))
                              )
                            :SizedBox():
                          SizedBox(),
                      printObjave()
                    ],
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      padding: new EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .48,
                          right: 20.0,
                          left: 20.0),
                      margin: EdgeInsets.fromLTRB(
                          dajProcenatSirine(14), 170.0, 0.0, 0.0),
                      width: 110,
                      height: 110,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: slika_mala,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius:
                                  5.0, // has the effect of softening the shadow
                              spreadRadius:
                                  1.0, // has the effect of extending the shadow
                              offset: Offset(
                                2.0, // horizontal, move right 10
                                2.0, // vertical, move down 10
                              ),
                            )
                          ])),
                ],
              ),
            ),
          ),
        ));
  }

  void _odjavaDialog(int id, BuildContext kontekst) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Odjava'),
            content: buildText('Da li ste sigurni da želite da se odjavite?'),
            actions: <Widget>[
              FlatButton(
                child: buildText('Odustani'),
                onPressed: () {
                  Navigator.of(context).pop();
                  //return 0;
                  //return 0;
                },
              ),
              FlatButton(
                child: buildText('Odjavi se'),
                onPressed: () {
                  servis.logOut(id, kontekst).then((value){
                    //return 1;
                      Navigator.pop(context);
                      //return 1;
                        Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context) => MyLoginPage()),
                        (Route<dynamic> route) => false);
                    }
                  );
                },
              ),
            ],
          );
        });
  }
}
