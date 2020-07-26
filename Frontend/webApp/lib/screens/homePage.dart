import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:webApp/models/Grad.dart';
import 'package:webApp/models/Kategorija.dart';
import 'dart:html' as html;
import 'package:webApp/models/Korisnik.dart';
import 'package:webApp/models/Statistika.dart';
import 'package:webApp/services/api_services.dart';

import 'AppBarPage.dart';
import 'loginPage.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class Pom
{
  int id;
  String oznaka;
  int brojNeresenihObjava;
  int brojResenihObjava;
  int brojKorisnika;
  charts.Color barColor;
  Pom({this.id,this.oznaka,this.brojNeresenihObjava,this.brojResenihObjava,this.brojKorisnika,this.barColor});
}

class Vreme{
  int id;
  String tekst;
  Vreme({this.id,this.tekst});
}

class _HomePageState extends State<HomePage> {
  static double visina,sirina;
  String token = '';
  Korisnik user;
  api_services servis = api_services();

  Grad selected=Grad();
  List<Grad> gradovi=List<Grad>();

  Kategorija selectedKategorija=Kategorija();
  List<Kategorija> kategorije=List<Kategorija>();

  Vreme selectedVreme=new Vreme();
  List<Vreme> vreme=new List<Vreme>();

  TabelaObjava to=null;

  static Statistika status;
  static Statistika ukupna=null;

  bool izabran=false;

  List<TopGrad> topGradoviLista=null;
  List<Korisnik> topKorisniciLista=null;

  List<TopGrad> aktuelniGradovi=null;
  List<TopKategorija> aktuelneKategorije=null;

  List<Pom> data=[];

  List<Pom> dataKategorija=[];
  List<Pom> dataObjaveNeke=[];
  List<Pom> dataKorisnici = [];

  List<Pom> dataGradoviDesno=[];

  List<Pom> dataKategorijeDesno=[];



  double prosek=-1;

  List<Pom> dataGlasalica=[];

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


  void dajGradovee() {
    servis.dajGradove().then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        gradovi = list.map((model) => Grad.fromObject(model)).toList();

        gradovi.insert(0, selected);
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
        //selectedKategorija=kategorije[0];
      });
    });
  }


  void getUkupna(int a, int b, int c)
  {
    servis.fetchStatistika(a,b,c).then((response) {
      Map<String, dynamic> jsonObject  = json.decode(response.body);
      Statistika s = new Statistika();
      s = Statistika.fromObject(jsonObject);
      setState(() {
        ukupna=s;
        dataObjaveNeke=[];
        dataObjaveNeke=[
          Pom(id:3,oznaka:"Rešene objave",brojNeresenihObjava:ukupna.brojResenihProblema,barColor: charts.ColorUtil.fromDartColor(Colors.orange)),
          Pom(id:3,oznaka:"Nerešene objave",brojNeresenihObjava:ukupna.brojNeresenihProblema,barColor: charts.ColorUtil.fromDartColor(Colors.red)),
          Pom(id:3,oznaka:"Prijavljene objave",brojNeresenihObjava:ukupna.brojPrijavljenihObjava,barColor: charts.ColorUtil.fromDartColor(Colors.amberAccent)),
        ];


      });
    });

  }

  void getTop10Gradova(){
    servis.fetchTop10Gradova().then((response) {
      Iterable list = json.decode(response.body);
      List<TopGrad> top = List<TopGrad>();
      top = list.map((model) => TopGrad.fromObject(model)).toList();
      setState(() {
        topGradoviLista=top;
      });
    });
  }

  void getTop10Korisnika(){
    servis.fetchTop10Korisnika().then((response) {
      Iterable list = json.decode(response.body);
      List<Korisnik> top = List<Korisnik>();
      top = list.map((model) => Korisnik.fromObject(model)).toList();
      setState(() {
        topKorisniciLista=top;
      });
    });
  }

  void getProsek(){
    int a,b;
    servis.fetchOcena().then((response) {
      Map<String, dynamic> jsonObject  = json.decode(response.body);
      setState(() {
        prosek=jsonObject['prosecnaOcena'];

        a=jsonObject['glasalo'];
        b=jsonObject['nijeGlasalo'];

        dataGlasalica=[];
        dataGlasalica=[
            Pom(id:3,oznaka: "Glasali",brojNeresenihObjava:a,barColor: charts.ColorUtil.fromDartColor(Colors.orange)),
            Pom(id:3,oznaka: "Nisu glasali",brojNeresenihObjava:b,barColor: charts.ColorUtil.fromDartColor(Colors.redAccent)),
        ];

      });
    });
  }

  // a-idGrada, b-idKategorije, c-idVreme
  void getTabelaObjava(int a, int b, int c)
  {
      servis.fetchTabelaObjava(a,b,c).then((response){
        Map<String, dynamic> jsonObject  = json.decode(response.body);
        setState(() {

          to=new TabelaObjava(
              brojResenihObjava:jsonObject['brojResenihObjava'],
              brojNeresenihObjava:jsonObject['brojNeresenihObjava'],
              prosecnaBrojLajkovaR:jsonObject['prosecnaBrojLajkovaR'],
              prosecnaBrojDislajkovaR:jsonObject['prosecnaBrojDislajkovaR'],
              prosecnaBrojPrijavaR:jsonObject['prosecnaBrojPrijavaR'],
              prosecnaBrojKomentaraR:jsonObject['prosecnaBrojKomentaraR'],
              prosecnaBrojLajkovaN:jsonObject['prosecnaBrojLajkovaN'],
              prosecnaBrojDislajkovaN:jsonObject['prosecnaBrojDislajkovaN'],
              prosecnaBrojPrijavaN:jsonObject['prosecnaBrojPrijavaN'],
              prosecnaBrojKomentaraN:jsonObject['prosecnaBrojKomentaraN']
          );

        });
      });

  }

  void getAktuelneGradove()
  {
    servis.fetchAktuelneGradove().then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        aktuelniGradovi = list.map((model) => TopGrad.fromObject(model)).toList();

        dataGradoviDesno=[];
        dataGradoviDesno.add(Pom(id:3,oznaka: aktuelniGradovi[0].nazivGrada,brojNeresenihObjava:aktuelniGradovi[0].ukupno,barColor: charts.ColorUtil.fromDartColor(Colors.orange)),);
        dataGradoviDesno.add(Pom(id:3,oznaka: aktuelniGradovi[1].nazivGrada,brojNeresenihObjava:aktuelniGradovi[1].ukupno,barColor: charts.ColorUtil.fromDartColor(Colors.blueGrey)),);
        dataGradoviDesno.add(Pom(id:3,oznaka: aktuelniGradovi[2].nazivGrada,brojNeresenihObjava:aktuelniGradovi[2].ukupno,barColor: charts.ColorUtil.fromDartColor(Colors.grey)),);
        dataGradoviDesno.add(Pom(id:3,oznaka: aktuelniGradovi[3].nazivGrada,brojNeresenihObjava:aktuelniGradovi[3].ukupno,barColor: charts.ColorUtil.fromDartColor(Colors.red)),);
        //dataGradoviDesno.add(Pom(id:3,oznaka: aktuelniGradovi[4].nazivGrada,brojNeresenihObjava:aktuelniGradovi[4].ukupno,barColor: charts.ColorUtil.fromDartColor(Colors.pink)),);
      });
    });
  }

  void getAktuelneKategorije()
  {
    servis.fetchAktuelneKategorije().then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        aktuelneKategorije = list.map((model) => TopKategorija.fromObject(model)).toList();
        dataKategorijeDesno=[];
        dataKategorijeDesno.add(Pom(id:3,oznaka: aktuelneKategorije[0].imeKategorije,brojNeresenihObjava:aktuelneKategorije[0].ukupanBroj,barColor: charts.ColorUtil.fromDartColor(Colors.orange)),);
        dataKategorijeDesno.add(Pom(id:3,oznaka: aktuelneKategorije[1].imeKategorije,brojNeresenihObjava:aktuelneKategorije[1].ukupanBroj,barColor: charts.ColorUtil.fromDartColor(Colors.blueGrey)),);
        dataKategorijeDesno.add(Pom(id:3,oznaka: aktuelneKategorije[2].imeKategorije,brojNeresenihObjava:aktuelneKategorije[2].ukupanBroj,barColor: charts.ColorUtil.fromDartColor(Colors.grey)),);
        dataKategorijeDesno.add(Pom(id:3,oznaka: aktuelneKategorije[3].imeKategorije,brojNeresenihObjava:aktuelneKategorije[3].ukupanBroj,barColor: charts.ColorUtil.fromDartColor(Colors.red)),);
        //dataKategorijeDesno.add(Pom(id:3,oznaka: aktuelneKategorije[4].imeKategorije,brojNeresenihObjava:aktuelneKategorije[4].ukupanBroj,barColor: charts.ColorUtil.fromDartColor(Colors.orange)),);

      });
    });
  }

  void getKatStat(int a)
  {
    servis.fetchStatistikaKategorije(a).then((response) {
      Map<String, dynamic> jsonObject  = json.decode(response.body);
      setState(() {
        int b=jsonObject['brojResenihProblema'];
        int c=jsonObject['brojNeresenihProblema'];

        dataKategorija=[];
        dataKategorija=[
          Pom(id:3,oznaka: "Rešene objave",brojNeresenihObjava:b,barColor: charts.ColorUtil.fromDartColor(Colors.lightBlue)),
          Pom(id:3,oznaka: "Nerešene objave",brojNeresenihObjava:c,barColor: charts.ColorUtil.fromDartColor(Colors.grey)),
        ];
      });
    });
  }


  initState() {

    if(html.window.sessionStorage.length==0)
    {

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
    getToken();
    selected.id=0;
    selected.naziv_grada_lat="Svi gradovi";
    selected.naziv_grada_cir=" ";
    if(gradovi.length==0)
    {
      //CircularProgressIndicator();
      dajGradovee();

    }

    if(vreme.length==0)
    {
      vreme.add(new Vreme(id:1,tekst:"Poslednjih sedam dana"));
      vreme.add(new Vreme(id:2,tekst:"Poslednjih mesec dana"));
      vreme.add(new Vreme(id:3,tekst:"Oduvek"));
      selectedVreme=vreme[2];
    }

    selectedKategorija.id=0;
    selectedKategorija.kategorija="Sve kategorije";

    if(kategorije.length==0)
    {
      //CircularProgressIndicator();
      getKategorije();

    }

    if(topKorisniciLista==null)
    {
      getTop10Korisnika();
    }

    if(topGradoviLista==null)
    {
      getTop10Gradova();
    }
    if(to==null)
    {
      getTabelaObjava(0,0,3);
    }

    getUkupna(0,0,3);


    if(aktuelniGradovi==null)
    {
      getAktuelneGradove();
    }

    if(aktuelneKategorije==null)
    {
      getAktuelneKategorije();
    }

    super.initState();
  }
/*

try {

} on Exception catch (exception) {

} catch (error) {

}

*/


  List<DropdownMenuItem<Grad>> buildDropdownMenuItems(List<Grad> _gradovi) {
    List<DropdownMenuItem<Grad>> items = List();
    for (Grad grad in _gradovi) {
      items.add(
        DropdownMenuItem(
          value: grad,
          child: Text(grad.naziv_grada_lat),
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
          child: Text(k.kategorija),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Vreme>> buildMenuVreme(List<Vreme> _kat) {
    List<DropdownMenuItem<Vreme>> items = List();
    for (Vreme k in _kat) {
      items.add(
        DropdownMenuItem(
          value: k,
          child: Text(k.tekst),
        ),
      );
    }
    return items;
  }


  String _value;
  Widget prikaziSadrzaj()
  {
    if(prosek < 0)
    {
      getProsek();
    }

    if(dataGradoviDesno.length==0)
    {
      getAktuelneGradove();
    }

    if(dataKategorijeDesno.length==0)
    {
      getAktuelneKategorije();
    }

    if(dataKategorija.length==0)
    {
      getKatStat(0);
    }

    if(selected==null)
      {
        dajGradovee();
      }

    if(selectedKategorija==null)
      {
        getKategorije();
      }
    return new Container(
      //margin: EdgeInsets.all(10.0),
        child: new Wrap(
          children: <Widget>[
            //Leva Traka
            new Container(
              color:Colors.grey.shade200,
             height:MediaQuery.of(context).size.height ,
             //decoration:BoxDecoration(
             //   border: Border.all(color:Colors.grey),
             //   //borderRadius: BorderRadius.circular(5),
             // ),
              //padding: EdgeInsets.only(top:5.0,right:5.0,left:5.0),
              width:210.0,
              //color:Colors.red,
              child:new Center(
                child:  new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /*
                    new Container(

                      child:new Column(
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(top:2.0),
                            child:Text("Prosečna ocena aplikacije"),
                          ),
                          new Container(
                            margin: EdgeInsets.only(left:10,bottom:5.0),
                            child:prosek!=-1?Text(prosek.toString()+"/5",
                              style: new TextStyle(
                                fontSize: 30.0,
                                color:Colors.black//Color.fromRGBO(255,223,0,1),
                              ),
                            ):Text("",style: new TextStyle(
                                fontSize: 30.0,
                                color:Colors.black//Color.fromRGBO(255,223,0,1),
                            ),
                            )

                          ),

                          dataGlasalica.length!=0?(dataGlasalica[0].brojNeresenihObjava==0?
                          new Container(
                            width: 230,
                            height: 140,
                            child:Center(
                                child:Text("Niko još uvek nije ocenio aplikaciju")
                            ),
                          ) :(dataGlasalica[1].brojNeresenihObjava==0?
                          new Container(
                            width: 230,
                            height: 100,
                            child:Center(
                              child:Text("Svi su ocenili aplikaciju")
                            ),
                          ):
                          new Container(
                            color:Colors.grey.shade300,
                            width: 230,
                            height: 140,
                            child:dataGlasalica.length==0?CircularProgressIndicator():DonutAutoLabelChart2(dataGlasalica),
                          )
                          )
                          ):CircularProgressIndicator(),


                        ],
                      ),
                    ),
                     */
                    topKorisniciLista!=null?new Container(
                      child:Text("TOP "+topKorisniciLista.length.toString()+" Korisnika"),
                      margin: EdgeInsets.only(top:5,bottom:10),
                    ):new Container(
                      child:Text("Podaci se prikupljaju"),
                      margin: EdgeInsets.only(bottom:5),
                    ),
                    topKorisniciLista==null?Text("Podaci se prikupljaju"):prikaziTopU(),

                    SizedBox(height: 10,),

                    topGradoviLista!=null?new Container(
                      child:Text("TOP "+topGradoviLista.length.toString()+" Gradova"),
                      margin: EdgeInsets.only(top:30,bottom:10),
                    ):new Container(
                      child:Text("Podaci se prikupljaju"),
                      margin: EdgeInsets.only(bottom:5),
                    ),
                    topGradoviLista==null?CircularProgressIndicator():prikaziTopG(),

                    new Container(
                        alignment:Alignment.bottomLeft,
                        margin: EdgeInsets.only(bottom:5.0,top:10),
                        child:Text("*Rangiranje po broju poena",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 11.0),)
                    )

                  ],
                ),
              ),
            ),

            //Sredina
            new Container(
              margin: EdgeInsets.only(left:5.0),
              width:810.0,
              //color:Colors.blue,
              child: Wrap(
                direction: Axis.vertical,
                children: <Widget>[
                  //Kombo boksovi
                  new Container(
                    margin: EdgeInsets.only(top:5.0),
                    child: Wrap(
                      children: <Widget>[
                        //Kombo boks gradovi
                        new Container(
                            margin: EdgeInsets.only(left:30.0),
                          child:new Column(
                            children: <Widget>[
                              new Container(
                                margin: EdgeInsets.only(top:5.0),
                                child:Text("Grad"),
                              ),
                              new Container(
                                margin: EdgeInsets.only(top:5.0,bottom:15.0),
                                child:new DropdownButton(
                                    items: buildDropdownMenuItems(gradovi),
                                    value: selected,
                                    onChanged: (value) {
                                      Statistika s;

                                      setState(() {
                                        selected = value;
                                        status=s;
                                        getUkupna(selected.id, selectedKategorija.id, selectedVreme.id);
                                        getTabelaObjava(selected.id, selectedKategorija.id, selectedVreme.id);
                                        prikaziSadrzaj();

                                      });


                                    }),
                              ),
                            ],
                          )
                        ),

                        //Kombo boks kategorije
                        new Container(
                            margin: EdgeInsets.only(left:40.0),
                            child:new Column(
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(top:5.0),
                                  child:Text("Kategorija"),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(top:5.0,bottom:15.0),
                                  child:new DropdownButton(
                                      items: buildMenuKategorije(kategorije),
                                      value: selectedKategorija,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedKategorija = value;
                                          getUkupna(selected.id, selectedKategorija.id, selectedVreme.id);
                                          getTabelaObjava(selected.id, selectedKategorija.id, selectedVreme.id);
                                          getKatStat(selectedKategorija.id);
                                          prikaziSadrzaj();

                                        });
                                      }),
                                ),
                              ],
                            )
                        ),

                        //Kombo boks vreme
                        new Container(
                            margin: EdgeInsets.only(left:40.0),
                            child:new Column(
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(top:5.0),
                                  child:Text("Vremenski period"),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(top:5.0,bottom:15.0),
                                  child: new DropdownButton(
                                      items: buildMenuVreme(vreme),
                                      value: selectedVreme,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedVreme = value;

                                          getUkupna(selected.id, selectedKategorija.id, selectedVreme.id);
                                          getTabelaObjava(selected.id, selectedKategorija.id, selectedVreme.id);
                                          prikaziSadrzaj();
                                        });

                                      }),
                                ),
                              ],
                            )
                        ),

                      ],
                    ),
                  ),


                  //Grafici neki, red 1
                  new Container(
                    margin: EdgeInsets.only(left:30.0,top:20.0),
                    //color:Colors.green,
                    width: 770,
                    child:Wrap(
                      children: <Widget>[
                        new Container(
                          //color:Colors.yellow,
                          width: 350,
                          height: 180,
                          child:dataObjaveNeke.length!=0?(dataObjaveNeke[0].brojNeresenihObjava==0 && dataObjaveNeke[1].brojNeresenihObjava==0 && dataObjaveNeke[2].brojNeresenihObjava==0?
                              new Container(
                                width: 200,
                                  child:Center(child: Text("Nema objava izbrane kategorije za  "+selected.naziv_grada_lat))
                              )
                              :SimpleSeriesLegend(dataObjaveNeke)):Text(""),
                        ),
                        new Container(
                          margin: EdgeInsets.only(left: 10.0),
                          //color:Colors.green,
                          width: 350,
                          height: 180,
                          child:dataKategorija.length!=0?(dataKategorija[0].brojNeresenihObjava==0 && dataKategorija[1].brojNeresenihObjava==0?new Center(child:Text("Trenutno nema objava kategorije "+selectedKategorija.kategorija)):(dataKategorija[0].brojNeresenihObjava==0?DonutAutoLabelChart2(dataKategorija):(dataKategorija[1].brojNeresenihObjava==0?DonutAutoLabelChart2(dataKategorija):DonutAutoLabelChart2(dataKategorija)))):Text(""),
                        ),
                      ],
                    ),
                  ),

                  new Container(
                    margin: EdgeInsets.only(left:30.0,top:10.0),
                    //color:Colors.green,
                    width: 770,
                    child:Wrap(
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(left: 30.0),
                          width: 280,
                          height: 30,
                          child: Text("Prikaz broja rešenih, nerešenih i prijavljenih objava izbranog grada",style: TextStyle(fontSize: 12),)
                        ),
                        new Container(
                            margin: EdgeInsets.only(left: 70.0),
                           // color:Colors.green,
                            width: 330,
                            height: 30,
                            child:Text("Broja rešenih i nerešenih objava za izabranu kategoriju od pocetka rada aplikacije",style: TextStyle(fontSize: 12),)
                        ),
                      ],
                    ),
                  ),
/*
                  //Grafici, red 2
                  new Container(
                    margin: EdgeInsets.only(left:30.0,top:20.0),
                    //color:Colors.green,
                    width: 770,
                    child:Wrap(
                      children: <Widget>[
                        new Container(
                          //color:Colors.yellow,
                          width: 350,
                          height: 180,
                          child:dataObjaveNeke.length!=0?SimpleSeriesLegend(dataObjaveNeke):Text(""),
                        ),
                        new Container(
                          margin: EdgeInsets.only(left: 10.0),
                          color:Colors.green,
                          width: 350,
                          height: 180,
                          child:dataKategorija.length!=0?(dataKategorija[0].brojNeresenihObjava==0 && dataKategorija[1].brojNeresenihObjava==0?new Center(child:Text("Trenutno nema objava ove kategorije")):(dataKategorija[0].brojNeresenihObjava==0?DonutAutoLabelChart2(dataKategorija):(dataKategorija[1].brojNeresenihObjava==0?DonutAutoLabelChart2(dataKategorija):DonutAutoLabelChart2(dataKategorija)))):Text(""),
                        ),
                      ],
                    ),
                  ),
                  */

                  //Tabela reseni vs nereseni problemi
                  new Container(
                    margin: EdgeInsets.only(left:130.0,top:80.0),
                    width: 750,
                    child:to==null?CircularProgressIndicator():prikaziTabelu()
                  ),
                  new Container(
                    margin: EdgeInsets.only(left:140.0,top:20.0),
                    width: 520,
                    child: Text("Tabela prikaza odnosa prosečnog broja lajkova, dislajkova, komentara "
                        "i prijava za rešene i nerešene probleme u zavisnosti od izabranog grada, kategorije i vremenskog perioda",style: TextStyle(fontSize: 12),),
                  )
                ],
              ),
            ),

            //Desna Traka
            new Container(
              margin: EdgeInsets.only(left:5.0),
              width:250.0,
              height:MediaQuery.of(context).size.height ,
              color:Colors.grey.shade200,
              child: new Center(
               child: new Container(
                  child:new Column(
                    children: <Widget>[
                      new Container(
                        child:Text("Gradovi sa najviše objava"),
                        margin: EdgeInsets.only(bottom:15.0,top:2.0),
                      ),
                      aktuelniGradovi==null || aktuelniGradovi.length<4?Text("Nema dovoljno prikupljenih podataka za prikaz ove statistike"):new Container(
                        child:new Column(
                          children: <Widget>[
                            new Container(
                              //color: Colors.green,
                              child:new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                          margin: EdgeInsets.only(left:10.0,right:5.0),
                                          width: 15.0,
                                          height: 15.0,
                                          color:Colors.orange
                                      ),
                                      Text(aktuelniGradovi[0].nazivGrada),
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Container(
                                          margin: EdgeInsets.only(left:10.0,right:5.0,top:5.0),
                                          width: 15.0,
                                          height: 15.0,
                                          color:Colors.blueGrey
                                      ),
                                      new Container(
                                        margin: EdgeInsets.only(top:5.0),
                                        child: Text(aktuelniGradovi[1].nazivGrada),
                                      )
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Container(
                                          margin: EdgeInsets.only(left:10.0,right:5.0,top:5.0),
                                          width: 15.0,
                                          height: 15.0,
                                          color:Colors.grey
                                      ),
                                      new Container(
                                        margin: EdgeInsets.only(top:5.0),
                                        child: Text(aktuelniGradovi[2].nazivGrada),
                                      )
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Container(
                                          margin: EdgeInsets.only(left:10.0,right:5.0,top:5.0),
                                          width: 15.0,
                                          height: 15.0,
                                          color:Colors.red
                                      ),
                                      new Container(
                                        margin: EdgeInsets.only(top:5.0),
                                        child: Text(aktuelniGradovi[3].nazivGrada),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      new Container(
                        margin: EdgeInsets.only(top:15.0),
                        color:dataGradoviDesno.length<4?Colors.grey.shade200:Colors.grey.shade300,
                        width: 300,
                        height: 150,
                        child:dataGradoviDesno.length<4?Text(""):DonutAutoLabelChartBezLegende(dataGradoviDesno),
                      ),
                      new Container(
                        child:Text("Kategorije sa najviše objava"),
                        margin: EdgeInsets.only(bottom:25.0,top:45.0),
                      ),
                      aktuelneKategorije==null || aktuelneKategorije.length<4?Text("Nema dovoljno prikupljenih podataka za prikaz ove statistike"):new Container(
                        child:new Column(
                          children: <Widget>[
                            new Container(
                              //color: Colors.green,
                              child:new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                          margin: EdgeInsets.only(left:10.0,right:5.0),
                                          width: 15.0,
                                          height: 15.0,
                                          color:Colors.orange
                                      ),
                                      new Container(
                                          margin: EdgeInsets.only(top:5.0),
                                        child:Text(aktuelneKategorije[0].imeKategorije)
                                      )
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Container(
                                          margin: EdgeInsets.only(left:10.0,right:5.0),
                                          width: 15.0,
                                          height: 15.0,
                                          color:Colors.blueGrey
                                      ),
                                      new Container(
                                          margin: EdgeInsets.only(top:5.0),
                                          child:Text(aktuelneKategorije[1].imeKategorije)
                                      )
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Container(
                                          margin: EdgeInsets.only(left:10.0,right:5.0),
                                          width: 15.0,
                                          height: 15.0,
                                          color:Colors.grey
                                      ),
                                      new Container(
                                          margin: EdgeInsets.only(top:5.0),
                                          child:Text(aktuelneKategorije[2].imeKategorije)
                                      )
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Container(
                                          margin: EdgeInsets.only(left:10.0,right:5.0),
                                          width: 15.0,
                                          height: 15.0,
                                          color:Colors.red
                                      ),
                                      new Container(
                                          margin: EdgeInsets.only(top:5.0),
                                          child:Text(aktuelneKategorije[3].imeKategorije)
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            new Container(
                              color:Colors.grey.shade300,
                              width: 300,
                              height: 150,
                              child:dataKategorijeDesno.length<4?CircularProgressIndicator():DonutAutoLabelChartBezLegende(dataKategorijeDesno),
                              margin: EdgeInsets.only(top:15.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget build(BuildContext context) {
    sirina=MediaQuery.of(context).size.width;
    visina=MediaQuery.of(context).size.height;

    return Scaffold(
      body:Center(
          child:prikaziSadrzaj()
      ),
    );
  }

  Widget prikaziTabelu()
  {
    return Wrap(
      direction: Axis.vertical,
      children: <Widget>[
        new Table(
         defaultColumnWidth: FixedColumnWidth(170.0),
          children: [
            TableRow(
              decoration: BoxDecoration(
                border:Border(
                bottom: BorderSide(
                color: Colors.black,
                width: 1.0,
                ),
               )
              ),
                children:[
                  TableCell(
                    child:Center(
                        child: new Container(
                            padding: EdgeInsets.all(5),
                            child:Text('')
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                            padding: EdgeInsets.all(5),
                            child:Text('Rešeni problemi')
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                            padding: EdgeInsets.all(5),
                            child:Text('Nerešeni problemi')
                        )
                    ),
                  ),
                ]
            ),
            TableRow(
                decoration: BoxDecoration(
                    border:Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                  //    right: BorderSide(
                  //      color: Colors.black,
                  //      width: 1.0,
                  //    ),
                  //    left: BorderSide(
                  //      color: Colors.black,
                  //      width: 1.0,
                  //    ),
                    )
                ),
                children:[
                  TableCell(
                    child:Center(
                        child: new Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border:Border(
                                  /*
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),

                                   */
                                )
                            ),
                          child:Text('Ukupno problema')
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                            //alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child:Text(to.brojResenihObjava.toString())
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                          //alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child:Text(to.brojNeresenihObjava.toString())
                        )
                    ),
                  ),
                ]
            ),
            TableRow(
                decoration: BoxDecoration(
                    border:Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      /*
                      right: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),

                      */
                    )
                ),
                children:[
                  TableCell(
                    child:Center(
                        child: new Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border:Border(
                                  /*
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),

                                   */
                                )
                            ),
                            child:Text('Prosečno lajkova')
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                          //alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child:Text(to.prosecnaBrojLajkovaR.toString())
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                          //alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child:Text(to.prosecnaBrojLajkovaN.toString())
                        )
                    ),
                  ),
                ]
            ),
            TableRow(
                decoration: BoxDecoration(
                    border:Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      /*
                      right: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),

                      */
                    )
                ),
                children:[
                  TableCell(
                    child:Center(
                        child: new Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border:Border(
                                  /*
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),

                                   */
                                )
                            ),
                            child:Text('Prosečno dislajkova')
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                          //alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child:Text(to.prosecnaBrojDislajkovaR.toString())
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                          //alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child:Text(to.prosecnaBrojDislajkovaN.toString())
                        )
                    ),
                  ),
                ]
            ),
            TableRow(
                decoration: BoxDecoration(
                    border:Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      /*
                      right: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),

                      */
                    )
                ),
                children:[
                  TableCell(
                    child:Center(
                        child: new Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border:Border(
                                  /*
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),

                                   */
                                )
                            ),
                            child:Text('Prosečno komentara')
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                          //alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child:Text(to.prosecnaBrojKomentaraR.toString())
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                          //alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child:Text(to.prosecnaBrojKomentaraN.toString())
                        )
                    ),
                  ),
                ]
            ),
            TableRow(
                decoration: BoxDecoration(
                    border:Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      /*
                      right: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),

                      */
                    )
                ),
                children:[
                  TableCell(
                    child:Center(
                        child: new Container(
                          alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border:Border(
                                  /*
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),

                                   */
                                )
                            ),
                            child:Text('Prosečno prijava')
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                          //alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child:Text(to.prosecnaBrojPrijavaR.toString())
                        )
                    ),
                  ),
                  TableCell(
                    child:Center(
                        child: new Container(
                          //alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child:Text(to.prosecnaBrojPrijavaN.toString())
                        )
                    ),
                  ),
                ]
            ),
          ],
        )
      ],
    );
  }

  Widget prikaziTopU()
  {
    if (topKorisniciLista == null) {
      return new Center(child:Text("Nema rangiranih korisnika"));
    }

    return ListView.builder(
      itemCount: topKorisniciLista.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
            width: 200.0,
            margin: EdgeInsets.all(2),

            child:new Container(
              alignment: Alignment.center,
              child:GestureDetector(
                onTap: (){
                  setState(() {
                    AppBarPageState.trenIndex=4;
                    html.window.sessionStorage['Idkorisnika']=topKorisniciLista[index].id.toString();
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppBarPage()
                          /*prikazMape(latitude, longitude)*/));
                  });
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left:50,top:5),
                    child:new Wrap(
                      children: <Widget>[
                        Text((index+1).toString()+". "),
                        index==0?Text(topKorisniciLista[0].username,style: TextStyle(color: Color.fromRGBO(255,215,0,1.0)),)
                            :(index==1?Text(topKorisniciLista[1].username,style: TextStyle(color: Color.fromRGBO(104,112,124,1.0)))
                            :(index==2?Text(topKorisniciLista[2].username,style: TextStyle(color: Color.fromRGBO(205,127,50,1.0))):Text(topKorisniciLista[index].username))),
                        Text(" "+topKorisniciLista[index].poeni.toString())
                        //Text(" "+topKorisniciLista[index].poeni.toString())
                      ],
                    )
                ),
              ),
            )
        );
      },
    );

  }

  Widget prikaziTopG()
  {
    if (topGradoviLista == null) {
      return new Center(child:Text("Nema rangiranih gradova"));
    }

    return ListView.builder(
      itemCount: topGradoviLista.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
            width: 200.0,
            margin: EdgeInsets.all(2),
            child:new Container(
              alignment: Alignment.center,
              child:Container(
                  alignment: Alignment.centerLeft,
                  margin:  EdgeInsets.only(left:50,top:5),
                  child:new Wrap(
                    children: <Widget>[
                      Text((index+1).toString()+". "),
                      index==0?Text(topGradoviLista[0].nazivGrada,style: TextStyle(color: Color.fromRGBO(255,215,0,1.0)),)
                          :(index==1?Text(topGradoviLista[1].nazivGrada,style: TextStyle(color: Color.fromRGBO(104,112,124,1.0)))
                          :(index==2?Text(topGradoviLista[2].nazivGrada,style: TextStyle(color: Color.fromRGBO(205,127,50,1.0))):Text(topGradoviLista[index].nazivGrada))),
                      Text(" "+topGradoviLista[index].brojPoena.toString())
                      //Text(" "+topKorisniciLista[index].poeni.toString())
                    ],
                  )
              ),
            )
        );
      },
    );

  }

}


class SimpleSeriesLegend extends StatelessWidget {
  final bool animate=false;
  List<Pom> data=[];


  SimpleSeriesLegend(List<Pom> s){
    data=s;
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _createSampleData(),
      animate: animate,
      //barGroupingType: charts.BarGroupingType.grouped,
      //behaviors: [new charts.SeriesLegend()],
    );
  }

  /// Create series list with multiple series
   List<charts.Series<Pom, String>> _createSampleData() {

    return [
      new charts.Series<Pom, String>(
        id: 'Nesto',
        domainFn: (Pom sales, _) => sales.oznaka,
        measureFn: (Pom sales, _) => sales.brojNeresenihObjava,
        colorFn: (Pom sales, _) => sales.barColor,
        data: data,
      )
    ];
  }
}









class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData() {
    return new SimpleTimeSeriesChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class DonutAutoLabelChart2 extends StatelessWidget {
  final bool animate=false;

  List<Pom> data=[];


  DonutAutoLabelChart2(List<Pom> s){
    data=s;
  }


  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(_getSeriesData(),
        animate: animate,
        behaviors: [new charts.DatumLegend()],//za paj chart
        //behaviors: [new charts.SeriesLegend()],
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()])
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<Pom, String>> _getSeriesData() {

    return [
      new charts.Series<Pom, String>(
        id: 'Sales',
        domainFn: (Pom sales, _) => sales.oznaka,
        measureFn: (Pom sales, _) => sales.brojNeresenihObjava,
        data: data,
        colorFn: (Pom p, _) => p.barColor,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (Pom row, _) => '${row.brojNeresenihObjava}',
      )
    ];
  }
}

class DonutAutoLabelChartBezLegende extends StatelessWidget {
  final bool animate=false;

  List<Pom> data=[];


  DonutAutoLabelChartBezLegende(List<Pom> s){
    data=s;
  }


  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(_getSeriesData(),
        animate: animate,
        //behaviors: [new charts.DatumLegend()],//za paj chart
        //behaviors: [new charts.SeriesLegend()],
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()])
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<Pom, String>> _getSeriesData() {

    return [
      new charts.Series<Pom, String>(
        id: 'Sales',
        domainFn: (Pom sales, _) => sales.oznaka,
        measureFn: (Pom sales, _) => sales.brojNeresenihObjava,
        data: data,
        colorFn: (Pom p, _) => p.barColor,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (Pom row, _) => '${row.brojNeresenihObjava}',
      )
    ];
  }
}
