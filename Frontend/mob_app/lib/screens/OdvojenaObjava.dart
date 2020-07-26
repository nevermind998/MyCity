import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mob_app/models/Komentar.dart';
import 'package:mob_app/models/RazlogReporta.dart';
import 'package:mob_app/screens/AzuriranjeProfila.dart';
import 'package:flutter/material.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:mob_app/screens/BottomBar.dart';
import 'package:mob_app/screens/HomePage.dart';
import 'package:mob_app/screens/ListOfComments.dart';
import 'package:mob_app/screens/ListOfDislikes.dart';
import 'package:mob_app/screens/ListOfLikes.dart';
import 'package:mob_app/screens/ListOfResenihComments.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart' as gf;

class OdvojenaObjava extends StatefulWidget {
  Objava objava;

  OdvojenaObjava(Objava _objava) {
    this.objava = _objava;
    print('Odovjena objava, id je ' + objava.id.toString());
  }

  @override
  _OdvojenaObjavaState createState() => new _OdvojenaObjavaState(objava);
}

class _OdvojenaObjavaState extends State<OdvojenaObjava> {
  Objava objava;
  _OdvojenaObjavaState(Objava _objava) {
    this.objava = _objava;
  }
  @override
  Korisnik logovan_user;
  bool checked_resenje = false;
  api_services servis = api_services();
  List<Objava> objave;
  Future<File> file_comment;
  File slika;
  int poslata_slika;
  TextEditingController _commentController = TextEditingController();
  List<Komentar> komentari;
  Korisnik logovan_korisnik;
  Size size;
  double velicina_slova_klasik = 15.0;
  double velicina_slova_objava = 20.0;
  int broj_lajkova = -1;
  int broj_dislajkova = -1;
  List<RazlogReporta> razlozi;
  RazlogReporta selected;
  TextEditingController _izmenaController = TextEditingController();
  TextEditingController _izmenaObjavaController = TextEditingController();
  String base64Image;
  bool img = false;
  File tmpFile;
  int korisnik_lajkovao = 0;
  int korisnik_dislajkovao = 0;
  int korisnik_reportovao = 0;

  void initState() {
    super.initState();
    _getUser().then((korisnik){
      dajBrojeve();
      getComments();
    });
    dajRazloge();
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
                      servis
                          .reportPost(objava.id, selected.id, logovan_korisnik.id)
                          .then((value) {
                        print(value.body);
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

  void dajBrojeve(){
    servis.fetchinfoObjava(objava.id, logovan_korisnik.id).then((response){
      print('response body je ' + response.body);
      var pom = json.decode(response.body);
      setState(() {
        broj_lajkova = pom['brojLajkova'];
        broj_dislajkova = pom['brojDislajkova'];
        korisnik_lajkovao = pom['aktivanKorisnikLajkova'];
        korisnik_dislajkovao = pom['aktivanKorisnikDislajkova'];
        korisnik_reportovao = pom['aktivanKorisnikReportovao'];
        print('aktivnost');
        print(korisnik_lajkovao);
        print(korisnik_dislajkovao);
        print(korisnik_reportovao);
      });
    });
  }

  Widget buildText(String str){
    return Text(
      str,
      style:gf.GoogleFonts.ubuntu(),
    );
  }

  Widget buildWhiteText(String str){
    return Text(
      str,
      style:gf.GoogleFonts.ubuntu(color: Colors.white),
    );
  }

  Widget contextObjave() {
    var _buildText;

    if(objava.resena == 1){
      _buildText = buildWhiteText;
    }else{
      _buildText = buildText;
    }

    if (objava.tekstualna_objava != null) {
      return new Container(
          margin: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
          child: _buildText(objava.tekstualna_objava.tekst));
    } else if (objava.slika != null) {
      return new Container(
        child: Column(
          children: <Widget>[
            objava.slika.opis_slike != null
                ? _buildText(objava.slika.opis_slike)
                : _buildText(' '),
            SizedBox(height:10),
            Image.network(
              api_services.url_za_slike + objava.slika.urlSlike,
            )
          ],
        ),
        margin: EdgeInsets.only(right: 20.0, left: 20.0),
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 20.0),
        /*decoration: new BoxDecoration(
            border: Border(top:BorderSide(color: Colors.black54,), bottom: BorderSide(color: Colors.black54)))*/
      );
    } else {
      return Text('');
    }
  }

  void _showDialog(int idObjave) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Obriši objavu'),
            content: Text('Da li ste sigurni da želite da obrišete ovu objavu'),
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
                  print(idObjave);
                  Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context) => MyBottomBar.withIndex(0)),
                        (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        });
  }

  void _showDialogIzmena(Objava objava) {
    
    if(objava.tekstualna_objava != null){
      _izmenaObjavaController.text = objava.tekstualna_objava.tekst;
    }else if(objava.slika != null){
      _izmenaObjavaController.text = objava.slika.opis_slike;
    }else{
      _izmenaObjavaController.text = "";
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
                        controller: _izmenaObjavaController,
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
                    servis.editTextPost(objava.id, _izmenaObjavaController.text).then((value){
                      setState(() {




                        });
                      Navigator.of(context).pop();
                    });
                  }else if(objava.slika != null){
                    print('usao u sliku');
                    servis.editOpisSlike(objava.id, _izmenaObjavaController.text).then((value){
                      setState(() {





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
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Obriši objavu"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Označi kao rešen problem"),
                ),
              ],
              onSelected: (value){
                if(value == 1){
                  _showDialog(objava.id);
                }else if(value == 2){
                  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ListOfResenihComments(objava.id, logovan_korisnik.id)
                                /*prikazMape(latitude, longitude)*/));
                }
              },
        );

  Widget _simplePopup2(Objava objava) => PopupMenuButton<int>(
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Obriši objavu"),
                ),
              ],
              onSelected: (value){
                if(value == 1){
                  _showDialog(objava.id);
                }
              },
        );

  Widget printObjave() {
    var _buildText = buildText;

    if(objava.resena == 1){
          _buildText = buildWhiteText;
        }else{
          _buildText = buildText;
        }

    Widget slika;

    if(objava.vlasnik.url_slike != null){
      slika = Container(
        width: 50.0,
        height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(api_services.url_za_slike + objava.vlasnik.url_slike,
            ),fit:BoxFit.fill)
            
          ),
        );
    }else{
      slika = Icon(Icons.account_circle, size:25.0);
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
                  )
                ),
              ],
              //border: Border.all(color: Colors.grey),
              color:
                  objava.resena == 1 ? Color(0xFF49c486): Colors.white),
      child: new Column(
        //jedna kolona, koja ce da sadrzi 2 ili 3 reda
        children: <Widget>[
          new Container(
                //decoration: BoxDecoration(border: Border.all(width:1)),
                
                child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //prvi red slika i ime i prezime
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        new Container(
                          child: new SizedBox(
                            child: slika,
                          ),
                          margin: EdgeInsets.only(
                              left: 20.0, top: 10.0, right: 15.0, bottom: 10.0),
                        ),
                        new Container(
                          child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Container(
                            child: objava.vlasnik != null
                                ? objava.vlasnik.id == logovan_korisnik.id?
                                Text(objava.vlasnik.ime +
                                    " " +
                                    objava.vlasnik.prezime, style:gf.GoogleFonts.ubuntu(fontWeight: FontWeight.bold, 
                                    color: objava.resena == 1? Colors.white: Colors.black)):
                                    _buildText(objava.vlasnik.ime +
                                    " " +
                                    objava.vlasnik.prezime)
                                : _buildText("Null je vlasnik"),
                            margin: EdgeInsets.only(
                                left: 0.0, top: 0.0, right: 0.0, bottom: 2.0),
                          ),
                          Container(
                            child: objava.vreme !=null? _buildText(objava.vreme):_buildText(''),
                          )
                        ],)),
                      ],
                    )
                  ),
                  
                  Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child:
                  logovan_korisnik.id == objava.vlasnik.id
                      ? objava.resena == 0
                          ? _simplePopup(objava)
                          : _simplePopup2(objava)
                      : _buildText('')),
                ],
              )),
              Container(height: 0.0,width:300.0, decoration: BoxDecoration(border:Border(bottom: BorderSide(color: Colors.grey[300], width:1.5)))),
              SizedBox(height: 20.0,),
          contextObjave(),
          funkcionalnosti(),
          funkcionalnosti_info(),
        ],
      ),
    );
  }

  Widget funkcionalnosti_info(){
    return new Row(
                children: <Widget>[
                  new Container(
                    child: GestureDetector(
                        child: Text(broj_lajkova.toString(), style:TextStyle(color:objava.resena == 1? Colors.white: Colors.black)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListOfLikes(objava.id)
                                  /*prikazMape(latitude, longitude)*/));
                        }),
                    //margin:EdgeInsets.only(left:70.0),
                    padding: EdgeInsets.only(left: 60.0, right: 15.0, top: 0.0),
                  ),
                  new Container(
                    child: GestureDetector(
                        child: Text(broj_dislajkova.toString(), style:TextStyle(color:objava.resena == 1? Colors.white: Colors.black)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListOfDislikes(objava.id)
                                  /*prikazMape(latitude, longitude)*/));
                        }),
                    //margin:EdgeInsets.only(left:70.0),
                    padding: EdgeInsets.only(left: 80.0, right: 15.0, top: 0.0),
                  ),
                ],
              );
  }

  Widget funkcionalnosti() {
    return new Row(children: <Widget>[
      new Container(
        child: new IconButton(
          icon: new Icon(Icons.thumb_up, color: korisnik_lajkovao == 1? Colors.blue: objava.resena == 1? Colors.white: Colors.black),
          onPressed: () {
            print(logovan_korisnik.id.toString() + ' ' + objava.id.toString());
            servis.addLike(logovan_korisnik.id, objava.id).then((value){
              dajBrojeve();
            });
          },
        ),
        //margin:EdgeInsets.only(left:70.0),
        padding: EdgeInsets.only(left: 40.0, right: 15.0, top: 10.0),
      ),
      new Container(
        child: new IconButton(
          icon: new Icon(Icons.thumb_down, color: korisnik_dislajkovao == 1? Colors.red: objava.resena == 1? Colors.white: Colors.black),
          onPressed: () {
            servis.addDislike(logovan_korisnik.id, objava.id).then((value){
              dajBrojeve();
            });
          },
        ),
        //margin:EdgeInsets.all(20.0),
        padding: EdgeInsets.only(left: 40.0, right: 15.0, top: 10.0),
      ),
      new Container(
        child: new IconButton(
          icon: new Icon(Icons.report, color: korisnik_reportovao== 1? Colors.red: objava.resena == 1? Colors.white: Colors.black),
          onPressed: () {
            reportObjave(objava);
          },
        ),
        //margin:EdgeInsets.all(20.0),
        padding: EdgeInsets.only(left: 40.0, right: 15.0, top: 10.0),
      ),
    ]);
  }

  void odaberiSliku() {

    file_comment = ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      img = true;
    });
  }

  void _prazanKomentarDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Obaveštenje', style: gf.GoogleFonts.ubuntu()),
            content: Text('Komentar mora sadržati tekst ili fotografiju', style: gf.GoogleFonts.ubuntu()),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok', style: gf.GoogleFonts.ubuntu()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void postaviKomentar() {
    int resen_problem;
    if (file_comment != null) {
      poslata_slika = 1;
      print('usao u file_comment!=null');
    } else {
      poslata_slika = 0;
    }
    if (checked_resenje == false) {
      resen_problem = 0;
    } else {
      resen_problem = 1;
    }

    if(poslata_slika == 0 && _commentController.text == ""){
      _prazanKomentarDialog();
    }else{
      servis.uploadImageComment(tmpFile, _commentController.text, logovan_korisnik.id,
            objava.id, poslata_slika, resen_problem).then((value) {
      setState(() {
        _commentController.text = "";
        img = false;
        getComments();
      });
    });
    }
  }

  double velicina(int pom) {
    return size.width / 100 * pom;
  }

   Widget showImage() {
    print('img je + ' + img.toString());
    return FutureBuilder<File>(
      future: file_comment,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        print('snapshot.connectionState je ' + snapshot.connectionState.toString());
        print('snapshot data je ' + snapshot.data.toString());
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data && img == true) {
          print('usao');
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());

          return Flexible(
            child: Image.file(
              snapshot.data,
              height: 100,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Text('');
        }
      },
    );
  }

  Widget komentarisanje(BuildContext context) {
    return Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))),
                    child: Column(
                      children: <Widget>[
                        objava.resena == 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 0.0, 0.0, 0.0),
                                        ),
                                        Text('Moguće rešenje problema:'),
                                        Checkbox(
                                            value: checked_resenje,
                                            onChanged: (bool _newValue) {
                                              setState(() {
                                                checked_resenje = _newValue;
                                              });
                                            }),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    child: showImage()
                                  )
                                  
                                ],
                              )
                            : Text(''),
                        Row(
                          children: <Widget>[
                            Container(
                                // unos komentara
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 0.0, 0.0, 0.0),
                                      hintText: 'Unesite komentar...'),
                                  controller: _commentController,
                                ),
                                decoration: BoxDecoration(
                                    border:
                                        Border(bottom: BorderSide(width: 1))),
                                width: velicina(60),
                                margin: EdgeInsets.only(right: 10)),
                            Container(
                                // galerija
                                child: IconButton(
                                    onPressed: () {
                                      if(img == false)
                                        odaberiSliku();
                                      else
                                        setState(() {
                                          img = false;
                                        });
                                    },
                                    icon: img == false? Icon(Icons.photo_album): Icon(Icons.cancel)),
                                width: velicina(16)),
                            Container(
                                // postavljanje komentara
                                child: IconButton(
                                    onPressed: () {
                                      postaviKomentar();
                                    },
                                    icon: Icon(Icons.add_comment)),
                                width: velicina(16))
                          ],
                        )
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  );
  }

  Widget build(BuildContext context) {
    setState(() {
      size = MediaQuery.of(context).size;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Objava",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        //backgroundColor:Colors.green,
      ),
      body: objava == null || logovan_korisnik==null || razlozi == null || komentari == null? 
          Center(child:new CircularProgressIndicator()):
        SingleChildScrollView(
          child:Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              printObjave(),
              komentarisanje(context),
              komentari.length != 0?
                Container(
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    komentari == null? new CircularProgressIndicator():
                    printKomentari(komentari),
                  ],)
                ):SizedBox(height:1.0),
            ],
          )));
        
  }

  void getComments() {
    servis.fetchComments(this.objava.id, logovan_korisnik.id).then(
      (response) {
        Iterable list = json.decode(response.body);
        List<Komentar> komentariList = List<Komentar>();
        komentariList = list.map((model) => Komentar.fromObject(model)).toList();
        setState(
          () {
            komentari = komentariList;
          },
        );
      },
    );
  }

  Color bojaZavisnaOdResenosti(int index) {
    if (index == 1) {
      return Color(0xFF52de97);
    } else {
      return Colors.white12;
    }
  }

  Future _getUser() async {
    return logovan_korisnik = await api_services().getUser();
  }

  Widget printKomentari(List<Komentar> komentari)
  {
    print('Komentari length je ' + komentari.length.toString());
    if(komentari.length == 0){
      return SizedBox();
    }else
    return new Column(children: komentari.map((komentar) => vratiContainerKomentar(komentar)).toList());
  }

  _showDialogEdit(int idKomentara, int idObjave, String text) {
    _izmenaController.text = text;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Izmeni komentar'),
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
                child: Text('Odustani'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Izmeni'),
                onPressed: () {
                  print('usao');
                  servis.editComment(idKomentara, _izmenaController.text).then((value){
                    getComments();
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
  
  }

  Widget vratiContainerKomentar(Komentar komentar){

    var width_screen = MediaQuery.of(context).size.width;
    var height_screen = MediaQuery.of(context).size.height;

    double getProcent(double x) {
      return width_screen * x / 100.0;
    }

    Widget slika;

    if(komentar.korisnik.url_slike != null){
      slika = Container(
        width: 40.0,
        height: 40.0,
        margin:EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.only(top:10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(api_services.url_za_slike + komentar.korisnik.url_slike,
            ),fit:BoxFit.fill)
            
          ),
        );
    }else{
      slika = Icon(Icons.account_circle, size:25.0);
    }

    var _buildText;

    if (komentar.oznacenKaoResen == 1) {
      _buildText = buildWhiteText;
    } else {
      _buildText = buildText;
    }

    _showDialog(int idKomentara) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Obriši komentar',
              style: gf.GoogleFonts.ubuntu(
                fontSize: velicina_slova_objava
              )
            ),
            content: Text('Da li ste sigurni da želite da obrišete ovaj komentar?',
              style: gf.GoogleFonts.ubuntu(
                fontSize: velicina_slova_klasik
              )
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Odustani',
              style: gf.GoogleFonts.ubuntu(
                fontSize: velicina_slova_objava
              )
            ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Obriši',
              style: gf.GoogleFonts.ubuntu(
                fontSize: velicina_slova_objava
              )
            ),
                onPressed: () {
                  servis.deleteComment(idKomentara, objava.id).then((value) {
                    setState(() {
                      getComments();
                    });
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

    return Container(
                    margin: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[350],
                              blurRadius:
                                  10.0, // has the effect of softening the shadow
                              spreadRadius:
                                  3.0, // has the effect of extending the shadow
                              offset: Offset(
                                10.0, // horizontal, move right 10
                                10.0, // vertical, move down 10
                              )),
                        ],
                        //border: Border.all(color: Colors.grey),
                        color: komentar.oznacenKaoResen == 1
                            ? Color(0xFF52de97)
                            : Colors.white),
                    /*bojaZavisnaOdResenosti(komentari[index].oznacenKaoResen)*/
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  new Container(
                              child: slika,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            ),
                            komentar.korisnik.prezime != null
                                      ? Text(komentar.korisnik.ime + ' ' + komentar.korisnik.prezime,
                                          style: gf.GoogleFonts.ubuntu(
                                              color: komentar.oznacenKaoResen == 1
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: komentar.korisnik.id ==
                                                      logovan_korisnik.id
                                                  ? FontWeight.bold
                                                  : FontWeight.normal))
                                      : Text(komentar.korisnik.ime,
                                          style: gf.GoogleFonts.ubuntu(
                                              color: komentar.oznacenKaoResen == 1
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: komentar.korisnik.id ==
                                                      logovan_korisnik.id
                                                  ? FontWeight.bold
                                                  : FontWeight.normal)),
                                ],
                              )
                            ),
                            
                            komentar.korisnik.id == logovan_korisnik.id
                                ? objava.resena == 1
                                    ? Text("")
                                    : new Container(
                                        child: Row(
                                          children: <Widget>[
                                            new IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: komentar
                                                              .oznacenKaoResen ==
                                                          1
                                                      ? Colors.white
                                                      : Colors.black),
                                              onPressed: () {
                                                if (_showDialog(
                                                        komentar.id) ==
                                                    'yes') {
                                                  print("YEEESSS");
                                                } else {
                                                  print('NOO');
                                                }
                                              }),
                                            new Container(
                                            child: new IconButton(
                                                icon: Icon(Icons.edit,
                                                    color: komentar
                                                                .oznacenKaoResen ==
                                                            1
                                                        ? Colors.white
                                                        : Colors.black),
                                                onPressed: () {
                                                  if (_showDialogEdit(
                                                          komentar.id,
                                                          objava.id, komentar.tekst) ==
                                                      'yes') {
                                                    print("YEEESSS");
                                                  } else {
                                                    print('NOO');
                                                  }
                                                }),
                                            margin: EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 0.0),
                                          )
                                          ],
                                        )
                                        ,
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 0.0),
                                      )
                                : Text("")
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            child: Text(komentar.tekst,
                              style: gf.GoogleFonts.ubuntu(
                                fontSize: velicina_slova_objava,
                                color: komentar.oznacenKaoResen == 1? Colors.white: Colors.grey[800]
                              )
                            )),
                        komentar.url_slike != null
                            ? Container(
                              margin: EdgeInsets.only(top: 20.0),
                                child: Image.network(
                                  api_services.url_za_slike +
                                      komentar.url_slike,
                                  width: getProcent(80),
                                ))
                            : Text(""),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: getProcent(10)),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                        children: <Widget>[
                                          new Container(
                                            child: new IconButton(
                                                icon: new Icon(Icons.thumb_up,
                                                    color:
                                                        komentar.korisnikLajkovao == 1
                                                            ? Colors.blue
                                                            : komentar
                                                                        .oznacenKaoResen ==
                                                                    1
                                                                ? Colors.white
                                                                : Colors.grey[800]),
                                                onPressed: () {
                                                  servis
                                                      .addLikeComment(
                                                          logovan_korisnik.id, komentar.id)
                                                      .then((value) {
                                                    setState(() {
                                                      getComments();
                                                    });
                                                  });
                                                }),
                                            //margin:EdgeInsets.only(left:70.0),
                                          ),
                                          Container(
                                            child: 
                                              komentar.brojLajkova == null
                                                  ? Text('0')
                                                  : Text(komentar
                                                      .brojLajkova
                                                      .toString()),
                                          )
                                        ],
                                      )
                                      ),
                                      
                                      Container(
                                        margin: EdgeInsets.only( left: 40 ),
                                        child: Column(
                                          children: <Widget>[
                                            new Container(
                                              child: new IconButton(
                                                icon: new Icon(Icons.thumb_down,
                                                    color: komentar
                                                                .korisnikaDislajkovao ==
                                                            1
                                                        ? Colors.red
                                                        : komentar.oznacenKaoResen == 1
                                                            ? Colors.white
                                                            : Colors.grey[800]),
                                                onPressed: () {
                                                  //print(objave[index].id);
                                                  servis
                                                      .addDislikeComment(
                                                          logovan_korisnik.id, komentar.id)
                                                      .then((value) {
                                                    setState(() {
                                                      getComments();
                                                    });
                                                  });
                                                },
                                              ),
                                              //margin:EdgeInsets.all(20.0),
                                            ),

                                            new Container(
                                              child: //GestureDetector(
                                                  /*child: */ 
                                                      komentar.brojDislajkova == null
                                                          ? Text('0')
                                                          : Text(komentar
                                                              .brojDislajkova
                                                              .toString())
                                            ),

                                          ],
                                        )
                                      ),

                                      

                                    ],
                                  )
                                ),
                                
                                Container(
                                        child: new Container(
                                          margin: EdgeInsets.only(right:getProcent(5)),
                                          child: new IconButton(
                                            icon: new Icon(Icons.report, 
                                              color: komentar.korisnikReportovao == 1?
                                                Colors.red:
                                                Colors.black
                                              ),
                                            onPressed: () {
                                              servis.reportComment(komentar.id, logovan_korisnik.id).then((value){
                                                print('status report comment je ' + value.statusCode.toString());
                                                setState(() {
                                                      getComments();
                                                    });
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                
                              ],
                            ),
                      ],
                    ));
  }
}
