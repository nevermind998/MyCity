import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mob_app/models/Komentar.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Objava.dart';

class ListOfComments2 extends StatefulWidget {
  Objava objava;
  int idKorisnika;
  int resena;
  ListOfComments2(Objava _objava, int _idKorisnika, int _resen) {
    this.objava = _objava;
    this.idKorisnika = _idKorisnika;
    this.resena = _resen;
  }

  @override
  State<StatefulWidget> createState() {
    return _ListOfCommentsState2(this.objava, this.idKorisnika, this.resena);
  }
}

class _ListOfCommentsState2 extends State<ListOfComments2> {
  int broj_dodatih_komentara = 0;
  File tmpFile;
  Objava objava;
  int idKorisnika;
  List<Komentar> komentari;
  Korisnik logovan_korisnik;
  Future<File> file_comment;
  File slika;
  int poslata_slika;
  TextEditingController _commentController = TextEditingController();
  bool checked_resenje = false;
  double velicina_slova_klasik = 15.0;
  double velicina_slova_objava = 20.0;
  int resena;
  TextEditingController _izmenaController = TextEditingController();
  String base64Image;
  bool img = false;

  _ListOfCommentsState2(Objava _objava, int _idKorisnika, int _resena) {
    this.objava = _objava;
    this.idKorisnika = _idKorisnika;
    this.resena = _resena;
    print('resena je ' + resena.toString());
  }

  api_services servis = api_services();
  Future _getUser() async {
    return logovan_korisnik = await api_services().getUser();
  }

  Widget printComments() {
    return ListView.builder(itemBuilder: (context, index) {});
  }

  Widget buildText(String str, double size) {
    return Text(
      str,
      style: gf.GoogleFonts.ubuntu(fontSize: size),
    );
  }

  Widget buildWhiteText(String str, double size) {
    return Text(
      str,
      style: gf.GoogleFonts.ubuntu(color: Colors.white, fontSize: size),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser().then((value){
      getComments();
    });
  }

  void getComments() {
    if (resena == 0 || resena == 2) {
      servis.fetchComments(this.objava.id, logovan_korisnik.id).then(
        (response) {
          print('response body u ListOfComments je ' + response.body);
          Iterable list = json.decode(response.body);
          List<Komentar> komentariList = List<Komentar>();
          komentariList =
              list.map((model) => Komentar.fromObject(model)).toList();
          setState(
            () {
              komentari = komentariList;
              //objave = objave.reversed.toList();
            },
          );
        },
      );
    } else {
      servis.fetchKomentareKaoReseni(this.objava.id).then(
        (response) {
          Iterable list = json.decode(response.body);
          List<Komentar> komentariList = List<Komentar>();
          komentariList =
              list.map((model) => Komentar.fromObject(model)).toList();
          setState(
            () {
              komentari = komentariList;
              //objave = objave.reversed.toList();
            },
          );
        },
      );
    }
  }

  _showDialog(int idKomentara, int idObjave) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Obrisi komentar', velicina_slova_klasik),
            content: buildText(
                'Da li ste sigurni da zelite da obrisete ovaj komentar',
                velicina_slova_klasik),
            actions: <Widget>[
              FlatButton(
                child: buildText('Odustani', velicina_slova_klasik),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: buildText('Obriši', velicina_slova_klasik),
                onPressed: () {
                  servis.deleteComment(idKomentara, idObjave).then((value) {
                    setState(() {
                      getComments();
                    });
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
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

  Color bojaZavisnaOdResenosti(int index) {
    if (index == 1) {
      return Color(0xFF6ce6a8);
    } else {
      return Colors.white12;
    }
  }

  Widget printKomentari() {
    if (komentari.isEmpty) {
      return Center(
          child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: resena != 1? buildText(
                  "Objava trenutno nema komentara, budite prvi koji ćete komentarisati.",
                  velicina_slova_klasik):
                  buildText(
                  "Korisnik nije odabrao ni jedan komentar kao rešenje problema.",
                  velicina_slova_klasik)
                  )
        ],
      ));
    } else
      return Expanded(
          child: ListView.builder(
              itemCount: komentari.length,
              itemBuilder: (context, index) {
                var width_screen = MediaQuery.of(context).size.width;
                var height_screen = MediaQuery.of(context).size.height;

                double getProcent(double x) {
                  return width_screen * x / 100.0;
                }

                Widget slika;

                if (komentari[index].korisnik.url_slike != '') {
                  slika = Container(
                    width: 40.0,
                    height: 40.0,
                    margin: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              api_services.url_za_slike +
                                  komentari[index].korisnik.url_slike,
                            ),
                            fit: BoxFit.fill)),
                  );
                } else {
                  slika = Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.account_circle, size: 25.0));
                }

                var _buildText;

                if (komentari[index].oznacenKaoResen == 1) {
                  _buildText = buildWhiteText;
                } else {
                  _buildText = buildText;
                }

                return Container(
                    margin: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
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
                        color: komentari[index].oznacenKaoResen == 1
                            ? Color(0xFF49c486)
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
                                    margin:
                                        EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                                  ),
                                  komentari[index].korisnik.prezime != null
                                      ? Text(komentari[index].korisnik.ime + ' ' + komentari[index].korisnik.prezime,
                                          style: gf.GoogleFonts.ubuntu(
                                              color: komentari[index].oznacenKaoResen == 1
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: komentari[index].korisnik.id ==
                                                      logovan_korisnik.id
                                                  ? FontWeight.bold
                                                  : FontWeight.normal))
                                      : Text(komentari[index].korisnik.ime,
                                          style: gf.GoogleFonts.ubuntu(
                                              color: komentari[index].oznacenKaoResen == 1
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: komentari[index].korisnik.id ==
                                                      logovan_korisnik.id
                                                  ? FontWeight.bold
                                                  : FontWeight.normal))
                                ],
                            ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: komentari[index].korisnik.id == logovan_korisnik.id
                                    ? objava.resena >0
                                        ? _buildText("", velicina_slova_klasik)
                                        : new Container(
                                            alignment: Alignment.topRight,
                                            child: new IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: komentari[index]
                                                                .oznacenKaoResen ==
                                                            1
                                                        ? Colors.white
                                                        : Colors.black),
                                                onPressed: () {
                                                  if (_showDialog(
                                                          komentari[index].id,
                                                          objava.id) ==
                                                      'yes') {
                                                    print("YEEESSS");
                                                  } else {
                                                    print('NOO');
                                                  }
                                                }),
                                            margin: EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 0.0),
                                          )
                                    : _buildText("", velicina_slova_klasik),
                                ),
                                Container(
                                  child: komentari[index].korisnik.id == logovan_korisnik.id
                                    ? objava.resena >0
                                        ? _buildText("", velicina_slova_klasik)
                                        : new Container(
                                            alignment: Alignment.topRight,
                                            child: new IconButton(
                                                icon: Icon(Icons.edit,
                                                    color: komentari[index]
                                                                .oznacenKaoResen ==
                                                            1
                                                        ? Colors.white
                                                        : Colors.black),
                                                onPressed: () {
                                                  if (_showDialogEdit(
                                                          komentari[index].id,
                                                          objava.id, komentari[index].tekst) ==
                                                      'yes') {
                                                    print("YEEESSS");
                                                  } else {
                                                    print('NOO');
                                                  }
                                                }),
                                            margin: EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 0.0),
                                          )
                                    : _buildText("", velicina_slova_klasik),
                                )
                              ],
                            ),
                            
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                            child: _buildText(
                                komentari[index].tekst, velicina_slova_objava)),
                        komentari[index].url_slike != null
                            ? Container(
                                child: Image.network(
                                  api_services.url_za_slike +
                                      komentari[index].url_slike,
                                  width: getProcent(80),
                                ),
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0))
                            : _buildText('', velicina_slova_klasik),
                            Container(
                              margin: EdgeInsets.only(left: getProcent(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                    children: <Widget>[
                                      new Container(
                                        child: new IconButton(
                                            icon: new Icon(Icons.thumb_up,
                                                color:
                                                    komentari[index].korisnikLajkovao == 1
                                                        ? Colors.blue
                                                        : komentari[index]
                                                                    .oznacenKaoResen ==
                                                                1
                                                            ? Colors.white
                                                            : Colors.grey[800]),
                                            onPressed: () {
                                              servis
                                                  .addLikeComment(
                                                      idKorisnika, komentari[index].id)
                                                  .then((value) {
                                                setState(() {
                                                  getComments();
                                                });
                                              });
                                            }),
                                        //margin:EdgeInsets.only(left:70.0),
                                      ),
                                      Container(
                                        child: _buildText(
                                          komentari[index].brojLajkova == null
                                              ? '0'
                                              : komentari[index]
                                                  .brojLajkova
                                                  .toString(),
                                          velicina_slova_klasik),
                                      )
                                    ],
                                  )
                                  ),
                                  
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        new Container(
                                          child: new IconButton(
                                            icon: new Icon(Icons.thumb_down,
                                                color: komentari[index]
                                                            .korisnikaDislajkovao ==
                                                        1
                                                    ? Colors.red
                                                    : komentari[index].oznacenKaoResen == 1
                                                        ? Colors.white
                                                        : Colors.grey[800]),
                                            onPressed: () {
                                              //print(objave[index].id);
                                              servis
                                                  .addDislikeComment(
                                                      idKorisnika, komentari[index].id)
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
                                              /*child: */ _buildText(
                                                  komentari[index].brojDislajkova == null
                                                      ? '0'
                                                      : komentari[index]
                                                          .brojDislajkova
                                                          .toString(),
                                                  velicina_slova_klasik),
                                          /*onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListOfDislikes(objave[index].id)
                                                        /*prikazMape(latitude, longitude)*/));
                                              }),*/
                                          //margin:EdgeInsets.only(left:70.0),
                                        ),

                                      ],
                                    )
                                  ),
                                  Container(
                                    child: new Container(
                                      margin: EdgeInsets.only(right:getProcent(5)),
                                      child: new IconButton(
                                        icon: new Icon(Icons.report, color:komentari[index].korisnikReportovao == 1?
                                          Colors.red:
                                          komentari[index].oznacenKaoResen == 1?
                                            Colors.white:
                                            Colors.grey[800]
                                        ),
                                        onPressed: () {
                                          servis.reportComment(komentari[index].id, idKorisnika).then((value){
                                            print('Status kod od reporta ' + value.statusCode.toString());
                                          setState(() {
                                            getComments();
                                          });
                                          });
                                        },
                                      ),
                                      //margin:EdgeInsets.all(20.0),
                                    ),
                                  )

                                  

                                ],
                              )
                            ),
                            
                            /*Container(
                                    child: new Container(
                                      margin: EdgeInsets.only(right:getProcent(5)),
                                      child: new IconButton(
                                        icon: new Icon(Icons.report, color:komentari[index].korisnikReportovao == 1?
                                          Colors.red:
                                          komentari[index].oznacenKaoResen == 1?
                                            Colors.white:
                                            Colors.grey[800]
                                        ),
                                        onPressed: () {
                                          servis.reportComment(komentari[index].id, idKorisnika).then((value){
                                            print('Status kod od reporta ' + value.statusCode.toString());
                                          setState(() {
                                            getComments();
                                          });
                                          });
                                        },
                                      ),
                                      //margin:EdgeInsets.all(20.0),
                                    ),
                                  )*/
                            
                      ],
                    ));
              }));
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
      broj_dodatih_komentara++;
      servis.uploadImageComment(tmpFile, _commentController.text, idKorisnika,
            objava.id, poslata_slika, resen_problem).then((value) {
              setState(() {
                _commentController.text = "";
                img = false;
                  getComments();
              });
    });
    }
  }

  void odaberiSliku() {

    file_comment = ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      img = true;
    });
  }

  Widget showImage() {
    print('img je + ' + img.toString());
    file_comment.then((value){
      if(value == null){
        setState(() {
          img = false;
          file_comment = null;
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double velicina(int pom) {
      return size.width / 100 * pom;
    }

    return new WillPopScope(
      onWillPop: () async{
        print('otisao nazad');
        Navigator.of(context).pop(broj_dodatih_komentara);
      },
    child: Scaffold(
        appBar: resena == 0
            ? AppBar(
                title: Text('Komentari',
                    style: gf.GoogleFonts.ubuntu(
                        color: Colors.white, fontSize: 20)))
            : null,
        body: Column(
          children: <Widget>[
            komentari == null
                ? Container(
                    child: new CircularProgressIndicator(),
                    margin: EdgeInsets.all(20.0))
                : printKomentari(),
            resena != 1
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))),
                    child: Column(
                      children: <Widget>[
                        Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                   objava.lepaKategorija==null && resena == 0? Container(
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 0.0, 0.0, 0.0),
                                        ),
                                        buildText('Moguće rešenje problema:',
                                            velicina_slova_klasik),
                                        Checkbox(
                                            value: checked_resenje,
                                            onChanged: (bool _newValue) {
                                              setState(() {
                                                checked_resenje = _newValue;
                                              });
                                            }),
                                      ],
                                    ),
                                  ):Text(''),
                                  file_comment != null?
                                  Container(
                                    child: showImage()
                                  ):SizedBox()
                                  
                                ],
                              ),
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
                                      Fluttertoast.showToast(
                                        msg: "Objavljivanje je u toku... Molimo sačekajte trenutak, komentar će se uskoro prikazati.",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Color(0xFF49c486),
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                    },
                                    icon: Icon(Icons.add_comment)),
                                width: velicina(16))
                          ],
                        )
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  )
                : Text('')
          ],
        )));
  }
}

class ListOfComments extends StatefulWidget {
  Objava objava;
  int idKorisnika;
  ListOfComments(Objava _objava, int _idKorisnika) {
    this.objava = _objava;
    this.idKorisnika = _idKorisnika;
  }
  @override
  State<StatefulWidget> createState() {
    return _ListOfCommentsState(this.objava, this.idKorisnika);
  }
}

class _ListOfCommentsState extends State<ListOfComments> {
  Objava objava;
  int idKorisnika;

  double velicina_slova_klasik = 15.0;
  double velicina_slova_objava = 20.0;

  _ListOfCommentsState(Objava _objava, int _idKorisnika) {
    this.objava = _objava;
    this.idKorisnika = _idKorisnika;
  }

  Widget buildText(String str, double size) {
    return Text(
      str,
      style: gf.GoogleFonts.ubuntu(fontSize: size),
    );
  }

  Widget buildWhiteText(String str, double size) {
    return Text(
      str,
      style: gf.GoogleFonts.ubuntu(color: Colors.white, fontSize: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final _kTabs = <Tab>[
      Tab(icon: Icon(Icons.check_circle_outline), text: 'Rešeni komentari'),
      Tab(icon: Icon(Icons.mode_comment), text: 'Svi komentari'),
    ];

    final _kTabPages = <Widget>[
      ListOfComments2(objava, idKorisnika, 1), // reseni
      ListOfComments2(
          objava, idKorisnika, 2), // resen problem ali nereseni komentari
    ];

    if (objava.resena > 0) {
      print('Usao u resena = 1');
      return DefaultTabController(
          length: _kTabs.length,
          child: Scaffold(
              appBar: AppBar(
                  title: Text('Komentari',
                      style: gf.GoogleFonts.ubuntu(
                          color: Colors.white, fontSize: 20)),
                  bottom: TabBar(tabs: _kTabs)),
              body: TabBarView(
                children: _kTabPages,
              )));
    } else {
      print('Usao u resena = 0');
      return ListOfComments2(objava, idKorisnika, 0);
    }
  }
}
