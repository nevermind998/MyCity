import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mob_app/models/Komentar.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:fluttertoast/fluttertoast.dart';

class ListOfResenihComments extends StatefulWidget {
  int idObjave;
  int idKorisnika;
  ListOfResenihComments(int _idObjave, int _idKorisnika) {
    this.idObjave = _idObjave;
    this.idKorisnika = _idKorisnika;
  }
  @override
  State<StatefulWidget> createState() {
    return _ListOfResenihCommentsState(this.idObjave, this.idKorisnika);
  }
}

class _ListOfResenihCommentsState extends State<ListOfResenihComments> {
  int idObjave;
  int idKorisnika;
  List<Komentar> korisnici;
  Korisnik logovan_korisnik;
  Future<File> file_comment;
  File slika;
  int poslata_slika;
  TextEditingController _commentController = TextEditingController();
  bool checked_resenje = false;
  List<bool> cb = List<bool>();
  List<int> cekirani = List<int>();

  _ListOfResenihCommentsState(int _idObjave, int _idKorisnika) {
    this.idObjave = _idObjave;
    this.idKorisnika = _idKorisnika;
  }

  api_services servis = api_services();
  void _getUser() async {
    logovan_korisnik = await api_services().getUser();
  }

  Widget printComments() {
    return ListView.builder(itemBuilder: (context, index) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  void getComments() {
    servis.fetchReseneComments(this.idObjave).then(
      (response) {
        Iterable list = json.decode(response.body);
        List<Komentar> korisniciList = List<Komentar>();
        korisniciList =
            list.map((model) => Komentar.fromObject(model)).toList();
        setState(
          () {
            korisnici = korisniciList;
            print(korisnici);
            for (var i = 0; i < korisnici.length; i++) {
              cb.add(false);
            }
            //objave = objave.reversed.toList();
          },
        );
      },
    );
  }

  void _showDialog(int idKomentara) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Obrisi objavu'),
            content:
                Text('Da li ste sigurni da zelite da obrisete ovaj komentar'),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Delete'),
                onPressed: () {
                  servis.deleteComment(idKomentara, idObjave);
                  print(idObjave);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Color bojaZavisnaOdResenosti(int index) {
    if (index == 1) {
      return Colors.lightGreen;
    } else {
      return Colors.white12;
    }
  }

  Widget printKorisnici() {
    if (korisnici.isEmpty) {
      return Text("Nema komentara");
    } else
      return Expanded(
          child: ListView.builder(
              itemCount: korisnici.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                        ],),
                  /*bojaZavisnaOdResenosti(korisnici[index].oznacenKaoResen)*/
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          new Container(
                            child: new Icon(Icons.account_circle, size: 35.0),
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          ),
                          Column(
                            children: <Widget>[

                            Container(
                              alignment: Alignment.topLeft,
                              child:Text('@' + korisnici[index].korisnik.username,
                                style: gf.GoogleFonts.ubuntu(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold
                                )
                            )),
                            new Text(korisnici[index].korisnik.ime +
                              ' ' +
                              korisnici[index].korisnik.prezime)
                          ],)
                          ,
                          Container(
                            alignment: Alignment.topRight,
                            margin:EdgeInsets.fromLTRB(90.0, 0.0, 0.0, 0.0),
                            child:new Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              value: cb[index],
                              onChanged: (bool value) {
                                setState(() {
                                  cb[index] = value;
                                });
                              },
                            ))
                          ,
                        ],
                      ),
                      korisnici[index].url_slike != null
                          ? Image.network(
                              api_services.url_za_slike +
                                  korisnici[index].url_slike,
                            )
                          : Text(' '),
                      Container(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: Text(korisnici[index].tekst)),
                    ],
                  ),
                );
              }));
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
    servis.uploadImageComment(slika, _commentController.text, idKorisnika,
        idObjave, poslata_slika, resen_problem);
  }

  void odaberiSliku() {
    file_comment =
        ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        slika = value;
      });
    });
  }

  Widget buildText(String str) {
    return Text(
      str,
      style: gf.GoogleFonts.ubuntu(),
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (korisnici == null) {
      getComments();
    }

    double velicina(int pom) {
      return size.width / 100 * pom;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Komentari',
          style:gf.GoogleFonts.ubuntu(
            color: Colors.white
          )),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  /*Row(
                  children: <Widget>[
                    Text('Oznacite kao reseni problem:'),
                    Checkbox(value: checked_resenje, onChanged: (bool _newValue){
                      setState(() {
                        checked_resenje = _newValue;
                      });
                    })
                  ],
                ),*/
                  /*Row(
                children: <Widget>[
                  Container(child:TextField(decoration: InputDecoration(hintText: 'Unesite komentar...'), controller: _commentController,), decoration: BoxDecoration(border: Border(bottom:BorderSide(width: 1))), width: velicina(60), margin: EdgeInsets.only(right: 10)),
                  Container(child:IconButton(onPressed: (){ odaberiSliku(); }, icon: Icon(Icons.photo_album)), width: velicina(16)),
                  Container(child:IconButton(onPressed: (){ postaviKomentar(); }, icon: Icon(Icons.add_comment)), width: velicina(16))
                ],
              ),*/
                  Center(
                      child: Text(
                          'Obeležite komentare koji su vam ukazali na to da je problem rešen, ukoliko ima takvih',
                          style:gf.GoogleFonts.ubuntu(
                            fontSize: 17.0
                          )))
                ],
              ),
              width: 400,
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              /*decoration: BoxDecoration(
                border: Border.all(width: 3),
              ),*/
            ),
            korisnici == null
                ? new CircularProgressIndicator()
                : printKorisnici(),
            Container(
              child: RaisedButton(
              child: Text('Potvrdi'),
              onPressed: () {
                var pomocni = [];
                for(var i=0; i<korisnici.length; i++){
                  if(cb[i] == true){
                      pomocni.add(korisnici[i].id);
                  }
                }
                var body = jsonEncode({
                  "idKomentara":pomocni
                });
                print(body);
                servis.resenProblemSaKomentarima(body, idObjave, context).then((value){
                  
                        Navigator.of(context).pop(1);
                });
              },
            ),
              padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
            )
          ],
        ));
  }

  
}
