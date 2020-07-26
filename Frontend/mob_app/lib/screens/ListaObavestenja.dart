import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mob_app/Widgets/PopupWidget.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/models/Obavestenje.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:mob_app/screens/OdvojenaObjava.dart';
import 'package:mob_app/screens/ProfilePage.dart';
import 'package:mob_app/services/api_services.dart';

class ListaObavestenja extends StatefulWidget {
  @override
  _ListaObavestenjaState createState() => _ListaObavestenjaState();
}

class _ListaObavestenjaState extends State<ListaObavestenja> {
  api_services servis = new api_services();
  static Korisnik user = Korisnik();
  List<Obavestenje> obavestenja = List<Obavestenje>();

  @override
  void initState() {
    super.initState();
    servis.getUser().then((value) {
      setState(() {
        user = value;
      });
      dajObavestenja();
    });
  }

  void dajObavestenja(){
    servis.dajObavestenje(user.id).then((response) {
      print('response body u obavestenjima je ' + response.statusCode.toString());
      Iterable list = json.decode(response.body);
      setState(() {
        obavestenja = list.map((model) => Obavestenje.fromObject(model)).toList();
      });
    });
  }

  Widget obavestenjeLajk(int index){
    String username;

    username = '@' + obavestenja[index].korisnik.username;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child:Flexible(
            child:Text('Korisnik ' + username + ' je obeležio da mu se sviđa Vaša objava.', textAlign: TextAlign.left)
          ) 
        ),
        malaObjava(obavestenja[index].objava)
      ],
    );
  }

  Widget malaObjava(Objava objava){
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5),
          bottom: BorderSide(width: 0.5)
        )
      ),
      child: objava.tekstualna_objava!= null?
          Text(objava.tekstualna_objava.tekst):
        objava.slika != null?
          Column(
            children: <Widget>[
              Text(objava.slika.opis_slike),
              SizedBox(height: 10),
              Container(
                height:100,
                width:200,
                child: Image.network(api_services.url_za_slike + objava.slika.urlSlike)
              )
            ],
          ):
          Text('')
    );
  }

  Widget obavestenjeKomentar(int index){
    String username;

    username = '@' + obavestenja[index].korisnik.username;

    return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child:Flexible(
                child:Text('Korisnik ' + username + ' je komentarisao objavu koju ste Vi objavili.', textAlign: TextAlign.left)
              ) 
            ),
            malaObjava(obavestenja[index].objava)
          ],
        );
  }

  Widget obavestenjeResenje(int index){
    String username;

    username = '@' + obavestenja[index].korisnik.username;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child:Flexible(
            child:Text('Korisnik ' + username + ' je predložio rešenje u komentaru na objavi koju ste Vi objavili.', textAlign: TextAlign.left)
          ) 
        ),
        malaObjava(obavestenja[index].objava)
      ],
    );
  }


  Widget prikaziObjave() {
    if (obavestenja.isEmpty) {
      return Center(child:Container(child:Text("Nemate obavestenja..."), margin: EdgeInsets.only(top:30)) );
    } else
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: obavestenja.length,
          itemBuilder: (context, index) {

            String ime_prezime;
            ime_prezime = obavestenja[index].korisnik.ime;
            if(obavestenja[index].korisnik.prezime != null){
              ime_prezime += ' ' + obavestenja[index].korisnik.prezime;
            }

            return GestureDetector(
              onTap: (){
                Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OdvojenaObjava(obavestenja[index].objava)
                                /*prikazMape(latitude, longitude)*/));
              },
                child: Container(
                    margin: obavestenja.length-1 != index? EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0):
                    EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
                    //height: visible_comment_section[index] ?  340 : 250,
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                    decoration:
                        BoxDecoration(border: Border.all(
                          color: Colors.grey, 
                          width:0.01,
                          
                          ),
                        borderRadius: BorderRadius.circular(10.0),

                        color: obavestenja[index].procitano == 0? Colors.grey[300] : Colors.white ,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[400],
                            blurRadius: 2.0, // has the effect of softening the shadow
                            spreadRadius: 1.0, // has the effect of extending the shadow
                            offset: Offset(
                              3.0, // horizontal, move right 10
                              3.0, // vertical, move down 10
                            )
                          ),
                      ]),
                    child: obavestenja[index].lajkID != 0?
                        obavestenjeLajk(index):
                      obavestenja[index].komentarID != 0?
                        obavestenjeKomentar(index):
                      obavestenja[index].resena != 0?
                        obavestenjeResenje(index):
                      Text("nije lajk")
                    ));
          });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: Text(
            "Obaveštenja",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: obavestenja == null? 
        Center(child: CircularProgressIndicator(),)
         :SingleChildScrollView(
            child: Column(
          children: <Widget>[
            prikaziObjave(),
          ],
        )));
  }
}
