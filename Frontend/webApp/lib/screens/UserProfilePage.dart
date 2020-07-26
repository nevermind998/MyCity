import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webApp/models/Grad.dart';
import 'package:webApp/models/Report.dart';
import '../models/Korisnik.dart';
import '../models/Objava.dart';
import 'dart:html' as html;
import '../services/api_services.dart';


import 'appBarPage.dart';
import 'loginPage.dart';
class ProfileUserPage extends StatefulWidget {
  Korisnik user;
  ProfileUserPageState profil;

  @override
  ProfileUserPageState createState() {
    profil = ProfileUserPageState();
    return profil;
  }
}

class ProfileUserPageState extends State<ProfileUserPage> {

  List<Korisnik>korisnicii=List<Korisnik>();

  double visina=40;
  double sirina=250;
  double sirina1;

  TextEditingController _poeniController = new TextEditingController();
  bool azuriranje_aktivno=false;
  @override
  Korisnik logovan_user;
  Korisnik user;
  api_services servis = api_services();
  List<Objava> objave=List<Objava> ();
  List<Grad> gradovi_korisnika=List<Grad> ();
  int pom;
  void initState() {
    if(html.window.sessionStorage.length==0)
    {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
    super.initState();
    if(html.window.sessionStorage['Idkorisnika'].length!=0)
    {
      pom=int.parse(html.window.sessionStorage['Idkorisnika']);
      getKorisnikaaa(pom);
    }

  }
  void getKorisnikaaa(int id) {
    servis.fetchKorisnik(id).then((response) {
        Map<String, dynamic> jsonObject  = json.decode(response.body);
        Korisnik s = new Korisnik();
        s = Korisnik.fromObject(jsonObject);
        setState(() {
          user=s;
        });
      },
    );
  }


  void getObjave() {
    servis.fetchObjaveByIdKorisnika(user.id).then((response) {
        Iterable list = json.decode(response.body);
        List<Objava> objaveList = List<Objava>();
        objaveList = list.map((model) => Objava.fromObject(model)).toList();
        setState(
              () {
            objave = objaveList;
          },
        );
      },
    );
  }

  void getObjave1() {
    servis.fetchObjaveGradaInstitucijeKojejesuResene(user.id).then((response) {
        Iterable list = json.decode(response.body);
        List<Objava> objaveList = List<Objava>();
        objaveList = list.map((model) => Objava.fromObject(model)).toList();
        setState(
              () {
            objave = objaveList;

          },
        );
      },
    );
  }

  List<Report> rep=null;
  void getReports(int idObjave){
    servis.getReport(idObjave).then((response) {
      Iterable list = json.decode(response.body);
      List<Report> korisniciList = List<Report>();
      korisniciList = list.map((model) => Report.fromObject(model)).toList();
      setState(
            () {
          rep = korisniciList;
        },
      );
      _showDialogReport(rep.length);
    },
    );
  }

  void _showDialogReport(int broj) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              width: 530,
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Text("Korisnici koji su prijavili objavu kao neprikladnu i razlog prijave:",style: TextStyle(
                          fontSize: 16,fontWeight: FontWeight.bold
                      ),),
                    ),
                    rep.length>0?Container(
                      child: ListView.builder(
                          itemCount: rep.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5.0),
                                //height: visible_comment_section[index] ?  340 : 250,
                                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)
                                ),
                                child:Row(children: <Widget>[
                                  new Container(
                                    width:50.0,
                                    height: 50.0,
                                    child:rep[index].profilnaSlika!=null?Image.network(api_services.url_za_slike+rep[index].profilnaSlika):new Icon(Icons.account_circle),
                                    margin: EdgeInsets.fromLTRB(80.0, 0.0, 10.0, 0.0),
                                  ),

                                  Container(
                                      margin: EdgeInsets.only(left:20,right:40),
                                      child: new Text("@"+rep[index].username )
                                  ),
                                  Container(
                                    child: Text("Razlog: "),
                                  ),
                                  Container(
                                      child: new Text(rep[index].razlog,style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)
                                  )

                                ],)
                            );
                          }),

                    ):Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(5.0),
                        child:Text("Nema prijava objave")
                    ),
                    RaisedButton(
                      child: Text("Zatvori"),
                      onPressed:(){
                        Navigator.pop(context);
                      } ,
                    )
                  ],
                ),
              ),
            ),


          );
        });
  }


  void _showDialogSlikaObjave(int rbr) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: new Container(
              width: 400,
              height: 400,
              margin: EdgeInsets.all(20.0),
              child:Image.network(api_services.url_za_slike+objave[rbr].slika.urlSlike)
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



  Widget contextObjave(int index) {

    if (objave[index].tekstualna_objava != null) {
      return Container(
        width: 400,
        child: new Container(
          child:Text(objave[index].tekstualna_objava.tekst,style: TextStyle(fontSize: 15),),
          margin:objave[index].tekstualna_objava.tekst.length<195?EdgeInsets.only(top: 30,bottom:00):EdgeInsets.only(top: 15,bottom:15) ,
          alignment: Alignment.center,
        ),
        margin:EdgeInsets.only(left: 10,right: 10) ,

      );
    } else {
      return new Container(
        margin:EdgeInsets.only(left: 10,right: 10) ,
        width: 400,
        child: objave[index].slika.opis_slike != null?
        Container(
            alignment: Alignment.center,
            width:400,
            margin:objave[index].slika.opis_slike.length<195?EdgeInsets.only(top: 30,bottom:20):EdgeInsets.only(top: 15,bottom:15) ,
            child:Text(objave[index].slika.opis_slike,style: TextStyle(fontSize: 15),)
        )
         : Text(""),

      );
    }
  }

  Widget printObjaveKorisnik() {
    if (objave == null) {
      return new CircularProgressIndicator();
    }

    return GridView.builder(
      itemCount: objave.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 1200?3:1,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          childAspectRatio: 1.9
      ),
      itemBuilder: (context, index) {
        idobjave=index;
        cekirani.add(false);
        return Container(
          width: 400.0,
          margin: EdgeInsets.only(bottom: 10,top:10.0,right:10,left:10),
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom:5.0,left: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),

          child:Column(
            children: <Widget>[
              Container(
                width: 400,
                margin:objave[index].vlasnik.urlSlike==null? EdgeInsets.only(top: 15,bottom: 10):
                EdgeInsets.only(top: 15),
                child: Row(
                  children: <Widget>[
/*
                    (objave[index].vlasnik.urlSlike != null)?Container(
                      //  margin: EdgeInsets.only(bottom: 10),
                      child: Image.network(
                        api_services.url_za_slike+objave[index].vlasnik.urlSlike,
                        height: 80,
                        width: 80,
                      ),

                    ):Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.grey[300],
                        ),
                        child: Icon(Icons.person,color: Colors.white,size: 40,)
                    ),
                    SizedBox(
                      width: 30,
                    ),
*/
                    Container(
                      width:200,
                      child: Wrap(
                        direction: Axis.vertical,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),

                          GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: objave[index].vlasnik != null?
                                  Text("@"+objave[index].vlasnik.username,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ,color: Colors.black),):Text(""),
                                ),
                                Container(
                                  child: objave[index].vlasnik != null
                                      ? Text(objave[index].vlasnik.ime + " " +
                                      objave[index].vlasnik.prezime
                                    ,style: TextStyle(fontSize: 14,),
                                  )
                                      : Text("Nema vlasnika"),
                                ),
                              ],
                            ),
                            onTap: (){
                              setState(() {
                                AppBarPageState.trenIndex=4;
                                html.window.sessionStorage['Idkorisnika']=objave[index].vlasnik.id.toString();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AppBarPage()
                                      /*prikazMape(latitude, longitude)*/));
                              });
                            },
                          ),



                          Container(
                              child:Text(objave[index].vreme
                                ,style: TextStyle(fontSize: 14,),
                              )
                          ),

                        ],
                      ),
                    ),
                    Container(
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[

/*
                          new Container(
                            margin: EdgeInsets.only(left: 50),
                            child:Tooltip(
                              child: IconButton(icon: Icon(Icons.delete,size: 30,),
                                onPressed: (){
                                  servis.obrisiObjavu(objave[index].id);
                                  setState(() {
                                    objave.remove(objave[index]);
                                    printObjave();
                                  });
                                },
                              ),
                              message: "Obrisi objavu",
                            ),
                          ),
                          */

                          objave[index].slika!=null?new Container(
                            margin: EdgeInsets.only(left: 50),
                            child:Tooltip(
                              child: IconButton(icon: Icon(Icons.image,size: 30,),
                                onPressed: (){
                                  _showDialogSlikaObjave(index);
                                },
                              ),
                              message: "Slika objave",
                            ),
                          ):new Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(
                width: 400.0,
                //   color: Colors.orange,
                child: Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: contextObjave(index)
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 50),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            padding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.thumb_up,size: 25,
                                      color:  Colors.black,),

                                    onPressed: () {
                                      getLikes(objave[index].id);
                                    },
                                  ),
                                  //margin:EdgeInsets.only(left:70.0),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Container(
                                      width:15,
                                      child: Text(objave[index].brojLajkova.toString())
                                  ),onTap: (){

                                },

                                ),
                              ],
                            ),
                          ),
                          new Container(

                            padding:
                            EdgeInsets.only( right: 10.0),
                            child: Row(
                              children: <Widget>[
                                new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.thumb_down,size: 25,
                                      color:  Colors.black,),

                                    onPressed: () {
                                      getDislike(objave[index].id);
                                    },
                                  ),
                                  //margin:EdgeInsets.only(left:70.0),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Container(
                                      width: 10,
                                      child: Text(objave[index].brojDislajkova.toString())),
                                  onTap: (){

                                    /*
                               ne pipaj treba tu da bude
                               setState(() {
                                      html.window.sessionStorage['IDObjave1']=objave[index].id.toString();
                                      AppBarPageState.trenIndex=5;
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AppBarPage()
                                        ));*/
                                  },

                                ),
                              ],
                            ),
                          ),
                          Container(
                            //   margin: EdgeInsets.only(
                            //    left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon:Icon(Icons.comment,size: 25,),
                                  onPressed: (){
                                    html.window.sessionStorage['zaKomentare']=objave[index].id.toString();
                                    html.window.sessionStorage['strana']=user.id.toString();
                                    setState(() {
                                      AppBarPageState.trenIndex=3;
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AppBarPage()
                                        ));
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(objave[index].brojKomentara.toString()),
                              ],
                            ),
                          ),
                          new Container(
                            child: new IconButton(
                              icon: Icon(Icons.report,size: 25,
                                color:  Colors.black,),

                              onPressed: () {
                                getReports(objave[index].id);
                              },
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top:16),
                              width:10,
                              child: Text(objave[index].brojReporta.toString()
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        );
      },
    );
  }

  Widget printObjaveKorisnikList() {
    if (objave == null) {
      return new CircularProgressIndicator();
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: objave.length,
      itemBuilder: (context, index) {
        idobjave=index;
        cekirani.add(false);
        return Container(
          width: 400.0,
          margin: EdgeInsets.only(bottom: 10,left: 300,right: 300),
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom:5.0,left: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),

          child:Column(
            children: <Widget>[
              Container(
                width: 400,
                margin:objave[index].vlasnik.urlSlike==null? EdgeInsets.only(top: 15,bottom: 10):
                EdgeInsets.only(top: 15),
                // margin:EdgeInsets.symmetric(vertical: 30,horizontal: 50) ,
                child: Row(
                  children: <Widget>[
/*
                    (objave[index].vlasnik.urlSlike != null)?Container(
                      //  margin: EdgeInsets.only(bottom: 10),
                      child: Image.network(
                        api_services.url_za_slike+objave[index].vlasnik.urlSlike,
                        height: 80,
                        width: 80,
                      ),

                    ):Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.grey[300],
                        ),
                        child: Icon(Icons.person,color: Colors.white,size: 40,)
                    ),
                    SizedBox(
                      width: 30,
                    ),
*/
                    Container(
                      width:200,
                      // padding: EdgeInsets.only(left: 10),
                      child: Wrap(
                        direction: Axis.vertical,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),

                          GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: objave[index].vlasnik != null?
                                  Text("@"+objave[index].vlasnik.username,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ,color: Colors.black),):Text(""),
                                ),
                                Container(
                                  child: objave[index].vlasnik != null
                                      ? Text(objave[index].vlasnik.ime + " " +
                                      objave[index].vlasnik.prezime
                                    ,style: TextStyle(fontSize: 14,),
                                  )
                                      : Text("Null je vlasnik"),
                                ),
                              ],
                            ),
                            onTap: (){
                              setState(() {
                                AppBarPageState.trenIndex=4;
                                html.window.sessionStorage['Idkorisnika']=objave[index].vlasnik.id.toString();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AppBarPage()
                                      /*prikazMape(latitude, longitude)*/));
                              });
                            },
                          ),



                          Container(
                              child:Text(objave[index].vreme
                                ,style: TextStyle(fontSize: 14,),
                              )
                          ),

                        ],
                      ),
                    ),
                    Container(
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
/*
                          new Container(
                            margin: EdgeInsets.only(left: 50),
                            child:Tooltip(
                              child: IconButton(icon: Icon(Icons.delete,size: 30,),
                                onPressed: (){
                                  servis.obrisiObjavu(objave[index].id);
                                  setState(() {
                                    objave.remove(objave[index]);
                                    printObjave();
                                  });
                                },
                              ),
                              message: "Obrisi objavu",
                            ),
                          ),
                          */
                          objave[index].slika!=null?new Container(
                            margin: EdgeInsets.only(left: 50),
                            child:Tooltip(
                              child: IconButton(icon: Icon(Icons.image,size: 30,),
                                onPressed: (){
                                  _showDialogSlikaObjave(index);
                                },
                              ),
                              message: "Slika objave",
                            ),
                          ):new Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(
                width: 400.0,
                //   color: Colors.orange,
                child: Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: contextObjave(index)
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 50),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            padding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.thumb_up,size: 25,
                                      color:  Colors.black,),

                                    onPressed: () {
                                      getLikes(objave[index].id);
                                    },
                                  ),
                                  //margin:EdgeInsets.only(left:70.0),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Container(
                                      width:15,
                                      child: Text(objave[index].brojLajkova.toString())
                                  ),onTap: (){

                                },

                                ),
                              ],
                            ),
                          ),
                          new Container(

                            padding:
                            EdgeInsets.only( right: 10.0),
                            child: Row(
                              children: <Widget>[
                                new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.thumb_down,size: 25,
                                      color:  Colors.black,),

                                    onPressed: () {
                                      getDislike(objave[index].id);
                                    },
                                  ),
                                  //margin:EdgeInsets.only(left:70.0),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Container(
                                      width: 10,
                                      child: Text(objave[index].brojDislajkova.toString())),
                                  onTap: (){

                                    /*
                               ne pipaj treba tu da bude
                               setState(() {
                                      html.window.sessionStorage['IDObjave1']=objave[index].id.toString();
                                      AppBarPageState.trenIndex=5;
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AppBarPage()
                                        ));*/
                                  },

                                ),
                              ],
                            ),
                          ),
                          Container(
                            //   margin: EdgeInsets.only(
                            //    left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon:Icon(Icons.comment,size: 25,),
                                  onPressed: (){
                                    html.window.sessionStorage['zaKomentare']=objave[index].id.toString();
                                    html.window.sessionStorage['strana']=user.id.toString();
                                    setState(() {
                                      AppBarPageState.trenIndex=3;
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AppBarPage()
                                        ));
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(objave[index].brojKomentara.toString()),
                              ],
                            ),
                          ),
                          new Container(
                            child: new IconButton(
                              icon: Icon(Icons.report,size: 25,
                                color:  Colors.black,),

                              onPressed: () {
                                getReports(objave[index].id);
                              },
                            ),
                          ),
                          Container(
                                margin: EdgeInsets.only(top:16),
                                width:10,
                                child: Text(objave[index].brojReporta.toString()
                                )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        );
      },
    );
  }


  void getDislike(int idOvjave){
    servis.fetchDislikes(idOvjave).then(
          (response) {
        Iterable list = json.decode(response.body);
        List<Korisnik> korisniciList = List<Korisnik>();
        korisniciList = list.map((model) => Korisnik.fromObject(model)).toList();
        setState(
              () {
            korisnicii = korisniciList;
            //objave = objave.reversed.toList();
          },
        );
        _showDialog1(0);
      },
    );
  }




  void getLikes(int idObjave){
    servis.fetchLikes(idObjave).then((response) {
        Iterable list = json.decode(response.body);
        List<Korisnik> korisniciList = List<Korisnik>();
        korisniciList = list.map((model) => Korisnik.fromObject(model)).toList();
        setState(
              () {
            korisnicii = korisniciList;
          },
        );
        _showDialog1(1);
      },
    );
  }



void _showDialog1(int broj) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              width: 500,
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    broj==0?Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.centerRight,
                      child: Text("Korisnici koji su označili da im se objava ne sviđa",style: TextStyle(
                          fontSize: 20,fontWeight: FontWeight.bold
                      ),),
                    ):Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Text("Korisnici koji su označili da im se objava sviđa",style: TextStyle(
                          fontSize: 20,fontWeight: FontWeight.bold
                      ),),
                    ),
                    korisnicii.length>0?Container(
                      child: ListView.builder(
                          itemCount: korisnicii.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5.0),
                                //height: visible_comment_section[index] ?  340 : 250,
                                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)
                                ),
                                child:Row(children: <Widget>[
                                  new Container(
                                    width:30.0,
                                    height: 30.0,
                                    child:korisnicii[index].urlSlike!=null?Image.network(api_services.url_za_slike+korisnicii[index].urlSlike):new Icon(Icons.account_circle),
                                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  ),
                                  korisnicii[index].uloga=="institucija"?
                                  Container(child: new Text(korisnicii[index].ime )):
                                  Container(child: new Text(korisnicii[index].ime + ' ' + korisnicii[index].prezime))

                                ],)
                            );
                          }),

                    ):Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(5.0),
                        child:broj==0? Text("Još uvek nema korisnika koji su označili da im se objava ne sviđa"):
                        Text("Još uvek nema korisnika koji su označili da im se objava sviđa")
                    ),
                    RaisedButton(
                      child: Text("Zatvori"),
                      onPressed:(){
                        Navigator.pop(context);
                      } ,
                    )
                  ],
                ),
              ),
            ),


          );
        });
  }


  int idobjave=0;
  List<bool> cekirani=List<bool>();
  Widget printObjaveInst() {
    if (objave == null) {
      return Container(child: Text("Nema Objava"),);
    }
    return GridView.builder(
      itemCount: objave.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 1200?3:1,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          childAspectRatio: 1.8
      ),
      itemBuilder: (context, index) {
        idobjave=index;
        cekirani.add(false);
        return Container(
          width: 400.0,
          margin: EdgeInsets.only(bottom: 10),
          alignment: Alignment.center,
          //  margin:EdgeInsets.symmetric(vertical: 5) ,
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            //  borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.white,
          ),

          child:Column(
            children: <Widget>[
              Container(
                width: 400.0,
                margin:objave[index].vlasnik.urlSlike==null? EdgeInsets.only(top: 5,bottom: 5):
                EdgeInsets.only(top: 5),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    (objave[index].vlasnik.urlSlike != null)?Container(
                      //  margin: EdgeInsets.only(bottom: 10),
                      child: Image.network(
                        api_services.url_za_slike+objave[index].vlasnik.urlSlike,
                        height: 70,
                        width: 70,
                      ),

                    ):Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.grey[300],
                        ),
                        child: Icon(Icons.person,color: Colors.white,size: 40,)
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: Wrap(
                        direction: Axis.vertical,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),

                          Container(
                            child: objave[index].vlasnik != null?
                            Text("@"+objave[index].vlasnik.username,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ,color: Colors.black),):Text(""),
                          ),

                          Container(
                            child: objave[index].vlasnik != null
                                ? Text(objave[index].vlasnik.ime + " " +
                                objave[index].vlasnik.prezime
                              ,style: TextStyle(fontSize: 14,),
                            )
                                : Text("Null je vlasnik"),
                          ),

                          Container(
                              child:Text(objave[index].vreme
                                ,style: TextStyle(fontSize: 14,),
                              )
                          ),

                        ],
                      ),

                    ),
                    Container(
                      child: objave[index].slika!=null?new Container(
                        margin: EdgeInsets.only(left: 60),
                        child:Tooltip(
                          child: IconButton(icon: Icon(Icons.image,size: 30,),
                            onPressed: (){
                              _showDialogSlikaObjave(index);
                            },
                          ),
                          message: "Slika objave",
                        ),
                      ):new Container(),
                    )
                  ],
                ),
              ),

              Container(
                child: Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: contextObjave(index)
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 50),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            padding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.thumb_up,size: 25,
                                      color: Colors.black,),

                                    onPressed: () {
                                      getLikes(objave[index].id);
                                    },
                                  ),
                                  //margin:EdgeInsets.only(left:70.0),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Container(
                                      width:15,
                                      child: Text(objave[index].brojLajkova.toString())
                                  ),onTap: (){

                                },
                                ),
                              ],
                            ),
                          ),
                          new Container(

                            padding:
                            EdgeInsets.only( right: 10.0),
                            child: Row(
                              children: <Widget>[
                                new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.thumb_down,size: 25,
                                      color: Colors.black,),

                                    onPressed: () {
                                      getDislike(objave[index].id);
                                    },
                                  ),
                                  //margin:EdgeInsets.only(left:70.0),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Container(
                                      width: 10,
                                      child: Text(objave[index].brojDislajkova.toString())),
                                  onTap: (){

                                  },

                                ),
                              ],
                            ),
                          ),
                          Container(
                            //  margin: EdgeInsets.only(
                            //   left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.comment,size: 25,),
                                  onPressed: (){
                                    setState(() {
                                      html.window.sessionStorage['IDObjave']=objave[index].id.toString();
                                      html.window.sessionStorage['IDKorisnika']=user.id.toString();
                                      AppBarPageState.trenIndex=3;
                                    });
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            AppBarPage()
                                    )
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(objave[index].brojKomentara.toString()),
                              ],
                            ),
                          ),
                          new Container(
                            child: new IconButton(
                              icon: Icon(Icons.report,size: 25,
                                color: Colors.black,),

                              onPressed: () {
                                getReports(objave[index].id);
                              },
                            ),

                            //margin:EdgeInsets.only(left:70.0),
                          ),
                          Container(
                              margin: EdgeInsets.only(top:16),
                              width:10,
                              child: Text(objave[index].brojReporta.toString()
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),

        );
      },
    );
  }

  Widget printObjaveInstList() {
    if (objave == null) {
      return Container(child: Text("Nema Objava"),);
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: objave.length,
      itemBuilder: (context, index) {
        idobjave=index;
        cekirani.add(false);
        return Container(
          width: 400.0,
          margin: EdgeInsets.only(bottom: 10,left: 300,right: 300),
          alignment: Alignment.center,
          //  margin:EdgeInsets.symmetric(vertical: 5) ,
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            //  borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.white,
          ),

          child:Column(
            children: <Widget>[
              Container(
                width: 400.0,
                margin:objave[index].vlasnik.urlSlike==null? EdgeInsets.only(top: 5,bottom: 5):
                EdgeInsets.only(top: 5),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    (objave[index].vlasnik.urlSlike != null)?Container(
                      //  margin: EdgeInsets.only(bottom: 10),
                      child: Image.network(
                        api_services.url_za_slike+objave[index].vlasnik.urlSlike,
                        height: 70,
                        width: 70,
                      ),

                    ):Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.grey[300],
                        ),
                        child: Icon(Icons.person,color: Colors.white,size: 40,)
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: Wrap(
                        direction: Axis.vertical,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),

                          Container(
                            child: objave[index].vlasnik != null?
                            Text("@"+objave[index].vlasnik.username,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ,color: Colors.black),):Text(""),
                          ),

                          Container(
                            child: objave[index].vlasnik != null
                                ? Text(objave[index].vlasnik.ime + " " +
                                objave[index].vlasnik.prezime
                              ,style: TextStyle(fontSize: 14,),
                            )
                                : Text("Null je vlasnik"),
                          ),

                          Container(
                              child:Text(objave[index].vreme
                                ,style: TextStyle(fontSize: 14,),
                              )
                          ),

                        ],
                      ),

                    ),
                    Container(
                      child: objave[index].slika!=null?new Container(
                        margin: EdgeInsets.only(left: 60),
                        child:Tooltip(
                          child: IconButton(icon: Icon(Icons.image,size: 30,),
                            onPressed: (){
                              _showDialogSlikaObjave(index);
                            },
                          ),
                          message: "Slika objave",
                        ),
                      ):new Container(),
                    )
                  ],
                ),
              ),

              Container(
                child: Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: contextObjave(index)
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 50),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            padding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              children: <Widget>[
                                new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.thumb_up,size: 25,
                                      color: Colors.black,),

                                    onPressed: () {
                                      getLikes(objave[index].id);
                                    },
                                  ),
                                  //margin:EdgeInsets.only(left:70.0),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Container(
                                      width:15,
                                      child: Text(objave[index].brojLajkova.toString())
                                  ),onTap: (){

                                },
                                ),
                              ],
                            ),
                          ),
                          new Container(

                            padding:
                            EdgeInsets.only( right: 10.0),
                            child: Row(
                              children: <Widget>[
                                new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.thumb_down,size: 25,
                                      color: Colors.black,),

                                    onPressed: () {
                                      getDislike(objave[index].id);
                                    },
                                  ),
                                  //margin:EdgeInsets.only(left:70.0),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Container(
                                      width: 10,
                                      child: Text(objave[index].brojDislajkova.toString())),
                                  onTap: (){

                                  },

                                ),
                              ],
                            ),
                          ),
                          Container(
                            //  margin: EdgeInsets.only(
                            //   left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.comment,size: 25,),
                                  onPressed: (){
                                    setState(() {
                                      html.window.sessionStorage['IDObjave']=objave[index].id.toString();
                                      html.window.sessionStorage['IDKorisnika']=user.id.toString();
                                      AppBarPageState.trenIndex=3;
                                    });
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            AppBarPage()
                                    )
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(objave[index].brojKomentara.toString()),
                              ],
                            ),
                          ),
                          new Container(
                            child: new IconButton(
                              icon: Icon(Icons.report,size: 25,
                                color: Colors.black,),

                              onPressed: () {
                                getReports(objave[index].id);
                              },
                            ),

                            //margin:EdgeInsets.only(left:70.0),
                          ),
                          Container(
                            margin: EdgeInsets.only(top:16),
                            width:10,
                            child: Text(objave[index].brojReporta.toString())
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),

        );
      },
    );
  }

bool flag=true;

  Widget build(BuildContext context) {
    if (user == null) return CircularProgressIndicator();

    if (objave.length == 0) {
      if(user.uloga!="institucija")
      {
        getObjave();
      }
      else{
        getObjave1();
      }

    }
    sirina1=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      //borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),

                  child:Wrap(
                    children: <Widget>[
                      user.urlSlike!=null?Container(
                          child:  Image.network(
                            api_services.url_za_slike + user.urlSlike,
                            width: 200,height: 200,
                          )
                      ):Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            color: Colors.grey,
                          ),
                          child: Icon(Icons.person,color: Colors.white,size: 120,)
                      ),
                      new Container( //podaci o korisniku

                        width: 300,
                        margin: EdgeInsets.only(left:20,top:20),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top:5),
                              child:new Text("Korisničko ime: @"+user.username)
                            ),
                            Container(
                                padding: EdgeInsets.only(top:5),
                                child:user.uloga!="institucija"?new Text("Ime i prezime: "+user.ime+" "+user.prezime):
                                new Text("Naziv institucije: "+user.ime)
                            ),
                            user.uloga!="institucija"?new Container(
                                padding: EdgeInsets.only(top:5),
                                child:new Text("E-mail: "+user.email)
                            ):new Container(),
                            Container(
                                padding: EdgeInsets.only(top:5),
                                child:new Text("O korisniku: ")
                            ),
                            Container(
                                padding: EdgeInsets.only(top:5),
                                child:user.biografija!=null?new Text(user.biografija,style: TextStyle(fontStyle: FontStyle.italic),):Text("Korisnik nije postavio opis profila")
                            ),
                            user.uloga!="institucija"?new Container(
                                padding: EdgeInsets.only(top:5),
                                child:new Text("Broj osvojenih poena: "+user.poeni.toString())
                            ):new Container(),

                            objave!=null && objave.length!=0?new Container(
                                padding: EdgeInsets.only(top:5),
                                child:new Text("Ukupno objava: "+objave.length.toString())
                            ):new Container(),
                            /*
                            new Container(
                                padding: EdgeInsets.only(top:5),
                                child:user.ocenaAplikacije!=-1?new Text("Ocena aplikacije: "+user.ocenaAplikacije.toString()):
                                    new Text("Nije ocenio aplikaciju",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),)
                            )
                            */
                          ],
                        ),
                      ),


                      user.uloga=="korisnik"?
                      new Container(
                          margin:EdgeInsets.only(left:100.0,top:25.0),
                          child:new Wrap(
                            direction: Axis.vertical,
                            children: <Widget>[
                              new RaisedButton(
                                color:Colors.lightBlue.shade200,
                                child: Container(
                                  width:160,
                                  child:Text("Dodaj poene",textAlign: TextAlign.center,)
                                ),
                                onPressed: (){
                                  _showDialogPoeni(1);
                                  getKorisnikaaa(user.id);
                                  setState(() {

                                  });

                                },
                              ),
                              new RaisedButton(
                                color:Colors.lightBlue.shade200,
                                child: Container(
                                    width:160,
                                    child:Text("Oduzmi poene",textAlign: TextAlign.center,)
                                ),
                                onPressed: (){
                                  _showDialogPoeni(2);
                                  getKorisnikaaa(user.id);
                                  setState(() {


                                  });

                                },
                              ),
                              new RaisedButton(
                                color:Colors.lightBlue.shade200,
                                child: Container(
                                    width:160,
                                    child:Text("Postavi za administratora",textAlign: TextAlign.center,)
                                ),
                                onPressed: (){
                                  _showDialogAdmin(user);
                                },
                              ),
                            ],
                          )
                      ):user.uloga=="admin" && html.window.sessionStorage["adminUloga"]=="superuser"?
                      new Container(
                        margin:EdgeInsets.only(left:100.0,top:25.0),
                        child: new RaisedButton(
                          color:Colors.lightBlue.shade200,
                          child: Container(
                              width:160,
                              child:Text("Postavi za korisnika",textAlign: TextAlign.center,)
                          ),
                          onPressed: (){
                            _showDialogAdminKorisnik(user);
                            getKorisnikaaa(user.id);
                            setState(() {

                            });

                          },
                        ),
                      ):new Container()
                    ],
                  )
                ),
                new Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(bottom:10,top:10),
                  padding: EdgeInsets.all(5),
                  child:new Wrap(
                    children: <Widget>[
                      new Container(
                        child: new Text(user.uloga=="institucija"?"Objave koje je @"+user.username+" označio kao rešene":"Objave korisnika",style: TextStyle(fontSize: 18),),
                        margin: EdgeInsets.only(top:20,bottom:5,right:10,left:5),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top:5,bottom:5),
                        child: new Container(
                            child:Wrap(
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(left:10),
                                  child: Tooltip(
                                    child: IconButton(icon: Icon(Icons.list),
                                      onPressed: (){
                                        setState(() {
                                          flag=false;
                                        });
                                      },
                                    ),
                                    message: "Prikaz objava u obliku liste",
                                  ),
                                ),
                                SizedBox(width: 10,),
                                new Container(
                                  margin: EdgeInsets.only(left:10),
                                  child: Tooltip(
                                    child: IconButton(icon: Icon(Icons.grid_on),
                                      onPressed: (){
                                        setState(() {
                                          flag=true;
                                        });
                                      },
                                    ),
                                    message: "Prikaz objava u obliku matrice",
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    ],
                  )
                ),
                new Container(
                   //margin:user.uloga=="institucija" && flag==false?EdgeInsets.only(left:sirina/3,right:sirina/3):EdgeInsets.only(top:0),
                  child:flag==true?user.uloga=="institucija"?printObjaveInst():printObjaveKorisnik():user.uloga=="institucija"?printObjaveInstList():printObjaveKorisnikList()
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }


  Widget BuildText(double size, String str) {
    return SizedBox(
      width: size,
      child: Container(
        margin: EdgeInsets.only(left: 15.0, top: 10.0),
        padding: EdgeInsets.only(left: 5.0),
        child: Text(str,style: TextStyle(fontSize: 20),),
      ),
    );
  }

  void _showDialogPoeni(int a) {

    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(a==1?"Dodavanje poena korisniku":"Oduzimanje poena korisniku"),
          content: Container(
            width: 500,
            child: SingleChildScrollView(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Text(a==1?'Unesite broj poena koje želite da dodate korisniku':'Unesite broj poena koje želite da oduzmete korisniku'),
                  new Container(
                    margin: EdgeInsets.only(left:20.0,top:20.0,bottom: 20.0,right: 20.0),
                    child:new TextFormField(
                      controller: _poeniController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(5.0),
                        hintText: "Npr. 12",
                      ),
                      maxLines: 1,
                      autocorrect: false,
                      autofocus: false,
                    ),
                  ),
                  a==2?Text('Napomena: Nije moguće oduzeti korisniku broj poena koji je veći od njegovih ukupnih poena',
                  style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic,color: Colors.grey),
                  ):Text("")
                ],
              ),
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Odustani'),
              onPressed: () {
                //_resenaObjavaController.text="";
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('Potvrdi'),
              onPressed: () {
                setState(() {
                  if(a==1)
                    {
                      if(int.parse(_poeniController.text) > 0)
                        {
                          servis.dodajPoene(user.id, int.parse(_poeniController.text));
                          user.poeni=user.poeni+int.parse(_poeniController.text);
                        }

                    }
                  else{

                    if(user.poeni>=int.parse(_poeniController.text) && int.parse(_poeniController.text)>0)
                    {
                      servis.oduzmiPoene(user.id, int.parse(_poeniController.text));
                      user.poeni=user.poeni-int.parse(_poeniController.text);
                    }
                  }

                });
                _poeniController.text="";

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _showDialogAdminKorisnik(Korisnik a) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Uklanjanje administratorskih privilegija"),
          content: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Text('Da li ste sigurni da želite da učinite '),
                Text("@"+a.username,style: TextStyle(fontStyle: FontStyle.italic),),
                Text(" običnim korisnikom?")
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
                setState(() {
                  servis.postaviZaKorisnika(a);
                  user.uloga="korisnik";
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogAdmin(Korisnik a) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Postavljanje korisnika kao administratora"),
          content: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Text('Da li ste sigurni da želite da postavite '),
                Text("@"+a.username,style: TextStyle(fontStyle: FontStyle.italic),),
                Text(" za administratora?")
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
                setState(() {
                  servis.postaviZaAdmina(a);
                  user.uloga="admin";
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