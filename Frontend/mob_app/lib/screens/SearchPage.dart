import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mob_app/Widgets/PopupWidget.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/screens/ProfilePage.dart';
import 'package:mob_app/services/api_services.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchTextController = new TextEditingController();
  List<Korisnik> korisnici = List<Korisnik>();
  api_services servis = new api_services();
  static Korisnik user = Korisnik();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      print('usao u scroll controller');
    });
    super.initState();
    servis.getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    getKorisnici();
    print(user.id);
  }

  void getKorisnici() {
    print('searchTextController u getKorisnici je ' + _searchTextController.text);
    if (_searchTextController.text == "") {
      servis.fetchKorisnikePretraga("").then((response) {
      Iterable list = json.decode(response.body);
      List<Korisnik> _korisnici = List<Korisnik>();
      _korisnici = list.map((model) => Korisnik.fromObject(model)).toList();
      setState(() {
        korisnici = _korisnici;
      });
    });
    }
    servis.fetchKorisnikePretraga(_searchTextController.text).then((response) {
      Iterable list = json.decode(response.body);
      List<Korisnik> _korisnici = List<Korisnik>();
      _korisnici = list.map((model) => Korisnik.fromObject(model)).toList();
      setState(() {
        korisnici = _korisnici;
      });
    });
  }

  Widget prikazKorisnika() {
    if (korisnici.isEmpty) {
      return Text("Unesite željenog korisnika...");
    } else
      return ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: korisnici.length,
          itemBuilder: (context, index) {

            String ime_prezime;
            ime_prezime = korisnici[index].ime;
            if(korisnici[index].prezime != null){
              ime_prezime += ' ' + korisnici[index].prezime;
            }

            Widget ime_prezimeWidget = Text(ime_prezime, style: TextStyle(fontWeight: 
            korisnici[index].id == user.id? 
              FontWeight.bold:
              FontWeight.normal
            ));

            return GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage.withUser(korisnici[index])
                                /*prikazMape(latitude, longitude)*/));
              },
                child: Container(
                    margin: korisnici.length-1 != index? EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0):
                    EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
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
                    child: Row(
                      children: <Widget>[
                        new Container(
                          child: new Icon(Icons.account_circle),
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                        ),
                        ime_prezimeWidget,
                      ],
                    )));
          });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: Text(
            "Pretraga",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 20.0),
              child: TextFormField(
                
                controller: _searchTextController,
                onChanged: (_searchTextController) {
                  print('changed');
                  getKorisnici();
                  
                },
                decoration: new InputDecoration(
                  prefixIcon: Icon(
                    Icons.search
                  ),
                  contentPadding: EdgeInsets.only(left:10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  hintText: 'Pretraga...',
                ),
              ),
            ),
            prikazKorisnika(),
          ],
        )));
  }
}
