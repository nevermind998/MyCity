import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:webApp/models/AktivnostiKorisnika.dart';
import 'package:webApp/models/Grad.dart';
import 'package:webApp/models/Kategorija.dart';
import 'package:webApp/models/Korisnik.dart';
import 'package:webApp/models/Objava.dart';
import 'package:webApp/models/Pretraga.dart';
import 'package:webApp/models/Report.dart';
import 'package:webApp/models/TekstualnaObjava.dart';
import 'package:webApp/services/api_services.dart';
import 'AppBarPage.dart';
import 'loginPage.dart';

class PostPage extends StatefulWidget {
  PostPage({Key key}) : super(key: key);

  @override
  PostPageState createState() => PostPageState();
}
class PostPageState extends State<PostPage> {
  String token = '';
  Korisnik user;
  List<TekstualnaObjava> tekstualne_objave;
  api_services servis = api_services();
  List<Objava> objave;
  List<AktivnostiKorisnika> aktivnosti;
  File tmpfile;
  List<Korisnik> korisnici =  List<Korisnik>();

  Grad selected=Grad();
  List<Grad> gradovi=List<Grad>();

  Kategorija selectedKategorija=Kategorija();
  List<Kategorija> kategorije=List<Kategorija>();

  List<Pretrazivanje> sortiraj=List<Pretrazivanje>();
  Pretrazivanje sortirajSelected;

  List<Pretrazivanje> sortKategorija=List<Pretrazivanje>();
  Pretrazivanje sortKategorijaSelected;

  List<Pretrazivanje> resene=List<Pretrazivanje>();
  Pretrazivanje reseneSelected;

  getToken() async {
    String _token = html.window.sessionStorage['adminToken'];
    Map<String, dynamic> jsonObject = json.decode(html.window.sessionStorage['adminInfo']);
    Korisnik extractedUser = new Korisnik();
    extractedUser = Korisnik.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
    });
  }

  void getGradove() {
    servis.dajGradove().then((response) {
      Iterable list = json.decode(response.body);
      setState(() {

        gradovi=list.map((model) => Grad.fromObject(model)).toList();
        gradovi.insert(0,selected);

      });
    });
  }

  void getKategorije()
  {
    servis.fetchKategorije().then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        kategorije = list.map((model) => Kategorija.fromObject(model)).toList();
        kategorije.insert(0, selectedKategorija);
      });
    });
  }

  initState() {

    if(html.window.sessionStorage.length==0)
    {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }

    selected.id=0;
    selected.naziv_grada_lat="Svi gradovi";
    selected.naziv_grada_cir=" ";

    selectedKategorija.id=0;
    selectedKategorija.kategorija="Sve kategorije";

    sortiraj.add(new Pretrazivanje(0, "Rastuće"));
    sortiraj.add(new Pretrazivanje(1, "Opadajuće"));
    sortirajSelected=sortiraj[0];

    sortKategorija.add(new Pretrazivanje(0, "Svidjanja"));
    sortKategorija.add(new Pretrazivanje(1, "Ne svidjanja"));
    sortKategorija.add(new Pretrazivanje(2, "Prijava"));
    sortKategorija.add(new Pretrazivanje(3, "Komentara"));
    sortKategorijaSelected=sortKategorija[0];

    resene.add(new Pretrazivanje(0, "Sve objave"));
    resene.add(new Pretrazivanje(1, "Resene objave"));
    resene.add(new Pretrazivanje(2, "Neresene objave"));
    reseneSelected=resene[0];
    getGradove();

    super.initState();
    getToken();
  }

  void getObjave(int a, int b) {
    servis.fetchObjave(a,b).then((response) {
        Iterable list = json.decode(response.body);
        List<Objava> objaveList = List<Objava>();
        objaveList = list.map((model) => Objava.fromObject(model)).toList();
        setState(
              () {
            objave = objaveList;
            //objave.sort((a,b) => a.brojLajkova.compareTo(b.brojLajkova));
          },
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
          margin:objave[index].tekstualna_objava.tekst.length<195?EdgeInsets.only(top: 50,bottom:40):EdgeInsets.only(top: 30,bottom:30) ,
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
            width:430,
            margin:objave[index].slika.opis_slike.length<195?EdgeInsets.only(top: 50,bottom:40):EdgeInsets.only(top: 30,bottom:30) ,
            child:Text(objave[index].slika.opis_slike,style: TextStyle(fontSize: 15),)
        ):Text(""),

      );
    }
  }

  void getDislike(int idOvjave){
    servis.fetchDislikes(idOvjave).then((response) {
        Iterable list = json.decode(response.body);
        List<Korisnik> korisniciList = List<Korisnik>();
        korisniciList = list.map((model) => Korisnik.fromObject(model)).toList();
        setState(
              () {
            korisnici = korisniciList;
          },
        );
        _showDialog(0);
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
            korisnici = korisniciList;
          },
        );
        _showDialog(1);
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


  double sirina;
  int idobjave=0;
  List<bool> cekirani=List<bool>();
  Widget printObjave() {
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
          childAspectRatio: 1.6
      ),
      itemBuilder: (context, index) {
        idobjave=index;
        cekirani.add(false);
        return Container(
          width: 400.0,
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom:5.0,left: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color:objave[index].resenaObjava==0?Colors.white:Colors.green.shade200
          ),

          child:Column(
            children: <Widget>[
              Container(
                width: 400,
                child: Row(
                  children: <Widget>[
                    (objave[index].vlasnik.urlSlike != null)?Container(
                      margin: EdgeInsets.only(top:5,left:5),
                      child: Image.network(
                        api_services.url_za_slike+objave[index].vlasnik.urlSlike,
                        height: 70,
                        width: 70,
                      ),

                    ):Container(
                        margin: EdgeInsets.only(top:5,left:5),
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
                      width:140,
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

                          new Container(
                              margin: EdgeInsets.only(left: 50),
                              child:Tooltip(
                                child: IconButton(icon: Icon(Icons.delete,size: 30,),
                                  onPressed: (){
                                    _showDialogBrisanjeObjave(objave[index]);
                                  },
                                ),
                                message: "Obriši objavu",
                              ),
                          ),
                          objave[index].slika!=null?new Container(
                            margin: EdgeInsets.only(left: 10),
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
                      padding: EdgeInsets.only(left: 35),
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
                                  width: 5,
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
                                    html.window.sessionStorage['strana']="post";
                                    html.window.sessionStorage['zaKomentare']=objave[index].id.toString();
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
                                Text(objave[index].brojKomentara.toString()),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
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

                          GestureDetector(
                            child: Container(
                                margin: EdgeInsets.only(top:16),
                                width:10,
                                child: Text(objave[index].brojReporta.toString())
                            ),onTap: (){

                          },

                          ),
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


  void _showDialog(int broj) {

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
                    korisnici.length>0?Container(
                      child: ListView.builder(
                          itemCount: korisnici.length,
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
                                    child:korisnici[index].urlSlike!=null?Image.network(api_services.url_za_slike+korisnici[index].urlSlike):new Icon(Icons.account_circle),
                                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  ),
                                  korisnici[index].uloga=="institucija"?
                                  Container(child: new Text(korisnici[index].ime )):
                                  Container(child: new Text(korisnici[index].ime + ' ' + korisnici[index].prezime))

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

  List<DropdownMenuItem<Grad>> buildDropdownMenuItems(List <Grad> _gradovi) {
    List<DropdownMenuItem<Grad>> items = List();

    for (Grad grad in _gradovi) {
      items.add(
        DropdownMenuItem(
            value: grad,
            child: Text(grad.naziv_grada_lat,style: TextStyle(fontSize: 17),)
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Kategorija>> buildMenuKategorije(List<Kategorija> _kat) {
    List<DropdownMenuItem<Kategorija>> items = List();
    for (Kategorija k in _kat) {
      items.add(
        DropdownMenuItem(
          value: k,
          child: Text(k.kategorija,style: TextStyle(fontSize: 17),),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Pretrazivanje>> buildDropdownMenuItemsPretrazivanje(List<Pretrazivanje> _pretrazi) {
    List<DropdownMenuItem<Pretrazivanje>> items1 = List();

    for (Pretrazivanje pret in _pretrazi) {
      items1.add(
        DropdownMenuItem(
          value: pret,
          child:Text(pret.ime,style: TextStyle(fontSize: 17),),
        ),
      );
    }
    return items1;
  }

  void sortiralica()
  {
    if(sortKategorijaSelected.id==0)
    {
      if(sortirajSelected.id==1)
      {
        objave.sort((a,b) => b.brojLajkova.compareTo(a.brojLajkova));
      }
      else
      {
        objave.sort((a,b) => a.brojLajkova.compareTo(b.brojLajkova));

      }
    }
    if(sortKategorijaSelected.id==1)
    {
      if(sortirajSelected.id==1)
      {
        objave.sort((a,b) => b.brojDislajkova.compareTo(a.brojDislajkova));
      }
      else
      {
        objave.sort((a,b) => a.brojDislajkova.compareTo(b.brojDislajkova));

      }
    }
    if(sortKategorijaSelected.id==2)
    {
      if(sortirajSelected.id==1)
      {
        objave.sort((a,b) => b.brojReporta.compareTo(a.brojReporta));
      }
      else
      {
        objave.sort((a,b) => a.brojReporta.compareTo(b.brojReporta));

      }
    }
    if(sortKategorijaSelected.id==3)
    {
      if(sortirajSelected.id==1)
      {
        objave.sort((a,b) => b.brojKomentara.compareTo(a.brojKomentara));
      }
      else
      {
        objave.sort((a,b) => a.brojKomentara.compareTo(b.brojKomentara));

      }
    }
  }

  bool flag=true;

  @override
  Widget build(BuildContext context) {
    if (objave == null) {
      getObjave(0,0);
    }

    if(gradovi.length==0)
    {
      getGradove();
    }

    if(kategorije.length==0)
    {
      getKategorije();
    }

    sirina =MediaQuery.of(context).size.width;
    return new Scaffold(
      body: SingleChildScrollView(

          child: Container(
            width: sirina,

            child: Container(
             // color: Colors.red,
              //width: sirina/2,
              // padding: EdgeInsets.only(left: 200),

              child: Column(
                children: <Widget>[
                  Container(
                    width: sirina,
                   // color:Colors.red,
                    padding: EdgeInsets.all(10.0),
                    child: new Wrap(
                      children: <Widget>[
                        new Container(
                          //color:Colors.red,
                          width:200,
                          child:new DropdownButton(

                              items: buildDropdownMenuItems(gradovi),
                              value: selected,
                              onChanged: (value) {
                                setState(() {
                                  selected = value;
                                  getObjave(selected.id, selectedKategorija.id);
                                  sortiralica();
                                  printObjave();
                                });
                              }
                          ),
                        ),
                        SizedBox(width: 10,),
                        new Container(
                          child:new DropdownButton(

                              items: buildMenuKategorije(kategorije),
                              value: selectedKategorija,
                              onChanged: (value) {
                                setState(() {
                                  selectedKategorija = value;
                                  getObjave(selected.id, selectedKategorija.id);
                                  sortiralica();
                                  printObjave();
                                });
                              }
                          ),
                        ),
                        SizedBox(width: 10,),
                        new Container(
                          margin: EdgeInsets.only(top:1),
                          child:new DropdownButton(
                              items: buildDropdownMenuItemsPretrazivanje(resene),
                              value: reseneSelected,
                              onChanged: (value) {
                                setState(() {
                                  reseneSelected=value;
                                  if(reseneSelected.id==0)
                                  {
                                    getObjave(selected.id, selectedKategorija.id);
                                    printObjave();
                                  }
                                  else if(reseneSelected.id==1)
                                    {
                                      servis.fetchObjave(selected.id, selectedKategorija.id).then((response) {
                                        Iterable list = json.decode(response.body);
                                        List<Objava> objaveList = List<Objava>();
                                        objaveList = list.map((model) => Objava.fromObject(model)).toList();
                                        setState(
                                              () {
                                            objave = objaveList;
                                            objave.removeWhere((element) => element.resenaObjava==0);
                                            printObjave();
                                          },
                                        );
                                      },
                                      );


                                  }
                                  else if(reseneSelected.id==2)
                                  {

                                    servis.fetchObjave(selected.id, selectedKategorija.id).then((response) {
                                      Iterable list = json.decode(response.body);
                                      List<Objava> objaveList = List<Objava>();
                                      objaveList = list.map((model) => Objava.fromObject(model)).toList();
                                      setState(
                                            () {
                                          objave = objaveList;
                                          objave.removeWhere((element) => element.resenaObjava==1);
                                          printObjave();
                                        },
                                      );
                                    },
                                    );
                                  }

                                });
                              }
                          ),
                        ),
                        SizedBox(width: 30,),
                        new Container(
                          margin: EdgeInsets.only(top:15),
                          child: Text("Sortiraj po broju: ",style: TextStyle(fontSize: 18),),
                        ),
                        SizedBox(width: 10,),
                        new Container(
                          margin: EdgeInsets.only(top:1),
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
                          margin: EdgeInsets.only(top:1),
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
                        SizedBox(width: 20,),
                        new Container(
                          child:Wrap(
                            children: <Widget>[
                              new Container(
                                margin: EdgeInsets.only(top:15),
                                child: Text("Prikaz: ",style: TextStyle(fontSize: 18),),
                              ),
                              SizedBox(width: 10,),
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
                        )
                        /*
                        SizedBox(width: 10,),
                        new Container(
                          margin: EdgeInsets.only(top:15,left:10),
                          child: Text(objave.length.toString()),
                        ),
                        */
                      ],
                    )
                  ),
                  /*
                  new Container(
                    alignment: Alignment.centerLeft,
                    child:Wrap(
                      children: <Widget>[
                        SizedBox(width: 20,),
                        new Container(
                          margin: EdgeInsets.only(top:15),
                          child: Text("Prikaz: ",style: TextStyle(fontSize: 18),),
                        ),
                        SizedBox(width: 10,),
                        new Container(
                          margin: EdgeInsets.only(left:10),
                          child: IconButton(icon: Icon(Icons.list),
                            onPressed: (){
                              setState(() {
                                flag=false;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10,),
                        new Container(
                          margin: EdgeInsets.only(left:10),
                          child: IconButton(icon: Icon(Icons.grid_on),
                            onPressed: (){
                              setState(() {
                                flag=true;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  */
                  flag==true?printObjave():printObjaveList(),

                ],
              ),
            ),
          )),

    );
  }

  Widget printObjaveList() {
    if (objave.length == 0) {
      return Container(child: Text("Nema Objava"),);//zaPrazneObjave
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
          margin: EdgeInsets.only(bottom: 10,left: sirina/5,right: sirina/5),
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
          ),

          child:Center(
            child: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.center,
              children: <Widget>[
                Container(
                  margin:objave[index].vlasnik.urlSlike==null? EdgeInsets.only(top: 10,bottom: 10):
                  EdgeInsets.only(top: 10),
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
                        width: 30,
                      ),

                      Container(
                        // padding: EdgeInsets.only(left: 10),
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
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: <Widget>[

                            new Container(
                              margin: EdgeInsets.only(left: 50),
                              child:Tooltip(
                                child: IconButton(icon: Icon(Icons.delete,size: 30,),
                                  onPressed: (){
                                    _showDialogBrisanjeObjave(objave[index]);
                                  },
                                ),
                                message: "Obriši objavu",
                              ),
                            ),
                            objave[index].slika!=null?new Container(
                              margin: EdgeInsets.only(left: 10),
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
                                        color:Colors.black,),

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
                              /*padding:
                                  EdgeInsets.only(left: 20.0, right: 15.0, top: 15.0),
                                  child: new IconButton(
                                    icon: new Icon(Icons.thumb_down,size: 30,),
                                    color: objave[index].korisnikaDislajkovao == 1
                                        ? Colors.red
                                        : Colors.black,
                                    onPressed: () {
                                      servis.addDislike(user.id, objave[index].id);
                                    },
                                  ),
                                  //margin:EdgeInsets.all(20.0),
*/
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
                                      onTap: () {

                                      }

                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Row(
                                children: <Widget>[
                                  new Container(
                                    child: new IconButton(
                                      icon: Icon(Icons.comment,size: 25,
                                        color: Colors.black,),

                                      onPressed: () {
                                        html.window.sessionStorage['strana']="post";
                                        html.window.sessionStorage['zaKomentare']=objave[index].id.toString();
                                        setState(() {
                                          AppBarPageState.trenIndex=3;
                                        });
                                        Navigator.pushNamed(context,"/appbarWeb" );
                                      },
                                    ),
                                    //margin:EdgeInsets.only(left:70.0),
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

                            ),
                            GestureDetector(
                              child: Container(
                                  margin: EdgeInsets.only(top:16),
                                  width:10,
                                  child: Text(objave[index].brojReporta.toString())
                              ),onTap: (){

                            },

                            )
                          ],
                        ),
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

  void _showDialogBrisanjeObjave(Objava a) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Brisanje objave korisnika"),
          content: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Text('Da li ste sigurni da želite da obrišete objavu koju je postavio korisnik '),
                Text("@"+a.vlasnik.username,style: TextStyle(fontStyle: FontStyle.italic),),
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
                servis.obrisiObjavu(a.id);
                setState(() {
                  objave.remove(a);
                  printObjave();
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