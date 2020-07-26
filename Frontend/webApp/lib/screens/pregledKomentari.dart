import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:webApp/models/Komentar.dart';
import 'package:webApp/models/KomentariObjave.dart';
import 'package:webApp/models/Korisnik.dart';
import 'package:webApp/models/Pretraga.dart';
import 'package:webApp/services/api_services.dart';

import 'AppBarPage.dart';
import 'loginPage.dart';

class PregledKomentara extends StatefulWidget {
  //PregledKomentara({Key key}) : super(key: key);

  _PregledKomentaraState createState() => _PregledKomentaraState();

}

class _PregledKomentaraState extends State<PregledKomentara> {
  bool checked_resenje=false;
  String str="";
  Korisnik logovan_korisnik;

  void _getUser() async {
    logovan_korisnik = await api_services().getUserSession();
  }
  List<Komentar> komentari;
  int idObjave;

  api_services servis = api_services();

  List<Pretrazivanje> sortiraj=List<Pretrazivanje>();
  Pretrazivanje sortirajSelected;

  List<Pretrazivanje> sortKategorija=List<Pretrazivanje>();
  Pretrazivanje sortKategorijaSelected;

  void initState() {
    if(html.window.sessionStorage.length==0)
    {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
    sortiraj.add(new Pretrazivanje(0, "Rastuće"));
    sortiraj.add(new Pretrazivanje(1, "Opadajuće"));
    sortirajSelected=sortiraj[0];

    sortKategorija.add(new Pretrazivanje(0, "Svidjanja"));
    sortKategorija.add(new Pretrazivanje(1, "Ne svidjanja"));
    sortKategorija.add(new Pretrazivanje(2, "Prijava"));
    sortKategorijaSelected=sortKategorija[0];
    idObjave=int.parse(html.window.sessionStorage['zaKomentare']);
    super.initState();
    _getUser();

    getKomentari();
  }

  void getKomentari() {

    servis.fetchComments(idObjave).then((response) {
        Iterable list = json.decode(response.body);
        List<Komentar> korisniciList = List<Komentar>();
        korisniciList =
            list.map((model) => Komentar.fromObject(model)).toList();
        setState(
              () {
            komentari = korisniciList;

          },
        );
      },
    );
  }

  List<DropdownMenuItem<Pretrazivanje>> buildDropdownMenuItemsPretrazivanje(List<Pretrazivanje> _pretrazi) {
    List<DropdownMenuItem<Pretrazivanje>> items1 = List();

    for (Pretrazivanje pret in _pretrazi) {
      items1.add(
        DropdownMenuItem(
          value: pret,
          child:Text(pret.ime),
        ),
      );
    }
    return items1;
  }

  Widget Fja(int index)
  {
    if(komentari.isEmpty)
    {
      return new Container(
        child: Text("Nema komentara za prikaz"),
      );
    }
    else
    {
      if(komentari[index].url_slike!=null)
      {
        return new Container(
          width: 200.0,
          margin: EdgeInsets.only(top:10.0,bottom:10.0),
          child:new Container(
            margin: EdgeInsets.only(top:20.0),
            child: new Column(
              children: <Widget>[
                /*new Container(
                    margin: EdgeInsets.only(top:10.0),
                      child:Text(komentari[index].tekst),
                  ),*/
                new Container(
                    margin: EdgeInsets.only(top:20.0,left:10.0,bottom:2.0),
                    //padding:EdgeInsets.all(5.0),
                    child:SizedBox(
                      child:Image.network(
                        api_services.url_za_slike + komentari[index].url_slike,
                      ),
                      height: 100.0,
                      width: 100.0,
                    )
                ),

              ],
            ),
          ),
        );
      }
      else
      {
        return new Container(
          width: 200.0,
          margin: EdgeInsets.only(top:50.0),
          child:Text(komentari[index].tekst),
        );
      }
    }
  }


  Color bojaZavisnaOdResenosti(int index){
    if(index == 1){
      return Color.fromRGBO(120, 249, 133, 0.4);
    }else{
      return Colors.white12;
    }
  }



double sirina,visina;

  void _showDialog(int rbr) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: new Container(
              width: 400,
              height: 400,
              margin: EdgeInsets.all(20.0),
              child:Image.network(api_services.url_za_slike+komentari[rbr].url_slike)
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Zatvori'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget prikaziKomentare()
  {
    sirina=MediaQuery.of(context).size.width;
    visina=MediaQuery.of(context).size.height;
    if (komentari == null) {
      return new Center(child:Text("Nema komentara"));
    }

    return GridView.builder(
      itemCount: komentari.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (sirina > 1500) ? 5  : (sirina >1200? 4 :  (sirina>920? 3 : (sirina-250>420?2:1) )  ),
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio:  (sirina > 1500) ? 1.6  : (sirina - 200> 1100? 1.6 :  (sirina-100>800? 1.6 : (sirina-100>600?1.6:2.0) )  ),
      ),
      itemBuilder: (context, index) {
        return Container(
          width: 300,
          margin: EdgeInsets.all(5.0),
          //height: visible_comment_section[index] ?  340 : 250,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: bojaZavisnaOdResenosti(komentari[index].oznacenKaoResen)  /*bojaZavisnaOdResenosti(korisnici[index].oznacenKaoResen)*/
          ),

          child: Container(
            width: 300,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left:10,top:3,right: 20),
                      child: Wrap(
                        direction: Axis.vertical,
                        children: <Widget>[
                          new Text("@"+komentari[index].korisnik.username),
                          komentari[index].korisnik.uloga=="institucija"?
                          new Text(komentari[index].korisnik.ime):
                          Text(komentari[index].korisnik.ime+" "+komentari[index].korisnik.prezime),
                        ],
                      ),
                    ),
                    komentari[index].oznacenKaoResen==0?
                    new Container(
                      //margin: EdgeInsets.only(left:25),
                      child: new IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                              _showDialogBrisanjeKomentar(komentari[index]);
                          }),
                    ):Text(""),
                    komentari[index].url_slike!=null
                        ? new Container(
                      //margin: EdgeInsets.only(left:5),
                      child: Tooltip(
                        message: "Slika komentara",
                        child: new IconButton(
                            icon: Icon(Icons.image,color: Colors.black,),
                            onPressed: () {
                                _showDialog(index);
                            }),
                      ),
                    ):Text("")

                  ],
                ),

               Container(
                   margin: EdgeInsets.only(top:(MediaQuery.of(context).size.width/100),left:(MediaQuery.of(context).size.width/100)),
                   alignment: Alignment.bottomLeft,
                   width: 220,
                   child: komentari[index].tekst!=null?Text(komentari[index].tekst):Text("")
               ),


                Container(
                  alignment: Alignment.bottomLeft,
                  width: 300,
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          new Container(
                            child: new IconButton(
                              icon: new Icon(Icons.thumb_up,color: Colors.black,size: 20),
                              onPressed: () {

                              },
                            ),
                          ),
                          new Container(
                            child: GestureDetector(
                              child: Text(komentari[index].brojLajkova.toString()),
                            ),
                            padding: EdgeInsets.only(
                                left: 10.0),
                          ),
                          new Container(
                            child: new IconButton(
                              icon: new Icon(Icons.thumb_down,color: Colors.black,size: 20),
                              onPressed: () {
                              },
                            ),

                            padding: EdgeInsets.only(
                                left: 10.0, top: 0.0),
                          ),
                          new Container(
                            child: GestureDetector(
                              child:  Text(komentari[index].brojDislajkova.toString()),
                            ),

                            padding: EdgeInsets.only(
                                left: 10.0, right: 20.0, top: 0.0),
                          ),
                          new Container(
                            child: new IconButton(
                              icon: Icon(Icons.report,size: 20,color:Colors.black),
                              onPressed: () {
                              },
                            ),

                          )
                        ],
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),

        );
      },
    );

  }

  void sortiralica()
  {
    if(sortKategorijaSelected.id==0)
    {
      if(sortirajSelected.id==1)
      {
        komentari.sort((a,b) => b.brojLajkova.compareTo(a.brojLajkova));
      }
      else
      {
        komentari.sort((a,b) => a.brojLajkova.compareTo(b.brojLajkova));

      }
    }
    if(sortKategorijaSelected.id==1)
    {
      if(sortirajSelected.id==1)
      {
        komentari.sort((a,b) => b.brojDislajkova.compareTo(a.brojDislajkova));
      }
      else
      {
        komentari.sort((a,b) => a.brojDislajkova.compareTo(b.brojDislajkova));

      }
    }
    if(sortKategorijaSelected.id==2)
    {
      if(sortirajSelected.id==1)
      {
        komentari.sort((a,b) => b.brojReporta.compareTo(a.brojReporta));
      }
      else
      {
        komentari.sort((a,b) => a.brojReporta.compareTo(b.brojReporta));

      }
    }
    prikaziKomentare();
  }

  bool flag=true;

  @override
  Widget build(BuildContext context) {

    if(komentari==null)
    {
      getKomentari();
    }
    Size size = MediaQuery.of(context).size;
    double velicina(int pom){
      return size.width/100 * pom;
    }

    return new Scaffold(
        body:SingleChildScrollView(
          child:Center(
            //width: MediaQuery.of(context).size.width-200,
            //padding: EdgeInsets.only(top:10,bottom:10,left:250,right:250),
            child:Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  alignment:Alignment.topLeft,
                  child: RaisedButton(
                    child: html.window.sessionStorage['strana']!="post"?Text("Povratak na profil korisnika"):Text("Povratak na objave"),
                    onPressed: (){
                      if(html.window.sessionStorage['strana']=="post")
                      {
                        setState(() {
                          AppBarPageState.trenIndex=2;
                        });
                        Navigator.pushNamed(context,"/appbarWeb" );
                      }
                      else
                      {
                        html.window.sessionStorage['Idkorisnika']=html.window.sessionStorage['strana'];
                        setState(() {
                          AppBarPageState.trenIndex=4;
                        });
                        Navigator.pushNamed(context,"/appbarWeb" );
                      }
                    },
                  ),
                ),
                Container(
                    width: sirina,
                    // color:Colors.red,
                    padding: EdgeInsets.all(10.0),
                    child: new Wrap(
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(top:15),
                          child: Text("Sortiraj po broju: ",style: TextStyle(fontSize: 18),),
                        ),
                        SizedBox(width: 10,),
                        new Container(
                          child:new DropdownButton(
                              items: buildDropdownMenuItemsPretrazivanje(sortKategorija),
                              value: sortKategorijaSelected,
                              onChanged: (value) {
                                setState(() {
                                  sortKategorijaSelected = value;
                                  sortiralica();
                                });
                              }
                          ),
                        ),
                        SizedBox(width: 10,),
                        new Container(
                          child:new DropdownButton(

                              items: buildDropdownMenuItemsPretrazivanje(sortiraj),
                              value: sortirajSelected,
                              onChanged: (value) {
                                setState(() {
                                  sortirajSelected = value;
                                  sortiralica();
                                });
                              }
                          ),
                        ),
                      ],
                    )
                ),
                komentari!=null && komentari.length==0?
                    Container(
                      child: Text("Nema komentara"),
                    ):prikaziKomentare(),


              ],
            ),
          ),
        )
    );
  }

  void _showDialogBrisanjeKomentar(Komentar a) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Brisanje komentara korisnika"),
          content: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Text('Da li ste sigurni da želite da obrišete komentar koji je postavio korisnik '),
                Text("@"+a.korisnik.username,style: TextStyle(fontStyle: FontStyle.italic),),
                Text("?")
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Odustani'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('Potvrdi'),
              onPressed: () {
                servis.obrisiKomentare(a.id);
                setState(() {
                  komentari.remove(a);
                  prikaziKomentare();
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}