import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/screens/ProfilePage.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:google_fonts/google_fonts.dart' as gf;

class ListOfDislikes extends StatefulWidget {
  int idObjave;
  ListOfDislikes(int _idObjave){
    this.idObjave = _idObjave;
  }
  @override
  State<StatefulWidget> createState() {
    return _ListOfDislikesState(this.idObjave);
  }
}

class _ListOfDislikesState extends State<ListOfDislikes> {
  int idObjave;
  List<Korisnik> korisnici;
  _ListOfDislikesState(int _idObjave){
    this.idObjave = _idObjave;
    
  }

  api_services servis = api_services();

  Widget printDislikes() {
    return ListView.builder(itemBuilder: (context, index) {});
  }

  void getDislikes(){
    servis.fetchDislikes(this.idObjave).then(
      (response) {
        Iterable list = json.decode(response.body);
        List<Korisnik> korisniciList = List<Korisnik>();
        korisniciList = list.map((model) => Korisnik.fromObject(model)).toList();
        setState(
          () {
            korisnici = korisniciList;
            //objave = objave.reversed.toList();
          },
        );
      },
    );
  }

  Widget printKorisnici(){
    if(korisnici.isEmpty){
      return Text("Nema dislajkova");
    }else
    return ListView.builder(
      itemCount: korisnici.length,
      itemBuilder: (context,index){
        return GestureDetector(
          onTap: (){
            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage.withUser(korisnici[index])
                                /*prikazMape(latitude, longitude)*/));
          },
          child: Container(
          margin: EdgeInsets.all(10.0),
          //height: visible_comment_section[index] ?  340 : 250,
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
          decoration: 
            BoxDecoration(border: Border.all(
              color: Colors.grey, 
              width:0.01,
              
              ),
            borderRadius: BorderRadius.circular(10.0),

            color:Colors.white,
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
          child:Row(children: <Widget>[
            new Container(
              child:new Icon(Icons.account_circle),
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            ),
            korisnici[index].prezime != null?
            new Text(korisnici[index].ime + ' ' + korisnici[index].prezime):
            new Text(korisnici[index].ime)
            
          ],)
        )
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    if(korisnici == null){
      getDislikes();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Nesviđanja', style: gf.GoogleFonts.ubuntu(color: Colors.white)),
        ),
        body: Center(
          child: korisnici == null? new CircularProgressIndicator() : printKorisnici(),
        ));
  }
}
