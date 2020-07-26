import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:webApp/models/Komentar.dart';
import 'package:webApp/models/RazlogReporta.dart';
import 'package:webApp/screens/profilkorisnika.dart';
import '../models/Kategorije.dart';
import '../models/Korisnik.dart';
import '../models/Objava.dart';
import '../models/AktivnostiKorisnika.dart';
import '../models/TekstualnaObjava.dart';
import '../services/api_services.dart';
import './loginPage.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart' as gf;
import 'appBarPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _resenaObjavaController = new TextEditingController();
  TextEditingController _commentController = new TextEditingController();

  var now = DateTime.now();
  String token = '';
  Korisnik user;
  List<TekstualnaObjava> tekstualne_objave;
  api_services servis = api_services();
  List<Objava> objave=List<Objava>();
  List<AktivnostiKorisnika> aktivnosti;
  Future<File> file_comment;
  Position position;
  double latitude;
  double longitude;
  File tmpfile;
  int poslata_slika = 0;
  List<Korisnik> korisnici=List<Korisnik>();
  String slika64;
  List<Kategorija> kategorije=List<Kategorija>();

  Kategorija selectedkat=Kategorija();
  Pomocna selectedsat;
  getToken() async {

    String _token = html.window.sessionStorage['token'];
    Map<String, dynamic> jsonObject = json.decode(html.window.sessionStorage['userInfo']);
    Korisnik extractedUser = new Korisnik();
    extractedUser = Korisnik.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
    });
  }
  List<Korisnik>korisnicii=List<Korisnik>();
  List<Pomocna>statusobj=List<Pomocna>();
  double sirina;
  bool aktivne_objave=false;
  initState() {

    if(html.window.sessionStorage.length<1)
    {
      Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPage()));
    }
    dajListuzaprijavu();
    getToken();
    Pomocna b =Pomocna(1, "Rešene");
    Pomocna c =Pomocna(0, "Nerešene");
    statusobj.add(c);
    statusobj.add(b);

    selectedsat=statusobj[0];


    super.initState();

  }



  void dajObjave() {
    servis.fetchObjaveGradaInstitucijeKojeNisuResene(user.id).then(
          (response) {
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
  void getnereseneObjaveKategorije(int idkate,int idkor) {
    servis.fetchnereseneObjaveByIdKorisnikaiKategorije(idkate,idkor).then(
          (response) {

        Iterable list = json.decode(response.body);
        List<Objava> objaveList = List<Objava>();
        objaveList = list.map((model) => Objava.fromObject(model)).toList();
        setState(()
          {
            objave = objaveList;
          },
        );
      },
    );
  }
  void getreseneObjaveKategorije(int idkate,int idkor) {
    servis.fetchreseneObjaveByIdKorisnikaiKategorije(idkate,idkor).then(
          (response) {

        Iterable list = json.decode(response.body);
        List<Objava> objaveList = List<Objava>();
        objaveList = list.map((model) => Objava.fromObject(model)).toList();
        setState(()
        {
          objave = objaveList;
        },
        );
      },
    );
  }
File slika;
  void ucitavalica(int idObjave,int idInstitucije) async
  {
    Uint8List imageFile= await ImagePickerWeb.getImage(outputType: ImageType.bytes);
   // slika=await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    String str1=base64Encode(imageFile);
    setState(() {
      str=str1;

    });
    if(str!="")
    {
      setState(() {
        zasliku=true;
        Navigator.of(context).pop();
        PostavljanjeResenja(idObjave, idInstitucije);
      });
    }

  }


  bool zasliku=false;
  String str="";
  void PostavljanjeResenja(int idObjave,int idInstitucije) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: _buildText('Označavanje objave kao rešene',18,2,0),
          content: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(left:20.0,top:20.0,bottom: 20.0,right: 20.0),
                  child:Column(
                    children: <Widget>[
                      new TextFormField(
                        controller: _resenaObjavaController,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: "Komentariši",
                        ),
                        maxLines: 1,
                        autocorrect: false,
                        autofocus: false,
                      ),

                    zasliku==true?Container(
                      padding: EdgeInsets.only(top: 20),
                      child: _buildText("Slika je uspešno učitana.", 16, 1, 0),
                      ):Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(

                onPressed: (){
                  ucitavalica(idObjave,idInstitucije);

                },
                child:_buildText("Dodaj sliku",16,2,0)
            ),
            SizedBox(
              width: 15,
            ),
            RaisedButton(

              child: _buildText('Odustani',16,2,0),
              onPressed: () {
                //_resenaObjavaController.text="";
                setState(() {
                  zasliku=false;
                  _resenaObjavaController.text="";
                });
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 15,
            ),
            RaisedButton(

              child: _buildText('Potvrdi',16,2,0),
              onPressed: () {


                //servis.uploadImageComment(file, _resenaObjavaController.text, idInstitucije, idObjave, 1, 1);

                //servis.setComment(_resenaObjavaController.text, idInstitucije, idObjave, 0, 1);

                str!=""? servis.slikaKomentara(user.id, idObjave,str,_resenaObjavaController.text):
                servis.setComment(_resenaObjavaController.text, idInstitucije, idObjave, 0, 1);
                servis.oznaciKaoResen(idObjave, idInstitucije);


              setState(() {
              objave.removeWhere((element) => element.id==idObjave);
              str="";
              zasliku=false;
              _resenaObjavaController.text="";
              stampajObjave();
              });
                Navigator.of(context).pop();
                    },

                  ),
          ],
        );
      },
    );
  }


  void dajKategorije(int id) {
    servis.fetchDajKategorijeinstitucije(id).then((response) {

      Iterable list = json.decode(response.body);
      setState(() {
        kategorije=list.map((model) => Kategorija.fromObject(model)).toList();
        setState(() {
          Kategorija k=Kategorija();
          k.id=0;
          k.naziv="Sve kategorije";
          kategorije.insert(0, k);
        });
        selectedkat=kategorije[0];
      });
    });
  }
  Widget contextObjave(int index) {

    if (objave[index].tekstualna_objava != null) {
      return Container(
        width: sirina/1.4,
        padding: EdgeInsets.symmetric(vertical: 10),
        //alignment: Alignment.center,
        child: _buildText(objave[index].tekstualna_objava.tekst,15+(sirina/250),2,0),

      );
    } else {
      return new Container(
      //  margin:EdgeInsets.symmetric(horizontal: 10) ,
        width: sirina/1.3,

        child: Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            objave[index].slika.opis_slike != null?
            Container(
                width: sirina/1.4,
                padding: EdgeInsets.symmetric(vertical: 10),
                  child:_buildText(objave[index].slika.opis_slike,15+(sirina/250),2,0)
            ):Container(height: 0,),

            Container(
              alignment: Alignment.center,
              padding: sirina>500? sirina>1000?EdgeInsets.symmetric(horizontal: 100):EdgeInsets.symmetric(horizontal: 50):EdgeInsets.all(5),
              child: Image.network(
                api_services.url_za_slike + objave[index].slika.urlSlike,
                width: 250,
                height: 170,
              ),
            )
          ],
        ),

      );
    }
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
        PrikazLajkDislajk(0);
      },
    );
  }


  void getLikes(int idObjave){
    servis.fetchLikes(idObjave).then(
          (response) {
        Iterable list = json.decode(response.body);
        List<Korisnik> korisniciList = List<Korisnik>();
        korisniciList = list.map((model) => Korisnik.fromObject(model)).toList();
        setState(
              () {
            korisnicii = korisniciList;
          },
        );
        PrikazLajkDislajk(1);
      },
    );
  }



  void PrikazLajkDislajk(int broj) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(

            child: Container(
              alignment: Alignment.center,
              width: 365+sirina/400*10,
              height: 300+sirina/400*10,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    broj == 0 ? Container(
                      alignment: Alignment.center,
                      child: _buildText("Korisnici koji su dislakjovali objavu",14+sirina/250,2,1),
                    ) : Container(
                      alignment: Alignment.center,
                      child: _buildText(
                          "Korisnici koji su lakjovali objavu",16+sirina/250,2,1),
                    ),
                    korisnicii.length!=0?Container(
                      child: ListView.builder(
                          itemCount: korisnicii.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(10.0),
                                //height: visible_comment_section[index] ?  340 : 250,
                                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)
                                ),
                                child:Row(children: <Widget>[
                                  new Container(
                                    child:new Icon(Icons.account_circle),
                                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  ),
                                  korisnicii[index].uloga=="institucija"?
                                  Container(child: _buildText(korisnicii[index].ime ,14+(sirina/250),2,0)):
                                  Container(child: _buildText(korisnicii[index].ime + ' ' + korisnicii[index].prezime,14+(sirina/250),2,0))

                                ],)
                            );
                          }),

                    ):Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child:broj==0?_buildText("Nema dislajkovao",14+sirina/250,2,0):
                        _buildText("Nema lajkovao",14+sirina/250,2,0)
                    ),
                    RaisedButton(
                      child: _buildText("Zatvori",16,2,0),
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

  List<Komentar> komentari=  List<Komentar>();
  void getComments(int idObjave) async {

    servis.fetchComments(idObjave,user.id).then(
          (response) {
        Iterable list = json.decode(response.body);
        List<Komentar> korisniciList = List<Komentar>();
        korisniciList =
            list.map((model) => Komentar.fromObject(model)).toList();
        setState(() {
          komentari=korisniciList;
          PrikazKomentaraUProzoru(idObjave);

        });
      },
    );

  }


  void PrikazKomentaraUProzoru( int broj)
  {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              alignment: Alignment.center,
              width: sirina/2,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    Container(
                      width: sirina/2,
                      alignment: Alignment.center,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            width: sirina/2.8,
                            child: TextFormField(
                              decoration: InputDecoration(hintText: 'Unesite komentar...'),
                              controller: _commentController,
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: RaisedButton(
                              child: _buildText("Komentariši",12+sirina/250,2,0),
                              onPressed:(){
                                if(_commentController.text!="")
                               {
                                 servis.setComment(_commentController.text, user.id, broj, 0,0).then((val){
                                   setState(() {
                                     Navigator.of(context).pop();
                                     getComments(broj);
                                     _commentController.text="";
                                   });
                                 });
                               }


                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: RaisedButton(
                        child: _buildText("Zatvori",14+sirina/250,2,0),
                        onPressed:(){
                          dajObjave();
                          stampajObjave();
                          Navigator.pop(context);
                        } ,
                      ),
                    ),
                    SizedBox(height: 10,),

                    PrikazSadrzajakKomentara(broj),
                  ],
                ),
              ),
            ),


          );
        });




  }

  Color bojaZavisnaOdResenosti(int index){
    if(index == 1){
      return Color.fromRGBO(120, 249, 133, 0.4);
    }else{
      return Colors.white12;
    }
  }

  FocusNode _textNode1 = new FocusNode();


  Widget PrikazSadrzajakKomentara(int idObjave)
  {

    if(komentari.length==0)
    {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child:_buildText("Nema komentara",16+sirina/250,2,0)

      );
    }
    else
      return
        Container(
          child: ListView.builder(
              itemCount: komentari.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
                return Container(
                  width: sirina/1.3,
                  alignment: Alignment.center,


                  child: Container(
                    width: sirina/1.5,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: bojaZavisnaOdResenosti(komentari[index].oznacenKaoResen)  /*bojaZavisnaOdResenosti(korisnici[index].oznacenKaoResen)*/
                    ),
                    child: Wrap(
                      direction: Axis.vertical,
                      children: <Widget>[

                        Container(

                          width: sirina/1.5,
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: <Widget>[

                              new Container(
                                alignment: Alignment.centerLeft,
                                width: 60.0,
                                height:60.0,
                                child: (komentari[index].korisnik.urlSlike!=null)?
                                ClipOval(
                                  child: Image.network(
                                    api_services.url_za_slike+komentari[index].korisnik.urlSlike,

                                    height: 50+(sirina/500*7),
                                    width: 50+(sirina/500*7),
                                    fit: BoxFit.cover,

                                  ),
                                )
                                    : Container(
                                    width: 50+(sirina/500*7),
                                    height: 50+(sirina/500*7),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.person, color: Color.fromRGBO(
                                        59, 227, 168,1), size: 30+(sirina/500*5),)
                                ),
                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                              ),
                              Container(

                                child: Wrap(
                                  direction: Axis.vertical,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _buildText("@"+komentari[index].korisnik.username,13.0+(sirina/250.0).ceil(),2,1),
                                    komentari[index].korisnik.uloga=="institucija"?
                                    _buildText(komentari[index].korisnik.ime,12.0+(sirina/250.0).ceil(),2,0):
                                    _buildText(komentari[index].korisnik.ime+" "+komentari[index].korisnik.prezime,12.0+(sirina/250.0).ceil(),2,0),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),

                        Row(
                          children: <Widget>[
                            Container(
                                width:sirina<400? sirina/2.5:sirina/3,
                                margin:sirina>400? EdgeInsets.only(left: 70):EdgeInsets.only(left: 20),
                                child: komentari[index].tekst!=null?_buildText(komentari[index].tekst,12+(sirina/250),2,0):Text("")
                            ),
                            komentari[index].korisnik.id == user.id && komentari[index].oznacenKaoResen==0
                                ? new Container(
                              child: new IconButton(
                                  icon: Icon(Icons.delete,size: 20+(sirina/200),),
                                  onPressed: () {
                                    setState(() {
                                      servis.deleteComment(komentari[index].id, idObjave).then((value) {
                                        Navigator.pop(context);
                                        getComments(idObjave);
                                      });
                                    });
                                  }),
                              //margin: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width/100)*4, 0.0, 0.0, 0.0),
                            )
                                : Container(),
                          ],
                        ),
                        komentari[index].url_slike != null
                            ? Container(
                          padding: EdgeInsets.only(top: 10),
                          width: sirina/2,
                          child: Image.network(api_services.url_za_slike + komentari[index].url_slike
                            ,width: 200.0,height: 150.0,),
                        )
                            : Container(),


                        Container(
                          width: sirina/1.5,
                          margin:sirina>425? EdgeInsets.only(left: 50):EdgeInsets.all(0),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  new Container(
                                    child: new IconButton(
                                      icon: new Icon(Icons.thumb_up,size: 20+(sirina/500),color:komentari[index].korisnikLajkovao==1?Colors.blue:Colors.black,),
                                      onPressed: () {

                                        servis.addLikeComment(user.id, komentari[index].id).then((value) {
                                          Navigator.pop(context);
                                          getComments(idObjave);
                                        });

                                      },
                                    ),
                                    //margin:EdgeInsets.only(left:70.0),
                                    padding: EdgeInsets.only(
                                        left: 10.0),
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
                                      icon: new Icon(Icons.thumb_down,size: 20+(sirina/500),color: komentari[index].korisnikaDislajkovao==1?Colors.red:Colors.black,),
                                      onPressed: () {

                                        servis.addDislikeComment(
                                            user.id, komentari[index].id).then((value) {
                                          Navigator.pop(context);
                                          getComments(idObjave);
                                        });

                                      },
                                    ),
                                    //margin:EdgeInsets.all(20.0),
                                    padding: EdgeInsets.only(
                                        left: 10.0),
                                  ),
                                  new Container(
                                    child: GestureDetector(
                                      child:  Text(komentari[index].brojDislajkova.toString()),
                                    ),
                                    //margin:EdgeInsets.only(left:70.0),
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0, top: 0.0),
                                  ),
                                  new Container(

                                    child: new IconButton(
                                      icon: Icon(Icons.report,size: 20+(sirina/500),color: komentari[index].korisnikReportovao==0?Colors.black:Colors.red,),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        prijavakomentara( komentari[index].id,idObjave);

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
              }),


        );
  }

  void prijavakomentara(int broj, int idObj) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            //  content: Text('Da li ste sigurni da želite da obrišete komentar?'),
            child: Container(
              alignment: Alignment.center,
              width: 400,
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    Container(
                      alignment: Alignment.center,
                      child: _buildText("Odaberite razlog prijave.",18,2,0),
                    ),
                    Container(
                      child: ListView.builder(
                          itemCount: razlozi.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(10.0),
                                //height: visible_comment_section[index] ?  340 : 250,
                                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)
                                ),
                                child:GestureDetector(
                                  child: Container(
                                    child: _buildText(
                                        razlozi[index].razlog,16,2,0
                                    ),
                                  ),
                                  onTap: (){

                                    servis.reportComm(broj,razlozi[index].id,user.id);
                                    Navigator.pop(context);
                                    getComments(idObj);
                                  },
                                )
                            );
                          }),

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
  Widget stampajObjave() {
    if (objave.length == 0) {
      return Container(
        width: sirina/1.5,
        alignment: Alignment.center,
        child: _buildText("Nema problema iz ovih kategorija u gradu/gradovima koje pratite.",14+sirina/250,2,0),
      );
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
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            //  margin:EdgeInsets.symmetric(vertical: 5) ,
            padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                //  borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.white,
              ),

            child:Column(
              children: <Widget>[
                Container(
                  width: sirina,
                 // margin:EdgeInsets.symmetric(vertical: 30,horizontal: 50) ,
                  child: Wrap(
                    direction: Axis.horizontal,

                    children: <Widget>[

                      objave[index].resena==0?Container(

                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: new GestureDetector(
                          child: Icon(Icons.more_vert,size:  20+(sirina/200),),
                          onTap: () {

                            PostavljanjeResenja(objave[index].id, user.id);
                          },
                        ),
                      ):Container(

                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          //padding: EdgeInsets.only(top:10),
                          child: Icon(Icons.done_all, size:   25+(sirina/200),)

                      ),
                     GestureDetector(
                       child:(objave[index].vlasnik.urlSlike != null)?Container(
                         //  margin: EdgeInsets.only(bottom: 10),
                         child:
                         ClipOval(
                           child: Image.network(
                             api_services.url_za_slike+objave[index].vlasnik.urlSlike,

                             height: 50+(sirina/500*7),
                             width: 50+(sirina/500*7),
                             fit: BoxFit.cover,

                           ),
                         ),
                       ):Container(
                           width: 50+(sirina/500*7),
                           height: 50+(sirina/500*7),
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.grey),
                             borderRadius: BorderRadius.all(Radius.circular(50)),
                             color: Colors.white,
                           ),
                           child: Icon(Icons.person,color:  Color.fromRGBO(
                               59, 227, 168,1),size: 30+(sirina/500*5),)
                       ),
                       onTap: (){
                         setState(() {
                           html.window.sessionStorage['Idkorisnika']=objave[index].vlasnik.id.toString();
                           AppBarPageState.trenIndex=4;
                         });
                         if(html.window.sessionStorage['Idkorisnika']!="")
                         {
                           Navigator.push(context, MaterialPageRoute(
                               builder: (context) =>
                                   AppBarPage()
                           )
                           );
                         }
                       },

                     ),
                        SizedBox(
                          width: 30,
                        ),


                        GestureDetector(
                         // padding: EdgeInsets.only(left: 10),
                          child: Wrap(
                            direction: Axis.vertical,
                           children: <Widget>[

                             Container(
                               child: objave[index].vlasnik != null?
                               _buildText("@"+objave[index].vlasnik.username,15+(sirina/250),2,1):Text(""),
                             ),

                                 Container(
                                       child: objave[index].vlasnik != null
                                           ? _buildText(objave[index].vlasnik.ime + " " +
                                           objave[index].vlasnik.prezime,14+(sirina/250),2,0
                                       )
                                           : Text("Null je vlasnik"),
                                     ),

                             Container(
                               child:_buildText(objave[index].vreme,14+(sirina/250),2,0),
                             ),

                           ],
                          ),
                          onTap: (){
                            setState(() {
                              html.window.sessionStorage['Idkorisnika']=objave[index].vlasnik.id.toString();
                              AppBarPageState.trenIndex=4;
                            });
                            if(html.window.sessionStorage['Idkorisnika']!="")
                            {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      AppBarPage()
                              )
                              );
                            }
                          },
                        ),



                    ],
                  ),
                ),

                    Container(
                      margin: sirina>600?EdgeInsets.only(left: 100):EdgeInsets.all(0),
                      width: sirina/1.2,
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

                            child: Wrap(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Container(
                                  padding:
                                  EdgeInsets.only( right: 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      new Container(
                                        child: new IconButton(
                                          icon: Icon(Icons.thumb_up,size:  20+(sirina/500),
                                            color: objave[index].korisnikLajkovao == 1
                                                ? Colors.blue
                                                : Colors.black,),

                                          onPressed: () {
                                            servis.addLike(user.id, objave[index].id).then((response) {
                                              dajObjave();
                                            });

                                            stampajObjave();
                                          },
                                        ),
                                        //margin:EdgeInsets.only(left:70.0),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                            width:10,
                                            child: Text(objave[index].brojLajkova.toString())
                                        ),onTap: (){
                                        getLikes(objave[index].id);
                                      },
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(

                                  padding:
                                  EdgeInsets.only( right: 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      new Container(
                                        child: new IconButton(
                                          icon: Icon(Icons.thumb_down,size:  20+(sirina/500),
                                            color: objave[index].korisnikaDislajkovao == 1
                                                ? Colors.red
                                                : Colors.black,),

                                          onPressed: () {

                                            servis.addDislike(user.id, objave[index].id).then((response) {
                                              dajObjave();
                                            });
                                            stampajObjave();

                                          },
                                        ),
                                        //margin:EdgeInsets.only(left:70.0),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                            width: 10,
                                            child: Text(objave[index].brojDislajkova.toString())),
                                        onTap: (){
                                          getDislike(objave[index].id);
                                        },

                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                 margin: EdgeInsets.only(
                                      left: 10.0, top: 15.0, right: 5.0, bottom: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      new Container(
                                        child: new GestureDetector(
                                          child: Icon(Icons.comment,size:  20+(sirina/500),
                                            color: Colors.black,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              getComments(objave[index].id);

                                            });
                                          },
                                        ),
                                      ),

                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(objave[index].brojKomentara.toString()),
                                    ],
                                  ),
                                ),
                                new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.report,size:  20+(sirina/500),
                                      color: objave[index].korisnikReportovao == 1
                                          ? Colors.red
                                          : Colors.black,),

                                    onPressed: () {
                                   // getreport();
                                      prijavaObjave(objave[index].id);

                                    },
                                  ),

                                  //margin:EdgeInsets.only(left:70.0),
                                ),
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



int id=1;
  @override
  Widget build(BuildContext context) {
    if (objave.length == 0 && id==1) {
      dajObjave();setState(() {
        id=0;
      });

    }
    if (kategorije.length == 0) {
      dajKategorije(user.id);

    }


    sirina=MediaQuery.of(context).size.width;
    return new Scaffold(
     body: new Scrollbar(
          child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey[150],
                child: Container(
                  width: sirina,
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                         Container(
                           alignment: Alignment.center,
                           child: Wrap(
                             direction: Axis.horizontal,
                             children: <Widget>[
                               Column(
                                 children: <Widget>[
                                   Container(
                                     padding:EdgeInsets.only(top: 20),
                                     child: _buildText(
                                         "Odaberite kategoriju za prikaz objava:",16+(sirina/250),2,1
                                     ),
                                   ),
                                   Container(
                                       padding:EdgeInsets.only(top: 20,bottom: 20),
                                       child: prikazKategorija()
                                   ),

                                 ],
                               ),SizedBox(
                                 width: 30,
                               ),
                               Column(
                                 children: <Widget>[
                                   Container(
                                     padding:EdgeInsets.only(top: 20),
                                     child: _buildText(
                                         "Status objave:",16+(sirina/250),2,1
                                     ),
                                   ),
                                   Container(
                                       padding:EdgeInsets.only(top: 20,bottom: 20),
                                       child: prikazStatusa()
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         ),
                          Container(
                            width: sirina/1.3,
                              child: stampajObjave()
                          )
                        ],
                      )

                  )

              )
          ),

     ),

      );
  }
  Widget prikazKategorija()
{
    return         Container(
      width: 400,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color.fromRGBO(
              59, 227, 168,1),
          borderRadius:BorderRadius.all(Radius.circular(50))
      ),
      child: DropdownButtonHideUnderline(
        child: new Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color.fromRGBO(
                59, 227, 168,1),

          ),
          child: new DropdownButton(
              items: buildDropdownMenuItemsKategorije(kategorije),
              value: selectedkat,
              onChanged: (value) {
                setState(() {
                  selectedkat = value;
                  if(selectedsat.id==1)
                        {
                          getreseneObjaveKategorije(selectedkat.id, user.id);
                        }
                      else{
                         getnereseneObjaveKategorije(selectedkat.id, user.id);
                      }
                  stampajObjave();
                });
              }),
        ),
      ),
    );
  }



  List<DropdownMenuItem<Kategorija>> buildDropdownMenuItemsKategorije(List _kategorije) {
    List<DropdownMenuItem<Kategorija>> items = List();

    for (Kategorija kat in _kategorije) {
      items.add(
        DropdownMenuItem(
          value: kat,
          child:_buildText(kat.naziv,15+(sirina/500),0,1),
        ),
      );
    }
    return items;
  }



  Widget prikazStatusa()
 {
    return         Container(
      width: 250,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color.fromRGBO(
              59, 227, 168,1),
          borderRadius:BorderRadius.all(Radius.circular(50))
      ),
      child: DropdownButtonHideUnderline(
        child: new Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color.fromRGBO(
                59, 227, 168,1),

          ),
          child: new DropdownButton(
              items: buildDropdownMenuItemsStatus(statusobj),
              value: selectedsat,
              onChanged: (value) {
                setState(() {
                  selectedsat = value;
                  if(selectedsat.id==1)
                  {
                    getreseneObjaveKategorije(selectedkat.id, user.id);
                  }
                  else{
                    getnereseneObjaveKategorije(selectedkat.id, user.id);
                  }
                  stampajObjave();
                });
              }),
        ),
      ),
    );
  }
  


  List<DropdownMenuItem<Pomocna>> buildDropdownMenuItemsStatus(List _kategorije) {
    List<DropdownMenuItem<Pomocna>> items = List();

    for (Pomocna kat in _kategorije) {
      items.add(
        DropdownMenuItem(
          value: kat,
          child:_buildText(kat.ime,15 +(sirina/500),0,1),
        ),
      );
    }
    return items;
  }

  List<RazlogReporta> razlozi=List<RazlogReporta>();
  void dajListuzaprijavu(){
    servis.dajRazlogePrijave().then(
          (response) {
        Iterable list = json.decode(response.body);
        List<RazlogReporta> korisniciList = List<RazlogReporta>();
        korisniciList = list.map((model) => RazlogReporta.fromObject(model)).toList();
        setState(
              () {
            razlozi = korisniciList;
            //objave = objave.reversed.toList();
          },
        );

      },
    );
  }



  void prijavaObjave(int idobj) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            //  content: Text('Da li ste sigurni da želite da obrišete komentar?'),
            child: Container(
              alignment: Alignment.center,
              width: 400,
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    Container(
                      alignment: Alignment.center,
                      child: _buildText("Odaberite razlog prijave.",18,2,0),
                    ),
                    Container(
                      child: ListView.builder(
                          itemCount: razlozi.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(10.0),
                                //height: visible_comment_section[index] ?  340 : 250,
                                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)
                                ),
                                child:GestureDetector(
                                  child: Container(
                                    child: _buildText(
                                        razlozi[index].razlog,16,2,0
                                    ),
                                  ),
                                  onTap: (){
                                    servis.reportPost(idobj,razlozi[index].id,user.id).then((value){
                                      setState(() {
                                        dajObjave();
                                      });
                                    }


                                    );

                                    stampajObjave();
                                    Navigator.pop(context);

                                  },
                                )
                            );
                          }),

                    ),
                    RaisedButton(
                      child: _buildText("Zatvori",16,2,0),
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


  Widget _buildText(String str,double size,int boja,int bold )
  {
    return Container(
        child:Text(str,style:gf.GoogleFonts.ubuntu(color:boja==1?Color.fromRGBO(42, 184, 115, 1):boja==2?Colors.black:Colors.white,fontSize: size,fontWeight:bold==1?FontWeight.bold:FontWeight.normal),)
    );

  }
}

class Pomocna
{
  int id;
  String ime;
  Pomocna(int id,String ime)
  {
    this.id=id;
    this.ime=ime;

  }
}