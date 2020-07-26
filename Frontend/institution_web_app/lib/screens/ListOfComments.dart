import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:webApp/models/RazlogReporta.dart';
import '../models/Komentar.dart';
import '../models/Korisnik.dart';
import '../services/api_services.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'dart:html' as html;

import 'appBarPage.dart';
import 'loginPage.dart';
class ListOfComments extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ListOfCommentsState();
  }
}

class _ListOfCommentsState extends State<ListOfComments> {
  int idObjave;
  int idKorisnika;
  List<Komentar> korisnici=List<Komentar>();
  List<Korisnik> korisnicii;
  Korisnik logovan_korisnik;
  Future<File> file_comment;
  File slika;
  String str="";
  int poslata_slika;
  TextEditingController _commentController = TextEditingController();
  bool checked_resenje=false;



  api_services servis = api_services();
  void _getUser() async {
    logovan_korisnik = await api_services().getUserSession();
  }

String idobjavee;
String idkorisnikaa;
String resenaobj;
int resenaobjava;
  @override
  void initState() {
    if(html.window.sessionStorage.length<1)
    {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }

    // TODO: implement initState
    super.initState();
    _getUser();

    setState(() {
      idobjavee=html.window.sessionStorage['IDObjave'];
      idObjave=int.parse(idobjavee);
      idkorisnikaa=html.window.sessionStorage['IDKorisnika'];
      idKorisnika=int.parse(idkorisnikaa);
      resenaobj=html.window.sessionStorage['ObjavaResena'];
      resenaobjava=int.parse(resenaobj);
      html.window.sessionStorage['IDKorisnika']="";
      html.window.sessionStorage['IDObjave']+"";
    });
    getreport();
  }

  void getComments() {

    servis.fetchComments(this.idObjave,idKorisnika).then(
          (response) {
print(idObjave);

        Iterable list = json.decode(response.body);
        List<Komentar> korisniciList = List<Komentar>();
        korisniciList =
            list.map((model) => Komentar.fromObject(model)).toList();
        setState(
              () {
            korisnici = korisniciList;

              },
        );
      },
    );
  }
List<bool>rep=List<bool>();
  void _showDialog(int idkom) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: _buildText('Brisanje komentara',18,2,0),
            content:
            _buildText('Da li ste sigurni da želite da obrišete komentar?',16,2,0),
            actions: <Widget>[
              FlatButton(
                child: _buildText('Zatvori',16,2,0),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: _buildText('Obriši',16,2,0),
                onPressed: () {

                  setState(() {
                   servis.deleteComment(idkom, idObjave);
                   getComments();
                   printKorisnici();

                   aktivni_komentari=false;
                   html.window.sessionStorage['IDObjave']=idobjavee;
                   html.window.sessionStorage['IDKorisnika']=idkorisnikaa;
                   AppBarPageState.trenIndex=3;
                   Navigator.push(context, MaterialPageRoute(
                       builder: (context) =>
                           AppBarPage()
                   )
                   );
                  });
                },
              ),
            ],
          );
        });
  }
List<bool> lajkom=List<bool>();
  List<bool> dilajkom=List<bool>();
  Color bojaZavisnaOdResenosti(int index){
    if(index == 1){
      return Color.fromRGBO(120, 249, 133, 0.4);
    }else{
      return Colors.white12;
    }
  }

  Widget printKorisnici() {

    if (korisnici.length==0) {
      return Container(
        alignment: Alignment.center,
          child: _buildText("Nema komentara",15.0+(sirina/250.0).ceil(),2,1));
    } else
      return Expanded(
          child: ListView.builder(
              itemCount: korisnici.length,
              itemBuilder: (context, index) {

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
                            color: bojaZavisnaOdResenosti(korisnici[index].oznacenKaoResen)  /*bojaZavisnaOdResenosti(korisnici[index].oznacenKaoResen)*/
                        ),
                        child: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[

                            Container(

                              width: sirina/1.5,
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  korisnici[index].korisnik.id == logovan_korisnik.id && korisnici[index].oznacenKaoResen==0 && resenaobjava==0
                                      ? new Container(

                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: new IconButton(
                                        icon: Icon(Icons.delete,size: 20+(sirina/250),),
                                        onPressed: () {
                                          _showDialog(korisnici[index].id);
                                        }),
                                    //margin: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width/100)*4, 0.0, 0.0, 0.0),
                                  )
                                      : Container(),


                                    (korisnici[index].korisnik.urlSlike!=null)?
                                    ClipOval(
                                      child: Image.network(
                                        api_services.url_za_slike+korisnici[index].korisnik.urlSlike,

                                        height: 40+(sirina/500*7),
                                        width: 40+(sirina/500*7),
                                        fit: BoxFit.cover,

                                      ),
                                    )
                                   :  Container(
                                        width: 40+(sirina/500*7),
                                        height: 40+(sirina/500*7),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          Icons.person, color: Color.fromRGBO(
                                            59, 227, 168,1), size: 30+(sirina/500*5),)
                                    ),


                                 Container(
                                   margin: EdgeInsets.only(left: 15,top: 10),
                                   child: Wrap(
                                     direction: Axis.vertical,
                                     children: <Widget>[
                                      _buildText("@"+korisnici[index].korisnik.username,13.0+(sirina/250.0).ceil(),2,1),
                                       korisnici[index].korisnik.uloga=="institucija"?
                                       _buildText(korisnici[index].korisnik.ime,12.0+(sirina/250.0).ceil(),2,0):
                                      _buildText(korisnici[index].korisnik.ime+" "+korisnici[index].korisnik.prezime,12.0+(sirina/250.0).ceil(),2,0),
                                     ],
                                   ),
                                 ),

                                ],
                              ),
                            ),

                            Container(
                              width:sirina<400? sirina/2:sirina/2.2,
                                margin:sirina>400? EdgeInsets.only(left: 77):EdgeInsets.only(left: 20),
                                child: korisnici[index].tekst!=null?_buildText(korisnici[index].tekst,12+(sirina/250),2,0):Text("")
                            ),
                            korisnici[index].url_slike != null
                                ? Container(
                                    width: sirina/2,
                                  child: Image.network(api_services.url_za_slike + korisnici[index].url_slike
                                                    ,width: 200.0,height: 150.0,),
                                )
                                : Container(),


                           Container(
                width: sirina/1.5,
                             margin:sirina>425? EdgeInsets.only(left: 55):EdgeInsets.all(0),
                             child: Wrap(
                               direction: Axis.horizontal,
                               children: <Widget>[
                                 Row(
                                   children: <Widget>[
                                     new Container(
                                       child: new IconButton(
                                         icon: new Icon(Icons.thumb_up,size: 20+(sirina/500),color:korisnici[index].korisnikLajkovao==1?Colors.blue:Colors.black,),
                                         onPressed: () {
                                           setState(() {
                                           if(resenaobjava==0)
                                             {
                                               servis.addLikeComment(idKorisnika, korisnici[index].id);
                                               getComments();
                                               printKorisnici();
                                             }

                                           });

                                         },
                                       ),
                                       //margin:EdgeInsets.only(left:70.0),
                                       padding: EdgeInsets.only(
                                           left: 10.0),
                                     ),
                                     new Container(
                                       child: GestureDetector(
                                         child: Text(korisnici[index].brojLajkova.toString()),
                                       ),

                                       padding: EdgeInsets.only(
                                           left: 10.0),
                                     ),
                                     new Container(
                                       child: new IconButton(
                                         icon: new Icon(Icons.thumb_down,size: 20+(sirina/500),color: korisnici[index].korisnikaDislajkovao==1?Colors.red:Colors.black,),
                                         onPressed: () {
                                                  if(resenaobjava==0) {
                                                      servis.addDislikeComment(
                                                          idKorisnika,
                                                          korisnici[index].id);
                                                    getComments();
                                                    printKorisnici();
                                                  }
                                         },
                                       ),
                                       //margin:EdgeInsets.all(20.0),
                                       padding: EdgeInsets.only(
                                           left: 10.0),
                                     ),
                                     new Container(
                                       child: GestureDetector(
                                         child:  Text(korisnici[index].brojDislajkova.toString()),
                                       ),
                                       //margin:EdgeInsets.only(left:70.0),
                                       padding: EdgeInsets.only(
                                           left: 10.0, right: 10.0, top: 0.0),
                                     ),
                                     new Container(

                                       child: new IconButton(
                                         icon: Icon(Icons.report,size: 20+(sirina/500),color: korisnici[index].korisnikReportovao==0?Colors.black:Colors.blue,),
                                         onPressed: () {
                                            if(resenaobjava==0) {
                                              _showDialog1(korisnici[index].id);
                                              getComments();
                                              printKorisnici();
                                            }
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
              }
              )
      );
  }
bool aktivni_komentari=false;
  void postaviKomentar(){
    int resen_problem;
    if(str != ""){
      poslata_slika = 1;
    }else{
      poslata_slika = 0;
    }

    if(checked_resenje == false){
      resen_problem = 0;

    }else{
      resen_problem = 1;
    }
    servis.uploadImageComment(slika, _commentController.text, idKorisnika, idObjave, poslata_slika, resen_problem);
  }

  void ucitavalica() async
  {
    Uint8List imageFile= await ImagePickerWeb.getImage(outputType: ImageType.bytes);


    String stri=base64Encode(imageFile);



//print(stri);
    setState(() {
      str=stri;
    });

    _showDialog2();
  }
int pom=1;
  @override

  double sirina;
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (korisnici.length == 0 && pom==1) {
      getComments();
      setState(() {
        pom=0;
      });
    }

    double velicina(int pom){
      return size.width/100 * pom;
    }

sirina=MediaQuery.of(context).size.width;
    return Scaffold(
        body:  Container(
              width: MediaQuery.of(context).size.width-sirina*0.15,
              child: Column(

                children: <Widget>[
                  resenaobjava==0?Container(
                    width: sirina/1.3,
                    margin: EdgeInsets.only(top: 30,left: 40),
                    alignment: Alignment.centerLeft,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      color:  Color.fromRGBO(
                          59, 227, 168,1),

                      child: _buildText("Komentariši",12.0+(sirina/250.0).ceil(),0,1),
                      onPressed: (){
                      setState(() {
                        aktivni_komentari=true;
                      });
                      },
                    ),
                  ):Container(),
                  Container(
                    alignment: Alignment.center,
                    width: sirina/1.3,
                    padding: EdgeInsets.only(left: 15,right: 15,bottom: 15),
                      child: _buildText("Komentari objave",16.0+(sirina/250.0).ceil(),2,1)
                  ),

                  Container(
                      child: printKorisnici()
                  ),


                 aktivni_komentari==true && resenaobjava==0?
                     Container(
                       alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(

                              border: Border.all(color:Colors.grey,width: 5),
                            ),
                            width:sirina/2,
                            height: 200,
                            child: Column(children: <Widget>[
                              _buildText("Ostavite svoj komentar.", 9.0+(sirina/200.0).ceil(), 2, 1),
                              Container(
                                child:TextFormField(
                                  decoration: InputDecoration(hintText: 'Unesite komentar...',hintStyle: TextStyle(fontSize:  9.0+(sirina/200.0))),
                                  controller: _commentController,
                                ),
                                decoration: BoxDecoration(
                                    border: Border(bottom:BorderSide(width: 1))
                                ),
                                width:sirina<500? sirina/2.2:sirina/3,

                              ),
                              //Container(child:IconButton(onPressed: (){  }, icon: Icon(Icons.photo_album)), width: velicina(16)),

                              Wrap(
                                direction: Axis.horizontal,
                                children: <Widget>[

                                  Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    child:RaisedButton(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                      color:Color.fromRGBO(
                                          59, 227, 168,1),
                                      onPressed: (){

                                        //print(str);
                                        servis.setComment(_commentController.text, logovan_korisnik.id, idObjave, 0, 0);

                                        setState(() {
                                          aktivni_komentari=false;
                                          getComments();
                                          printKorisnici();
                                          str="";
                                          _commentController.text="";
                                          html.window.sessionStorage['IDObjave']=idobjavee;
                                          html.window.sessionStorage['IDKorisnika']=idkorisnikaa;
                                          AppBarPageState.trenIndex=3;
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context) =>
                                                  AppBarPage()
                                          )
                                          );
                                        });
                                      },
                                      child:_buildText("Postavi komentar",9.0+(sirina/200.0).ceil(),0,0),
                                      padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                                    ),

                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                      color: Color.fromRGBO(
                                          59, 227, 168,1),
                                      child: _buildText(
                                          "Zatvori",9.0+(sirina/200.0).ceil(),0,0
                                      ),
                                      onPressed: (){
                                        setState(() {
                                          aktivni_komentari=false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ) ,

                            ],
                            ) ,


                            /*decoration: BoxDecoration(
                              border: Border.all(width: 3),
                            ),*/

                      )
                :Container(),

                ],
              ),
            ),


    );
  }

List<RazlogReporta> razlozi=List<RazlogReporta>();

  void getreport(){
    servis.dajRazlogePrijave().then(
          (response) {
        Iterable list = json.decode(response.body);
        List<RazlogReporta> korisniciList = List<RazlogReporta>();
        korisniciList = list.map((model) => RazlogReporta.fromObject(model)).toList();
        setState(
              () {
                razlozi = korisniciList;

          },
        );

      },
    );
  }




  void _showDialog2() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: _buildText('Uspešno ste učitali sliku.',18,2,0),
            content:
            _buildText('Postavite Vas komentar?',16,2,0),
            actions: <Widget>[
              FlatButton(
                child: _buildText('Zatvori',16,2,0),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

            ],
          );
        });
  }




  void _showDialog1(int broj) {

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

                                      servis.reportComm(broj,razlozi[index].id,logovan_korisnik.id);
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


  Widget _buildText(String str,double size,int boja,int bold )
  {
    return Container(
        child:Text(str,style:gf.GoogleFonts.ubuntu(color:boja==1?Color.fromRGBO(42, 184, 115, 1):boja==2?Colors.black:Colors.white,fontSize: size,fontWeight:bold==1?FontWeight.bold:FontWeight.normal),)
    );

  }





}
