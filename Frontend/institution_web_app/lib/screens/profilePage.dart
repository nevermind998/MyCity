import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:webApp/models/Grad.dart';
import 'package:webApp/models/Komentar.dart';
import 'package:webApp/models/RazlogReporta.dart';
import '../models/Kategorije.dart';
import '../models/Korisnik.dart';
import '../models/Objava.dart';
import 'dart:html' as html;
import '../services/api_services.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'appBarPage.dart';
import 'appBarPage.dart';
import 'loginPage.dart';
class ProfilePage extends StatefulWidget {

  _ProfilePageState profil;

  @override
  _ProfilePageState createState() {
    profil = _ProfilePageState();
    return profil;
  }
}

class _ProfilePageState extends State<ProfilePage> {


  List<Korisnik>korisnicii=List<Korisnik>();
  String token="";
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
  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();

  double visina=40;
  double sirina=250;
  double sirina1;

  bool aktivna_biografija=false;
  List<Kategorija> kategorije=List<Kategorija>();
  List<Kategorija> izabrane_kategorije=List<Kategorija>();
  Kategorija selectedkat=Kategorija();
  Kategorija selectedizakat=Kategorija();
  bool azuriranje_aktivno=false;
  @override
  Korisnik logovan_user;
  Korisnik user;
  api_services servis = api_services();
  List<Objava> objave=List<Objava> ();
  int a=0;

  List<Grad> gradovizakorisnika=List<Grad> ();
  Grad selectedizabranigrad=Grad();
  void initState() {
    if(html.window.sessionStorage.length<1)
    {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
    get_localUser();
    super.initState();
    getToken();
    dajKategorijeInstitucije();
    dajKategorije();
    dajGradovekorisnikaa();
    dajGradove();
    dajListuzaprijavu();

  }


  void get_localUser() async {
    Korisnik _user = await api_services().getUserSession();
    setState(() {
      logovan_user = _user;

    });
  }

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nazivController = TextEditingController();
  TextEditingController _kontaktController = TextEditingController();
  TextEditingController _biografijaController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordControllernewpass = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  List<Grad>gradovi=List<Grad>();
  Grad selected=Grad();
  void dajGradove() {
    servis.dajGradove().then((response) {

      Iterable list = json.decode(response.body);
      setState(() {

        gradovi=list.map((model) => Grad.fromObject(model)).toList();
        selected=gradovi[0];

      });
    });
  }

  void _showDialogAdmin(String str1,String str2) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: _buildText(str1, 16, 2, 0),
          content: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                _buildText(str2, 16, 2, 0),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child:_buildText("Zatvori", 16, 2, 0),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void dajGradovekorisnikaa() {
    servis.dajGradoveZaKorisnika(user.id).then((response) {

      Iterable list = json.decode(response.body);
      setState(() {
        gradovizakorisnika =list.map((model) => Grad.fromObject(model)).toList();
        selectedizabranigrad=gradovizakorisnika[0];
      });
    });
  }
  void dajKategorije() {
    servis.fetchDajKategorije().then((response) {

      Iterable list = json.decode(response.body);
      setState(() {
        kategorije=list.map((model) => Kategorija.fromObject(model)).toList();
        selectedkat=kategorije[0];
      });
    });
  }
  void dajKategorijeInstitucije() {
    servis.fetchDajKategorijeinstitucije(user.id).then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        izabrane_kategorije=list.map((model) => Kategorija.fromObject(model)).toList();
        selectedizakat=izabrane_kategorije[0];
      });
    });
  }
  List<DropdownMenuItem<Grad>> buildDropdownMenuItems(List _gradovi) {
    List<DropdownMenuItem<Grad>> items = List();

    for (Grad grad in _gradovi) {
      items.add(
        DropdownMenuItem(
          value: grad,
          child:_buildText(grad.naziv_grada_lat,sirina1<500?12:16+(sirina/250),0,1),
        ),
      );
    }
    return items;
  }
  List<DropdownMenuItem<Kategorija>> buildDropdownMenuItemsKategorije(List _kategorije) {
    List<DropdownMenuItem<Kategorija>> items = List();

    for (Kategorija kat in _kategorije) {
      items.add(
        DropdownMenuItem(
          value: kat,
          child:_buildText(kat.naziv,sirina1<500?12:16+(sirina/250),0,1),
        ),
      );
    }
    return items;
  }
  Widget _buildGrad()
  {
    return         Container(
        width: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color:    Color.fromRGBO(
                59, 227, 168,1),
            borderRadius:BorderRadius.all(Radius.circular(50))
        ),
        child: DropdownButtonHideUnderline(
          child: new Theme(
            data: Theme.of(context).copyWith(
              canvasColor:      Color.fromRGBO(
                  59, 227, 168,1),
            ),
            child: new DropdownButton(

                items: buildDropdownMenuItems(gradovi),
                value: selected,
                onChanged: (value) {
                  setState(() {
                    selected = value;
                    int a=1;

                    //  gradovi.removeWhere((element) => element.id==selected.id);
                    for(int i=0;i<gradovizakorisnika.length;i++)
                    {
                      if(gradovizakorisnika[i].id==selected.id)
                      {

                        _showDialogAdmin("Ovaj grad je već izabran.","Molimo Vas izaberite ponovo." );
                        a=0;
                        break;
                      }
                    }
                    if(a==1)
                    {
                      gradovizakorisnika.add(selected);
                    }

                  });
                  printgradova();

                }),
          ),)
    );
  }

  Widget _buildKategorije()
  {
    return         Container(
        width: sirina1<400? 350:400,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color:     Color.fromRGBO(
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
                    int a=1;

                    //  gradovi.removeWhere((element) => element.id==selected.id);
                    for(int i=0;i<izabrane_kategorije.length;i++)
                    {
                      if(izabrane_kategorije[i].id==selectedkat.id)
                      {
                        _showDialogAdmin("Ova kategorija je već izabrana.","Molimo Vas izaberite ponovo." );
                        a=0;
                        break;
                      }
                    }
                    if(a==1)
                    {
                      izabrane_kategorije.add(selectedkat);
                    }

                  });
                  _buildKategorije();
                }),
          ),)
    );
  }

  void dajObjave() {
    servis.fetchObjaveByIdInstitucije(user.id,user.id).then(
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
        child: _buildText(objave[index].tekstualna_objava.tekst,15+sirina1/250,2,0),

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

                child:_buildText(objave[index].slika.opis_slike,15+sirina1/250,2,0)
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

  Widget contextObjaveGrid(int index) {
    if (objave[index].tekstualna_objava != null) {
      Container(
        color:Colors.indigo,
        width: 350,
        height: 220,
        child: new Container(
          child:Text(objave[index].tekstualna_objava.tekst,style: TextStyle(fontSize: 15),),
          margin:objave[index].tekstualna_objava.tekst.length<195?EdgeInsets.only(top: 50,bottom:40):EdgeInsets.only(top: 30,bottom:30) ,
          alignment: Alignment.center,
        ),
        margin:EdgeInsets.only(left: 10,right: 10,bottom: 10) ,

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
              margin: EdgeInsets.only(top:5),
              color:Colors.orange,
              width: sirina1/1.4,
              child:Text(objave[index].slika.opis_slike,style: TextStyle(fontSize: 15),),
            ):Container(),

            Container(
              color:Colors.pink,
              alignment: Alignment.center,
              //padding: sirina1>500? sirina1>1000?EdgeInsets.symmetric(horizontal: 100):EdgeInsets.symmetric(horizontal: 50):EdgeInsets.all(0),
              padding: EdgeInsets.only(left:100),
              child: Image.network(
                api_services.url_za_slike + objave[index].slika.urlSlike,
                width: 230,
                height: 180,
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
        _showDialog1(0);
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

                    broj==0?Container(
                      alignment: Alignment.center,
                      child: _buildText("Korisnici koji su dislakjovali objavu:",16,2,1),
                    ):Container(
                      alignment: Alignment.center,
                      child: _buildText("Korisnici koji su lakjovali objavu:",16,2,1),
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
                                  Container(child: _buildText(korisnicii[index].ime ,14+sirina1/250,2,0)):
                                  Container(child: _buildText(korisnicii[index].ime + ' ' + korisnicii[index].prezime,14+sirina1/250,2,0))

                                ],)
                            );
                          }),

                    ):Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child:broj==0?_buildText("Nema dislajkovao",14+sirina1/250,2,0):
                        _buildText("Nema lajkovao",14+sirina1/250,2,0)
                    ),
                    RaisedButton(
                      child:_buildText("Zatvori",14+sirina1/250,2,0),
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
  Widget prikazObjave() {
    if (objave.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: _buildText("Nema objava",14+sirina1/250,2,0),);
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
          padding: EdgeInsets.all(10),
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
                    Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        //padding: EdgeInsets.only(top:10),
                        child: Icon(Icons.done_all, size:   25+(sirina1/200),)

                    ),

                    GestureDetector(
                      child:(objave[index].vlasnik.urlSlike != null)?Container(
                        //  margin: EdgeInsets.only(bottom: 10),
                        child:
                        ClipOval(
                          child: Image.network(
                            api_services.url_za_slike+objave[index].vlasnik.urlSlike,

                            height: 50+(sirina1/500*7),
                            width: 50+(sirina1/500*7),
                            fit: BoxFit.cover,

                          ),
                        ),
                      ):Container(
                          width: 50+(sirina1/500*7),
                          height: 50+(sirina1/500*7),
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
                            child: objave[index].vlasnik != null ?
                            Text("@" + objave[index].vlasnik.username,
                              style: TextStyle(fontSize: 15+(sirina1/250),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),) : Text(""),
                          ),

                          Container(
                            child: objave[index].vlasnik != null
                                ? Text(objave[index].vlasnik.ime + " " +
                                objave[index].vlasnik.prezime
                              , style: TextStyle(fontSize: 13+(sirina1/250),),
                            )
                                : Text("Null je vlasnik"),
                          ),

                          Container(
                              child: Text(objave[index].vreme
                                , style: TextStyle(fontSize: 13+(sirina1/250),),
                              )
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
                                       servis.addLike(user.id, objave[index].id).then((value)
                                       {
                                         dajObjave();
                                       }
                                       );

                                      prikazObjave();
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

                                      servis.addDislike(user.id, objave[index].id).then((value)
                                      {
                                        dajObjave();
                                      }
                                      );
                                      prikazObjave();

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
                                _showDialogAdmin("Ne možete da prijavite objavu.","Objava je označena kao rešena.");
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
                              child: _buildText("Komentariši",12+sirina1/250,2,0),
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
                        child: _buildText("Zatvori",14+sirina1/250,2,0),
                        onPressed:(){
                          dajObjave();
                          prikazObjave();
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
          child:_buildText("Nema komentara",16+sirina1/250,2,0)

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
                                    _buildText("@"+komentari[index].korisnik.username,13.0+(sirina1/250.0).ceil(),2,1),
                                    komentari[index].korisnik.uloga=="institucija"?
                                    _buildText(komentari[index].korisnik.ime,12.0+(sirina1/250.0).ceil(),2,0):
                                    _buildText(komentari[index].korisnik.ime+" "+komentari[index].korisnik.prezime,12.0+(sirina1/250.0).ceil(),2,0),
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
                                child: komentari[index].tekst!=null?_buildText(komentari[index].tekst,12+(sirina1/250),2,0):Text("")
                            ),
                            komentari[index].korisnik.id == user.id && komentari[index].oznacenKaoResen==0
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
                                      icon: new Icon(Icons.thumb_down,size: 20+(sirina1/500),color: komentari[index].korisnikaDislajkovao==1?Colors.red:Colors.black,),
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


  void prijavakomentara(int broj,idObjave) {

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


  Widget printObjaveGrid() {
    if (objave.length == 0) {
      return new Center(
          child:Text("Nema objava")
      );
    }
    return GridView.builder(
      itemCount: objave.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 1200?2:1,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          childAspectRatio: 1.8
      ),
      itemBuilder: (context, index) {
        idobjave = index;
        cekirani.add(false);

        return Container(
          width: 520 ,

          margin: EdgeInsets.all(5),
          alignment: Alignment.center,
          //  margin:EdgeInsets.symmetric(vertical: 5) ,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color:Colors.red,
            border: Border.all(color: Colors.grey),
            //  borderRadius: BorderRadius.all(Radius.circular(50)),
          ),

          child: Column(
            children: <Widget>[
              Container(
                color:Colors.blue,
                width: 520 ,
                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[

                    (objave[index].vlasnik.urlSlike != null) ? Container(

                      child: Image.network(
                        api_services.url_za_slike +
                            objave[index].vlasnik.urlSlike,
                        height: 70,
                        width: 70,
                      ),

                    ) : Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.person, color: Colors.white, size: 30+(sirina1/500*5),)
                    ),
                    SizedBox(
                      width: 20,
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
                            child: objave[index].vlasnik != null ?
                            Text("@" + objave[index].vlasnik.username,
                              style: TextStyle(fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),) : Text(""),
                          ),

                          Container(
                            child: objave[index].vlasnik != null
                                ? Text(objave[index].vlasnik.ime + " " +
                                objave[index].vlasnik.prezime
                              , style: TextStyle(fontSize: 13),
                            )
                                : Text("Null je vlasnik"),
                          ),

                          Container(
                              child: Text(objave[index].vreme
                                , style: TextStyle(fontSize: 13),
                              )
                          ),

                        ],
                      ),
                    ),
                    Container(
                        margin:EdgeInsets.only(left: 100),
                        child: Icon(Icons.done_all, size:   25+(sirina1/200),)
                    ),



                  ],
                ),
              ),

              Container(
                color:Colors.brown,
                width: 500,
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
                                    servis.addLike(user.id, objave[index].id);
                                      dajObjave();
                                      prikazObjave();
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
                                      servis.addDislike(user.id, objave[index].id);
                                      dajObjave();
                                      prikazObjave();
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

  String str="";

  void ucitavalica() async
  {
    Uint8List imageFile= await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    String stri="";

    stri=base64Encode(imageFile);

    if(stri!="")
    {
      servis.menjalica(user.id,stri);
      _showDialogAdmin("Slika je uspešno učitana.", "Promene će biti uskoro vidljive.");
    }
    setState(() {
      getKorisnikaaa(user.id);
      profilni_podaci();
      str=stri;
    });
  }


  Widget profilni_podaci()
  {

    return               Container(

      decoration: BoxDecoration(
          color: Color.fromRGBO(
              59, 227, 168,1),
          borderRadius: BorderRadius.all(  Radius.circular(50))
      ),

      padding:EdgeInsets.all(15),
      margin:EdgeInsets.only(bottom: 30),
      alignment: Alignment.center,
      width: sirina1 <500? sirina1 / 1.2:sirina1<1000?sirina1/1.5:sirina1/ 1.8,
      child: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[

          Container(
            child:   user.urlSlike!=null?Container(

                child:  ClipOval(
                  child: Image.network(
                    api_services.url_za_slike + user.urlSlike,
                    width: 120,height: 120,
                    fit: BoxFit.cover,
                  ),
                )
            ):Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Colors.white,
                ),
                child: Icon(Icons.person,color: Color.fromRGBO(
                    59, 227, 168,1),size: 70,)
            ),

          ),

          Container(
            margin:EdgeInsets.only(left: sirina1/15),
            child: Wrap(
              direction: Axis.vertical,
              children: <Widget>[

                Container(

                  child: _buildText("@"+user.username, 16+sirina1/250,0,0),
                ),

                Container(
                  child: _buildText(user.ime,  16+sirina1/250,0,0),
                ),

                Container(
                  margin: EdgeInsets.only(right: 50),
                  child:Wrap(
                    direction: Axis.vertical,
                    children: <Widget>[

                      user.email!=null?  Container(
                        child:_buildText( user.email, 14+sirina1/250,0,0),

                      ):Container(),
                      sirina1>500?Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child:_buildText("O Instituciji:", 16+sirina1/250,0,0),
                          ),
                          Container(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),

                              color: Colors.white,
                              child: _buildText("Više", 12+sirina1/250,1,1),
                              onPressed: (){

                                setState(() {

                                  aktivna_biografija=true;

                                });

                              },
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20),
                              child: _buildDugmeZaAzuriranje()
                          ),
                        ],
                      ):Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child:_buildText("O Instituciji:", 18+sirina1/250,0,0),
                          ),
                          Container(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),

                              color: Colors.white,
                              child: _buildText("Više", 12+sirina1/250,1,1),
                              onPressed: (){

                                setState(() {

                                  aktivna_biografija=true;

                                });

                              },
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20),
                              child: _buildDugmeZaAzuriranje()
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
    );
  }

  int p=1;
  Widget build(BuildContext context) {
    if (user == null) return CircularProgressIndicator();

    if (objave.length == 0 && p==1) {
      setState(() {
        p=0;
      });
      dajObjave();

    }
    sirina1=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(

        child: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
              width: sirina1,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[

                      profilni_podaci(),

                      azuriranje_aktivno?_buildZaAzuriranje() :Container(),

                      aktivna_biografija==true?Container(

                        child: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Container(
                                width: sirina1/1.8,

                                margin: EdgeInsets.only(top: 10),
                                child: _buildText("O Instituciji:", 16+sirina1/250,2,1)),

                            Container(
                              width: sirina1/1.8,
                              margin: EdgeInsets.only(top: 10),
                              child : user.biografija!=null? _buildText(user.biografija,16+sirina1/250,2,0):
                              _buildText("Trenutno nemamo podataka.", 16+sirina1/250,2,0),

                            ),


                            Container(
                                width: sirina1/1.8,

                                margin: EdgeInsets.only(top: 10),
                                child: _buildText("Gradovi koje pratite:",  16+sirina1/250, 2, 1)),

                            Container(
                              width: sirina1/1.8,
                              margin: EdgeInsets.only(top: 10),
                              child: proba2(),
                            ),

                            Container(
                                width: sirina1/1.8,

                                margin: EdgeInsets.only(top: 10),
                                child: _buildText("Kategorije koje pratite:",  16+sirina1/250, 2, 1)),


                            Container(
                              width: sirina1/1.8,
                              margin: EdgeInsets.only(top: 10),
                              child:proba(),
                            ),




                            Container(
                              margin: EdgeInsets.only(top: 10,bottom: 10),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),

                                color: Color.fromRGBO(
                                    59, 227, 168,1),
                                child:_buildText("Zatvori", 12+sirina1/250,0,1),
                                onPressed: (){
                                  setState(() {

                                    aktivna_biografija=false;

                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ):Container(),
                    ],
                  ),

                   Container(
                     width: sirina1/1.5,
                     alignment: Alignment.center,
                     child: _buildText("Objave na ovoj strani predstavljaju probleme koje je ste rešili.", 14+sirina1/250 , 2, 0),
                   ) ,
                  SizedBox(height: 10,),
                  Container(
                      width: sirina1/1.3,
                      margin: EdgeInsets.only(top: 15),
                      child:flag==false?prikazObjave():printObjaveGrid()

                  ),
                ],
              ),

            ),
          ),
        ),
      ),
    );
  }

  bool flag=false;

  Widget _buildDugmeZaAzuriranje()
  {

    return    Container(
      padding: const EdgeInsets.all(5.0),
      alignment: Alignment.center,
      child:RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),

          color: Colors.white,
          child:_buildText("Izmena profila", 12+sirina1/250,1,1),
          onPressed:() {
            setState(() {
              azuriranje_aktivno=true;
              _nazivController.text=user.ime;
              _usernameController.text=user.username;
              _biografijaController.text=user.biografija;
              _kontaktController.text=user.email;
            });
          }
      ),
    );
  }
  Widget _buildNaziv()
  {
    return  Container(
      width: sirina1/(sirina1/400),
      child: TextFormField(
        controller: _nazivController,
        style: gf.GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          hintText: "Naziv:",
          prefixIcon: Padding(child: Icon(Icons.account_balance, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),

        validator: (String value ){
          if(value.isEmpty)
          {
            return "Nije unet Naziv.";
          }
          if(!RegExp("^[0-9a-zA-Z .ČčĆćŽžŠšĐđ]{1,}").hasMatch(value))
          {
            return "Dozvoljeno je unositi samo slova.";
          }
          return null;
        },
        onSaved: (String value){

        },
      ),

    );
  }

  Widget _buildBiografija()
  {
    return  Container(
      width:  sirina1/(sirina1/400),
      child: TextFormField(
        controller: _biografijaController,
        style: gf.GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          hintText: "O Instituciji: Nije obavezno",
          prefixIcon: Padding(child: Icon(Icons.description, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (String value ){
          return null;
        },
        onSaved: (String value){

        },
      ),
    );
  }






  Widget printgradova() {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (sirina1-250.0 > 1200) ? 5
              :(sirina1-250.0 > 800?4:sirina1-250.0 > 600?3:sirina1-250.0 > 450?2:1),
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio:2,
        ),
        //physics: NeverScrollableScrollPhysics(),
        itemCount: gradovizakorisnika.length,
        itemBuilder: (context, index) {
          return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(5),

              child:Column(
                children: <Widget>[
                  _buildText(
                      gradovizakorisnika[index].naziv_grada_lat,20,2,0
                  ),
                  IconButton(icon: Icon(Icons.close),
                    onPressed: (){
                      setState(() {
                        if(gradovizakorisnika.length>1)
                        {
                          gradovizakorisnika.removeAt(index);
                          printgradova();
                        }
                        else{
                          _showDialogAdmin("Morate imati barem jedan izabrani grad.","" );
                        }

                      });

                    },
                  )
                ],
              )
          );
        }
    );
  }





  Widget printkategorije() {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (sirina1-200.0 > 1200) ? 4
              :(sirina1-200.0 > 800?3:sirina1-200.0 > 600?2:1),
          crossAxisSpacing: 5,
          childAspectRatio:2.3,
        ),
        //physics: NeverScrollableScrollPhysics(),
        itemCount: izabrane_kategorije.length,
        itemBuilder: (context, index) {
          return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  _buildText(
                      izabrane_kategorije[index].naziv,20,2,0
                  ),
                  IconButton(icon: Icon(Icons.close),
                    onPressed: (){
                      setState(() {
                        if(izabrane_kategorije.length>1)
                        {
                          izabrane_kategorije.removeAt(index);
                          printkategorije();
                        }
                        else{
                          _showDialogAdmin("Morate imati barem jedanu izabranu kategoriju.","" );
                        }

                      });

                    },
                  )
                ],
              )
          );
        }
    );
  }
  int pomm=1;
  Widget proba()
  {
    String str="";

    if (izabrane_kategorije.length == 0 && pomm==1) {
      dajKategorijeInstitucije();
      setState(() {
        pomm=0;
      });

    }
    for(int i =0;i<izabrane_kategorije.length;i++)
    {
      if(i<izabrane_kategorije.length-1)
        str=str+izabrane_kategorije[i].naziv+", ";
      else{
        str=str+izabrane_kategorije[i].naziv+".";
      }

    }

    return Container(
      child: _buildText(str,18,2, 0),
    );
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
      child: _buildText(str,18,2, 0),
    );
  }

  Widget _buildKorisnickoIme()
  {
    return  Container(
      width:  sirina1/(sirina1/400),
      child: TextFormField(
        controller: _usernameController,
        style: gf.GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          hintText: "Korisničko ime",
          prefixIcon: Padding(child: Icon(Icons.person, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (String value ){
          if(value.isEmpty)
          {
            return "Nije uneto Korisničko ime.";
          }
          if(!RegExp("^[0-9a-zA-Z .ČčĆćŽžŠšĐđ_]{1,}").hasMatch(value))
          {
            return "Niste lepo uneli Korisničko ime.";
          }
          return null;
        },
        onSaved: (String value){

        },
      ),
    );
  }
    bool pomocni=false;
  Widget _buildDugmeZaAzuriranjeProfila()
  {
    return    Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5.0),
      child:RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color:Color.fromRGBO(
              59, 227, 168,1),
          child:_buildText("Izmeni podatke",12+sirina1/250,0,1),
          onPressed:() {

            if(!_formKey.currentState.validate())
            {
              return null;
            }
            else{
              int ind=0;

              if(_passwordController.text=="" && _passwordControllernewpass.text!="" )
                {
                  setState(() {
                    ind=1;
                  });
                }
              if(_passwordController.text!="" && _passwordControllernewpass.text=="" )
              {
                setState(() {
                  ind=2;
                });
              }

              visina=30;
              _formKey.currentState.save();
              var body;


              List<int>gradovii=List<int>();
              List<int>kategorijee=List<int>();
              for(int i=0;i<izabrane_kategorije.length;i++)
              {
                setState(() {
                  kategorijee.add(izabrane_kategorije[i].id);
                });
              }
              for(int i=0;i<gradovizakorisnika.length;i++)
              {
                setState(() {
                  gradovii.add(gradovizakorisnika[i].id);
                });
              }

              if(ind==0)
                {
                  var bytes = utf8.encode(_passwordController.text);
                  var sif = sha1.convert(bytes);
                  var bytes1 = utf8.encode(_passwordControllernewpass.text);
                  var sifn = sha1.convert(bytes1);
                  body = jsonEncode({
                    "korisnik":{
                      "id":user.id,
                      "ime": _nazivController.text==""?user.ime: _nazivController.text,
                      "biografija": _biografijaController.text==""?user.biografija:_biografijaController.text,
                      "email":_kontaktController.text==""?user.email:_kontaktController.text,
                      "username": _usernameController.text==""?user.username:_usernameController.text,
                      "password": _passwordController.text==""?null:sif.toString()
                    },
                    "idGradova":gradovii,
                    "kategorije":kategorijee,
                    "newPassword":_passwordControllernewpass.text==""?null:sifn.toString()
                  });
                  api_services().azuriranje(body,context).then((response){

                    if(response.statusCode == 200){
                      getKorisnikaaa(user.id);
                    }
                    else {
                      if(response.statusCode ==204)
                      {
                        _showDialogAdmin("Korisničko ime je zauzato.","Pokusajte ponovo.");

                      }
                      if(response.statusCode ==404)
                      {
                        _showDialogAdmin("Niste lepo uneli šifru.","Pokusajte ponovo.");
                      }

                    }
                  });;

                  setState(() {
                    azuriranje_aktivno=false;
                  });

                }else {
                if(ind==1)
                  {
                    _showDialogAdmin("Niste uneli trenutnu šifru.","Pokusajte ponovo.");
                  }
                if(ind==2)
                  {
                    _showDialogAdmin("Niste uneli novu šifru.","Pokusajte ponovo.");
                  }
              }





            }

          }
      ),
    );
  }
   getKorisnikaaa(int id) async {
    servis.fetchKorisnik(id).then(
          (response) {
        Map<String, dynamic> jsonObject = json.decode(response.body);
        Korisnik s = new Korisnik();
        s = Korisnik.fromObject(jsonObject);
        setState(() {

          user = s;
          html.window.sessionStorage["userInfo"]=response.body;
          html.window.sessionStorage["token"]=jsonObject['token'];
          pomocni=true;
        });
      },
    );
  }
  Widget _buildSifra()
  {
    return  Container(
      width:  sirina1/(sirina1/400),
      child: TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword ,
        obscureText: true,
        style: gf.GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          hintText: "Trenutna šifra",
          prefixIcon: Padding(child: Icon(Icons.security, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (String value ){
          return null;
        },
        onSaved: (String value){
        },
      ),
    );
  }
  Widget _buildSifra1()
  {
    return  Container(
      width:  sirina1/(sirina1/400),
      child: TextFormField(
        controller: _passwordControllernewpass,
        keyboardType: TextInputType.visiblePassword ,
        obscureText: true,
        style: gf.GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          hintText: "Nova šifra",
          prefixIcon: Padding(child: Icon(Icons.security, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (String value ){
          return null;
        },
        onSaved: (String value){
        },
      ),
    );
  }


  Widget _buildZaAzuriranje()
  {
    return Container(
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              //_buildText("Naziv:",15),
              new Container(
                  padding: EdgeInsets.only(right: 20),
                  alignment: Alignment.center,
                  child:RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),

                    color:Color.fromRGBO(
                        59, 227, 168,1),

                    child:  _buildText("Promeni profilnu sliku",12+sirina1/250,0,1),
                    onPressed: (){
                      ucitavalica();


                    },
                  )
              ),SizedBox(
                height: 15,
              ),
              _buildNaziv(),
              SizedBox(
                height: 15,
              ),
              //_buildText("Kontakt:",15),
              /* _buildKontakt(),
              SizedBox(
                height: 15,
              ),*/
              // _buildText("O Vama:",15),
              _buildBiografija(),
              SizedBox(
                height: 15,
              ),
              _buildText("Grad:",18+sirina1/250,1,0),
              _buildGrad(),
              SizedBox(
                height: 15,
              ),
              _buildText("Izabrani gradovi:",18+sirina1/250,1,0),
              Container(
                  width: sirina1/1.4,
                  child: printgradova()
              ),

              _buildText("Oblast delatnosti:",18+sirina1/250,1,0),

              _buildKategorije(),
              SizedBox(
                height: 15,
              ),
              _buildText("Izabrane delatnosti:",18+sirina1/250,1,0),

              Container( width: sirina1,
                  child: printkategorije()),
              SizedBox(
                height: 15,
              ),



              //_buildText("Koricničko ime:",15),

              _buildKorisnickoIme(),
              SizedBox(
                height: 15,
              ),
              //  _buildText("Unesite sadasnju lozinku:",15),
              _buildSifra(),
              SizedBox(
                height: 15,
              ),
              // _buildText("Unesite novu lozinku:",15),
              _buildSifra1(),
              SizedBox(
                height: 15,
              ),
              // greska_kod_registrovanja==true?
              // _buildText("Postoji korisnicko ime!", 16):Container() ,

              _buildDugmeZaAzuriranjeProfila(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildText(String str,double size,int boja,int bold )
  {
    return Container(
        child:Text(str,style:gf.GoogleFonts.ubuntu(color:boja==1?Color.fromRGBO(42, 184, 115, 1):boja==2?Colors.black:Colors.white,fontSize: size,fontWeight:bold==1?FontWeight.bold:FontWeight.normal),)
    );

  }


}