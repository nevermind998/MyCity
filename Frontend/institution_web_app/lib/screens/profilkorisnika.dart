import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:webApp/models/Grad.dart';
import 'package:webApp/models/Institucija.dart';
import 'package:webApp/models/Kategorije.dart';
import 'package:webApp/models/Komentar.dart';
import 'package:webApp/models/RazlogReporta.dart';
import '../models/Korisnik.dart';
import '../models/Objava.dart';
import 'dart:html' as html;
import '../services/api_services.dart';
import 'package:google_fonts/google_fonts.dart' as gf;

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

  List<Korisnik>korisnicii = List<Korisnik>();

  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();
  double visina = 40;
  double sirina = 250;
  double sirina1;
  String token = "";

  getToken() async {
    String _token = html.window.sessionStorage['token'];
    Map<String, dynamic> jsonObject = json.decode(
        html.window.sessionStorage['userInfo']);
    Korisnik extractedUser = new Korisnik();
    extractedUser = Korisnik.fromObject(jsonObject);
    setState(() {
      token = _token;
      logovan_user = extractedUser;
    });
  }

  bool aktivna_biografija = false;
  TextEditingController _resenaObjavaController = new TextEditingController();
  TextEditingController _commentController = new TextEditingController();
  bool azuriranje_aktivno = false;
  @override
  Korisnik logovan_user;
  Korisnik user;
  api_services servis = api_services();
  List<Objava> objave = List<Objava>();
  List<Grad> gradovi_korisnika = List<Grad>();
  int pom;


  void initState() {
    // TODO: implement initState
    if (html.window.sessionStorage.length < 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
    getToken();
    if (html.window.sessionStorage['Idkorisnika'].length != 0) {
      pom = int.parse(html.window.sessionStorage['Idkorisnika']);
      getKorisnikaaa(pom);
    }
    dajListuzaprijavu();
    super.initState();
  }

  void getKorisnikaaa(int id) {
    servis.fetchKorisnik(id).then(
          (response) {
        Map<String, dynamic> jsonObject = json.decode(response.body);
        Korisnik s = new Korisnik();
        s = Korisnik.fromObject(jsonObject);
        setState(() {

          user = s;
        });
      },
    );
  }

  void getObjave() {
    servis.fetchObjaveByIdKorisnika(user.id,logovan_user.id).then(
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

  void getObjave1() {

    servis.fetchObjaveGradaInstitucijeKojejesuResene(user.id,logovan_user.id ).then(
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


  Widget contextObjave(int index) {
    if (objave[index].tekstualna_objava != null) {
      return Container(
        width: sirina1/1.4,
        padding: EdgeInsets.symmetric(vertical: 10),
        //alignment: Alignment.center,
        child: _buildText1(objave[index].tekstualna_objava.tekst,15+sirina1/250,2,0),

      );
    } else {
      return new Container(
        //  margin:EdgeInsets.symmetric(horizontal: 10) ,
        width: sirina1/1.3,

        child: Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            objave[index].slika.opis_slike != null?
            Container(
                width: sirina1/1.4,
                padding: EdgeInsets.symmetric(vertical: 10),

                child:_buildText1(objave[index].slika.opis_slike,15+sirina1/250,2,0)
            ):Container(),

            Container(
              alignment: Alignment.center,
              padding: sirina1>500? sirina1>1000?EdgeInsets.symmetric(horizontal: 100):EdgeInsets.symmetric(horizontal: 50):EdgeInsets.all(0),
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

  bool zasliku=false;
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
          _showDialog(idObjave, idInstitucije);
        });
      }


  }


String str="";

  void _showDialog(int idObjave, int idInstitucije) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Označavanje objave kao rešene'),
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
                        child: _buildText1("Slika je uspešno učitana.", 16, 1, 0),
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
                child:_buildText1("Dodaj sliku",16,2,0)
            ),
            SizedBox(
              width: 15,
            ),
            RaisedButton(
              child: _buildText1("Odustani",16,2,0),
              onPressed: () {
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
              child: _buildText1("Potvrdi",16,2,0),
              onPressed: () {
                //servis.uploadImageComment(file, _resenaObjavaController.text, idInstitucije, idObjave, 1, 1);

                //servis.setComment(_resenaObjavaController.text, idInstitucije, idObjave, 0, 1);

                servis.oznaciKaoResen(idObjave, idInstitucije);
                str!=""? servis.slikaKomentara(logovan_user.id, idObjave,str,_resenaObjavaController.text):
                servis.setComment(_resenaObjavaController.text, logovan_user.id, idObjave, 0, 1);

                //servis.slikaKomentara(idInstitucije, idObjave, slika64);


                setState(() {
                  _resenaObjavaController.text = "";
                  AppBarPageState.trenIndex=2;

                });
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        AppBarPage()
                )
                );
              },
            ),
          ],
        );
      },
    );
  }


  void getDislike(int idOvjave) {
    servis.fetchDislikes(idOvjave).then(
          (response) {
        Iterable list = json.decode(response.body);
        List<Korisnik> korisniciList = List<Korisnik>();
        korisniciList =
            list.map((model) => Korisnik.fromObject(model)).toList();
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


  void getLikes(int idObjave) {
    servis.fetchLikes(idObjave).then(
          (response) {
        Iterable list = json.decode(response.body);
        List<Korisnik> korisniciList = List<Korisnik>();
        korisniciList =
            list.map((model) => Korisnik.fromObject(model)).toList();
        setState(
              () {
            korisnicii = korisniciList;
            //objave = objave.reversed.toList();
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
            //  content: Text('Da li ste sigurni da želite da obrišete komentar?'),
            child: Container(
              alignment: Alignment.center,
              width: 365+sirina1/400*10,
              height: 300+sirina1/400*10,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    broj == 0 ? Container(
                      alignment: Alignment.center,
                      child: _buildText1("Korisnici koji su dislakjovali objavu",16+sirina1/250,2,1),
                    ) : Container(
                      alignment: Alignment.center,
                      child: _buildText1(
                        "Korisnici koji su lakjovali objavu",16+sirina1/250,2,1),
                    ),
                    korisnicii.length!=0?
                    Container(
                      child: ListView.builder(
                          itemCount: korisnicii.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(10.0),
                                //height: visible_comment_section[index] ?  340 : 250,
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 0.0, 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)
                                ),
                                child: Row(children: <Widget>[
                                  new Container(
                                    child: new Icon(Icons.account_circle),
                                    margin: EdgeInsets.fromLTRB(
                                        0.0, 0.0, 10.0, 0.0),
                                  ),

                                  korisnicii[index].uloga=="institucija"?
                                  Container(child: _buildText1(korisnicii[index].ime ,14+sirina/250,2,0)):
                                  Container(child: _buildText1(korisnicii[index].ime + ' ' + korisnicii[index].prezime,14+sirina/250,2,0))
                                ],)
                            );
                          }),

                    ):Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child:broj==0?_buildText1("Nema dislajkovao",14+sirina1/250,2,0):
                      _buildText1("Nema lajkovao",14+sirina1/250,2,0)
                    ),
                    RaisedButton(
                      child: Text("Zatvori"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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

    servis.fetchComments(idObjave,logovan_user.id).then(
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

  FocusNode _textNode1 = new FocusNode();
  void PrikazKomentaraUProzoru( int broj)
  {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              alignment: Alignment.center,
              width: sirina1/2,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    Container(

                      width: sirina1/2,
                      alignment: Alignment.center,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            width: sirina1/2.8,
                            child: TextFormField(
                              decoration: InputDecoration(hintText: 'Unesite komentar...'),
                              controller: _commentController,
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: RaisedButton(
                              child: _buildText1("Komentariši",12+sirina1/250,2,0),
                              onPressed:(){
                                if(_commentController.text!="")
                                {
                                  servis.setComment(_commentController.text, logovan_user.id, broj, 0,0).then((val){
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
                        child: _buildText1("Zatvori",14+sirina1/250,2,0),
                        onPressed:(){
                            if (user.uloga != "institucija") {
                                  getObjave();
                            }
                            else {
                                  getObjave1();
                            }

                          printObjave();
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
  Widget PrikazSadrzajakKomentara(int idObjave)
  {

    if(komentari.length==0)
    {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child:_buildText1("Nema komentara",16+sirina1/250,2,0)

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
                  width: sirina1/1.3,
                  alignment: Alignment.center,


                  child: Container(
                    width: sirina1/1.5,
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

                          width: sirina1/1.5,
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

                                    height: 50+(sirina1/500*7),
                                    width: 50+(sirina1/500*7),
                                    fit: BoxFit.cover,

                                  ),
                                )
                                    : Container(
                                    width: 50+(sirina1/500*7),
                                    height: 50+(sirina1/500*7),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.person, color: Color.fromRGBO(
                                        59, 227, 168,1), size: 30+(sirina1/500*5),)
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
                                    _buildText1("@"+komentari[index].korisnik.username,13.0+(sirina1/250.0).ceil(),2,1),
                                    komentari[index].korisnik.uloga=="institucija"?
                                    _buildText1(komentari[index].korisnik.ime,12.0+(sirina1/250.0).ceil(),2,0):
                                    _buildText1(komentari[index].korisnik.ime+" "+komentari[index].korisnik.prezime,12.0+(sirina1/250.0).ceil(),2,0),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),

                          Row(
                          children: <Widget>[
                            Container(
                                width:sirina1<400? sirina1/2.5:sirina1/3,
                                margin:sirina1>400? EdgeInsets.only(left: 70):EdgeInsets.only(left: 20),
                                child: komentari[index].tekst!=null?_buildText1(komentari[index].tekst,12+(sirina1/250),2,0):Text("")
                            ),
                            komentari[index].korisnik.id == logovan_user.id && komentari[index].oznacenKaoResen==0
                                ? new Container(
                              child: new IconButton(
                                  icon: Icon(Icons.delete,size: 20+(sirina1/200),),
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
                          width: sirina1/2,
                          padding: EdgeInsets.only(top: 10),
                          child: Image.network(api_services.url_za_slike + komentari[index].url_slike
                            ,width: 200.0,height: 150.0,),
                        )
                            : Container(),


                        Container(
                          width: sirina1/1.5,
                          margin:sirina1>425? EdgeInsets.only(left: 50):EdgeInsets.all(0),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  new Container(
                                    child: new IconButton(
                                      icon: new Icon(Icons.thumb_up,size: 20+(sirina1/500),color:komentari[index].korisnikLajkovao==1?Colors.blue:Colors.black,),
                                      onPressed: () {

                                        servis.addLikeComment(logovan_user.id, komentari[index].id).then((value) {
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
                                      icon: new Icon(Icons.thumb_down,size: 20+(sirina1/500),color: komentari[index].korisnikaDislajkovao==1?Colors.red:Colors.black,),
                                      onPressed: () {

                                        servis.addDislikeComment(
                                            logovan_user.id, komentari[index].id).then((value) {
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
                                      icon: Icon(Icons.report,size: 20+(sirina1/500),color: komentari[index].korisnikReportovao==0?Colors.black:Colors.red,),
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
  List<RazlogReporta> razlozi=List<RazlogReporta>();



  void prijavakomentara(int broj,int idObjave) {

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
                      child: _buildText1("Odaberite razlog prijave.",18,2,0),
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
                                    child: _buildText1(
                                        razlozi[index].razlog,16,2,0
                                    ),
                                  ),
                                  onTap: (){

                                    servis.reportComm(broj,razlozi[index].id,logovan_user.id);
                                    Navigator.pop(context);
                                    getComments(idObjave);
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

  int idobjave = 0;
  List<bool> cekirani = List<bool>();



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





  Widget printObjave() {
    if (objave.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: _buildText1("Nema objava",14+sirina1/250,2,0),);
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: objave.length,
      itemBuilder: (context, index) {
        idobjave = index;
        cekirani.add(false);

        return Container(
          margin: EdgeInsets.only(bottom: 10),
          alignment: Alignment.center,
          //  margin:EdgeInsets.symmetric(vertical: 5) ,
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            //  borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.white,
          ),

          child: Column(
            children: <Widget>[
              Container(
                width: sirina1 ,

                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    objave[index].resena!=0?Container(

                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        //padding: EdgeInsets.only(top:10),
                        child: Icon(Icons.done_all, size:   25+(sirina1/200),)

                    ):Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: new GestureDetector(
                          child: Icon(Icons.more_vert, size:  25+(sirina1/200),),
                          onTap: () {

                            _showDialog(
                                objave[index].id, logovan_user.id);
                          },
                        ),
                      ),

                    (objave[index].vlasnik.urlSlike != null) ? Container(

                      child: ClipOval(
                        child: Image.network(
                          api_services.url_za_slike +
                              objave[index].vlasnik.urlSlike,
                          height: 50+(sirina1/500*7),
                          width: 50+(sirina1/500*7),
                          fit: BoxFit.cover,
                        ),
                      ),

                    ) : Container(
                        width: 50+(sirina1/500*7),
                        height: 50+(sirina1/500*7),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.person, color: Colors.white, size:30 +(sirina1/500*5),)
                    ),
                    SizedBox(
                      width: 30,
                    ),

                    Container(
                      // padding: EdgeInsets.only(left: 10),
                      child: Wrap(
                        direction: Axis.vertical,
                        children: <Widget>[

                          Container(
                            child: objave[index].vlasnik != null ?
                            Text("@" + objave[index].vlasnik.username,
                              style: TextStyle(fontSize:  15+(sirina1/250),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),) : Text(""),
                          ),

                          Container(
                            child: objave[index].vlasnik != null
                                ? Text(objave[index].vlasnik.ime + " " +
                                objave[index].vlasnik.prezime
                              , style: TextStyle(fontSize:  13+(sirina1/250),),
                            )
                                : Text("Null je vlasnik"),
                          ),

                          Container(
                              child: Text(objave[index].vreme
                                , style: TextStyle(fontSize:  13+(sirina1/250),),
                              )
                          ),

                        ],
                      ),
                    ),


                  ],
                ),
              ),

              Container(
                margin: sirina1>600?EdgeInsets.only(left: 100):EdgeInsets.all(0),
                width: sirina1/1.2,
                child: Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: contextObjave(index)
                    ),
                    Container(

                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(

                            child: Row(
                              children: <Widget>[
                                new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.thumb_up,size: 20+(sirina1/500),
                                      color: objave[index].korisnikLajkovao == 1
                                          ? Colors.blue
                                          : Colors.black,),

                                    onPressed: () {
                                servis.addLike(logovan_user.id, objave[index].id).then((response) {
                                  user.uloga!="institucija"?
                                  getObjave():getObjave1();
                                });
                                      printObjave();
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
                                    icon: Icon(Icons.thumb_down,size: 20+(sirina1/500),
                                      color: objave[index].korisnikaDislajkovao == 1
                                          ? Colors.red
                                          : Colors.black,),

                                    onPressed: () {

                                      servis.addDislike(logovan_user.id, objave[index].id).then((response) {
                                        user.uloga!="institucija"?
                                        getObjave():getObjave1();
                                      });
                                      printObjave();

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
                                    child: Icon(Icons.comment,size: 20+(sirina1/500),
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
                              icon: Icon(Icons.report,size: 20+(sirina1/500),
                                color: objave[index].korisnikReportovao == 1
                                    ? Colors.red
                                    : Colors.black,),

                              onPressed: () {
                                if(objave[index].resena==0)
                                  {
                                    prijavaObjave(objave[index].id);
                                  }
                                else{
                                  _showDialogAdmin("Ne možete da prijavite objavu","Objava je označena kao rešena");
                                }

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

  void _showDialogAdmin(String str1,String str2) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: _buildText1(str1, 16, 2, 0),
          content: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                _buildText1(str2, 16, 2, 0),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child:_buildText1("Zatvori", 16, 2, 0),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Widget build(BuildContext context) {
    if (user == null) return CircularProgressIndicator();

    if (objave.length == 0) {
      if (user.uloga != "institucija") {
        getObjave();
      }
      else {
        getObjave1();
      }
    }


    sirina1 = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      body: Container(
        width: sirina1,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(

                        decoration: BoxDecoration(
                            color: Color.fromRGBO(
                                59, 227, 168, 1),
                            borderRadius: BorderRadius.all(Radius.circular(50))
                        ),

                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(bottom: 30),
                        alignment: Alignment.center,
                        width: sirina1 <500? sirina1 / 1.2:sirina1<1000?sirina1/1.5:sirina1/ 1.8,
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: <Widget>[

                            Container(

                              child: user.urlSlike != null ? Container(
                                  child: ClipOval(
                                    child: Image.network(
                                      api_services.url_za_slike + user.urlSlike,
                                      width: 120, height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ) : Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100)),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.person, color: Color.fromRGBO(
                                      59, 227, 168, 1), size: 70,)
                              ),

                            ),

                            Container(
                              margin: EdgeInsets.only(left: sirina1/15),
                              child: Wrap(
                                direction: Axis.vertical,
                                children: <Widget>[

                                  Container(

                                    child: _buildText1(
                                        "@" + user.username,  16+sirina1/250, 0, 1),
                                  ),

                                  user.uloga == "institucija" ? Container(
                                    child: _buildText1(user.ime, 16+sirina1/250, 0, 0),
                                  ) : Container(
                                    child: _buildText1(
                                        user.ime + " " + user.prezime,16+sirina1/250, 0,
                                        0),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(right: 50),
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      children: <Widget>[

                                        user.email != null ? Container(
                                          child: _buildText1(
                                              user.email, 14+sirina1/250, 0, 0),

                                        ) : Container(),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 20),
                                              child: user.uloga == "institucija"
                                                  ? _buildText1(
                                                  "O Instituciji:",  16+sirina1/250, 0, 1)
                                                  : _buildText1(
                                                  "O Korisniku:",  16+sirina1/250, 0, 1),
                                            ),
                                            Container(
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(30.0)),

                                                color: Colors.white,
                                                child: _buildText1(
                                                    "Više",  12+sirina1/250, 1, 1),
                                                onPressed: () {
                                                  setState(() {
                                                    aktivna_biografija = true;
                                                  });
                                                },
                                              ),
                                            ),

                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),


                      aktivna_biografija == true ? Container(

                        child: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            user.uloga == "institucija" ? Container(
                                width: sirina1 / 1.8,
                                margin: EdgeInsets.only(top: 10),
                                child: _buildText1("O Instituciji:",  16+sirina1/250, 2, 1)
                            ) : Container(
                              margin: EdgeInsets.only(top: 10),
                              width: sirina1 / 1.8,
                              child: _buildText1("O Korisniku:",  16+sirina1/250, 2, 1),
                            )

                            ,

                            Container(
                              width: sirina1 / 1.8,
                              margin: EdgeInsets.only(top: 10),
                              child: user.biografija != null ? _buildText1(
                                  user.biografija,  16+sirina1/250, 2, 0) :
                              _buildText1(
                                  "Trenutno nemamo podataka.",  16+sirina1/250, 2, 0),

                            ),


                            Container(
                                width: sirina1 / 1.8,

                                margin: EdgeInsets.only(top: 10),
                                child: _buildText1(
                                    "Gradovi koje prati:",  16+sirina1/250, 2, 1)),

                            Container(
                              width: sirina1 / 1.8,
                              margin: EdgeInsets.only(top: 10),
                              child: proba2(),
                            ),


                            user.uloga == "institucija"
                                ? Container(
                                width: sirina1 / 1.8,
                                margin: EdgeInsets.only(top: 10),
                                child: _buildText1(
                                    "Kategorije koje prati:",  16+sirina1/250, 2, 1))
                                : Container(),


                            user.uloga == "institucija" ? Container(
                              width: sirina1 / 1.8,
                              margin: EdgeInsets.only(top: 10),
                              child: proba()
                            ) : Container(),


                            Container(
                              padding: EdgeInsets.only(bottom: 10,top: 10),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),

                                color: Color.fromRGBO(
                                    59, 227, 168, 1),
                                child: _buildText1("Zatvori",  12+sirina1/250, 0, 1),
                                onPressed: () {
                                  setState(() {
                                    aktivna_biografija = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                    ],
                  ),
          user.uloga == "institucija" ?Container(
            width: sirina1 / 1.5,
            alignment: Alignment.center,
            child: _buildText1("Objave na ovoj strani predstavljaju probleme koje je institucija "+user.ime+" rešila.", 14+(sirina1/250), 2, 0),
          ):Container(),

                  SizedBox(height: 10,),
                  Container(
                    width: sirina1 / 1.3,

                    child:  printObjave()

                  ),

                ],
              ),

            ),
          ),
        ),
      ),
    );
  }


  Widget _buildText1(String str, double size, int boja, int bold) {
    return Container(
        child: Text(str, style: gf.GoogleFonts.ubuntu(
            color: boja == 1 ? Color.fromRGBO(42, 184, 115, 1) : boja == 2
                ? Colors.black
                : Colors.white,
            fontSize: size,
            fontWeight: bold == 1 ? FontWeight.bold : FontWeight.normal),)
    );
  }


  List<Kategorija>izabrane_kategorije1 = List<Kategorija>();
  List<Grad>gradovizakorisnika1 = List<Grad>();

  int pomm=1;
  Widget proba()
  {
    String str="";

    if (izabrane_kategorije1.length == 0 && pomm==1) {
      dajKategorijeInstitucije();
      setState(() {
        pomm=0;
      });

    }
    for(int i =0;i<izabrane_kategorije1.length;i++)
      {
        if(i<izabrane_kategorije1.length-1)
        str=str+izabrane_kategorije1[i].naziv+", ";
        else{
          str=str+izabrane_kategorije1[i].naziv+".";
        }
      }

    return Container(
      child: _buildText1(str,18,2, 0),
    );
  }

  void dajKategorijeInstitucije() {
    servis.fetchDajKategorijeinstitucije(user.id).then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        izabrane_kategorije1=list.map((model) => Kategorija.fromObject(model)).toList();

      });
    });
  }
  Widget proba2()
  {
    String str="";

    for(int i =0;i<user.gradovi.length;i++)
    {
      if(i<user.gradovi.length-1)
        str=str+user.gradovi[i].naziv_grada_lat+", ";
      else{
        str=str+user.gradovi[i].naziv_grada_lat+".";
      }

    }

    return Container(
      child: _buildText1(str,18,2, 0),
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
                      child: Text("Odaberite razlog prijave.",style: TextStyle(
                          fontSize: 20,fontWeight: FontWeight.bold
                      ),),
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
                                    child: Text(
                                        razlozi[index].razlog
                                    ),
                                  ),
                                  onTap: (){

                                    servis.reportPost(idobj,razlozi[index].id,logovan_user.id).then((value) {
                                      setState(() {
                                        user.uloga!="institucija"?
                                        getObjave():getObjave1();
                                      });
                                    });
                                    printObjave();
                                    Navigator.pop(context);
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





}

