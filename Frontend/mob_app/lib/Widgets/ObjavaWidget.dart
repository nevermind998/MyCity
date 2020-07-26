import 'package:flutter/material.dart';
import 'package:mob_app/Widgets/PopupWidget.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:mob_app/screens/ListOfComments.dart';
import 'package:mob_app/screens/ListOfDislikes.dart';
import 'package:mob_app/screens/ListOfLikes.dart';
import 'package:mob_app/services/api_services.dart';

class ObjavaWidget{

  PopupWidget _popUpWidget = PopupWidget();
  api_services servis = api_services();

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

  Widget printObjave(List<Objava> objave, Korisnik user) {
    if (objave == null) {
      return Center(child:Container(child: new CircularProgressIndicator(),padding: EdgeInsets.all(10.0),));
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
        if(objave[index].resena == 1){
          _buildText = buildWhiteText;
        }else{
          _buildText = buildText;
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
                  objave[index].resena == 1 ? Colors.lightGreen: Colors.white),
          child: new Column(
            //jedna kolona, koja ce da sadrzi 2 ili 3 reda
            children: <Widget>[
              new Container(
                //decoration: BoxDecoration(border: Border.all(width:1)),
                
                child:Row(
                //prvi red slika i ime i prezime
                children: <Widget>[
                  new Container(
                    child: new SizedBox(
                      child: new Icon(Icons.account_circle, size:60.0),
                    ),
                    margin: EdgeInsets.only(
                        left: 20.0, top: 10.0, right: 5.0, bottom: 10.0),
                  ),
                  new Container(
                    child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Container(
                      child: objave[index].vlasnik != null
                          ? objave[index].vlasnik.id == user.id?
                          Text(objave[index].vlasnik.ime +
                              " " +
                              objave[index].vlasnik.prezime, style:gf.GoogleFonts.ubuntu(fontWeight: FontWeight.bold, 
                              color: objave[index].resena == 1? Colors.white: Colors.black)):
                              _buildText(objave[index].vlasnik.ime +
                              " " +
                              objave[index].vlasnik.prezime)
                          : _buildText("Null je vlasnik"),
                      margin: EdgeInsets.only(
                          left: 0.0, top: 0.0, right: 0.0, bottom: 2.0),
                    ),
                    Container(
                      child: objave[index].vreme !=null? _buildText(objave[index].vreme):_buildText(''),
                    )
                  ],)),
                  Container(
                  margin: EdgeInsets.fromLTRB(90.0, 0.0, 0.0, 0.0),
                  child:
                  user.id == objave[index].vlasnik.id
                      ? objave[index].resena == 0
                          ? _popUpWidget.simplePopup(objave[index], context, user)
                          : _popUpWidget.simplePopup2(objave[index], context)
                      : _buildText('')),
                      
                ],
              )),
              Container(height: 0.0,width:300.0, decoration: BoxDecoration(border:Border(bottom: BorderSide(color: Colors.grey[300], width:1.5)))),
              SizedBox(height: 20.0,),
              //contextObjave(index), // vraca tekst ili sliku
              new Row(
                children: <Widget>[
                  new Container(
                    child: new IconButton(
                      icon: new Icon(Icons.thumb_up),
                      color: objave[index].korisnikLajkovao == 1
                          ? Colors.blue
                          : Colors.black,
                      onPressed: () {
                        servis.addLike(user.id, objave[index].id).then((value){
                          /*setState(() {
                            getObjave();
                          });*/
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
                          : Colors.black,
                      onPressed: () {
                        servis.addDislike(user.id, objave[index].id).then((value){
                          
                          /*setState(() {
                            getObjave();
                          });*/
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ListOfComments(objave[index], user.id)
                                /*prikazMape(latitude, longitude)*/));
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
                          : Colors.black,
                      onPressed: () {
                        print(objave[index].id);
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
                        child: _buildText(objave[index].brojDislajkova.toString()),
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
                        child: _buildText(objave[index].brojKomentara.toString()),
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
      },
    );
  }

  Widget contextObjave(int index, List<Objava> objave) {
    var _buildText;

    if(objave[index].resena == 1){
      _buildText = buildWhiteText;
    }else{
      _buildText = buildText;
    }

    if (objave[index].tekstualna_objava != null) {
      return new Container(
        margin: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
        child: _buildText(objave[index].tekstualna_objava.tekst),
      );
    } else {
      return new Container(
        child: Column(
          children: <Widget>[
            objave[index].slika.opis_slike != null
                ? _buildText(objave[index].slika.opis_slike)
                : _buildText(' '),
            Image.network(
              api_services.url_za_slike + objave[index].slika.urlSlike,
            )
          ],
        ),
        margin: EdgeInsets.only(right: 20.0, left: 20.0),
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
        /*decoration: new BoxDecoration(
            border: Border(top:BorderSide(color: Colors.black54,), bottom: BorderSide(color: Colors.black54)))*/
            
      );
    }
  }

}