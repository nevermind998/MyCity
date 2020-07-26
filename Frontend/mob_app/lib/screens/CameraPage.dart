import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mob_app/Map/prikaz_mape.dart';
import 'package:mob_app/models/Grad.dart';
import 'package:mob_app/models/KategorijaObjave.dart';
import 'package:mob_app/models/LepeKategorije.dart';
import 'package:mob_app/screens/BottomBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/Korisnik.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  var _textController = TextEditingController();

  api_services service = api_services();

  File tmpFile;
  Future<File> file;

  String status = '';
  String base64Image;
  String errMessage = 'Error Uploading Image';

  double latitude;
  double longitude;
  List<Grad> gradovi;
  List<KategorijaObjave> kategorije;
  List<LepeKategorije> lepeKategorije;
  List<int> odabraneKategorije = List<int>();
  List<int> odabraneLepeKategorije = List<int>();
  List<String> imenaOdabranihKategorija = List<String>();
  List<String> imenaOdabranihLepihKategorija = List<String>();
  Grad selected;
  KategorijaObjave selectedKategorija;
  LepeKategorije selectedLepeKategorije;
  int _radioValue = 0;
  int _radioProblemi = 0;
  Grad grad;
  String _grad;
  String adresa;
  String proizvoljnaAdresa = '';
  Color svetlo_plava = Color.fromRGBO(125, 197, 255, 0.9);
  Color svetlo_zelena = Color(0xFFa8e6cf);
  Color svetlo_zelena2 = Color(0xFFd5ede5);
  Color gradient1 = Color(0xFF91c9b5);
  Color gradient2 = Color(0xFF7dad9c);
  Color gradient3 = Color(0xFF6e998a);
  Color gradient4 = Color(0xFF61877a);
  api_services servis = api_services();

  FocusNode textFocusNode = FocusNode();


  static bool img = false;
  Korisnik user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    img = false;
    get_localUser();
    dajGradove();
    dajKategorije();
    dajLepeStvari();
    setPermissions();
  }


  void get_localUser() async {
    Korisnik _user = await api_services().getUser();
    print(_user.prezime);
    setState(() {
      user = _user;
    });
  }

  void setPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
  }

  Position trenutna_pozicija;

  void dajPoziciju() {
    Future<Position> _position = service.getCurrentLocation().then((value) {
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
      });

      dajTrenutniGrad().then((naziv_grada) {
        if(gradovi !=null){
          gradovi.forEach((element) {
            if (element.naziv_grada_cir == naziv_grada) {
              setState(() {
                selected = element;
              });
            }
          });
          if (selected == null) {
            selected = gradovi[0];
          }
        }
      });
      
    dajGrad(latitude, longitude).then((grad) {
      setState(() {
        _grad = grad.locality;
        adresa = grad.addressLine;
        print('Grad je ' + _grad);
        print('Adresa je ' + adresa);
      });
    });

    });
  }

  chooseImage(bool cm) {
    if (cm == true) {
      setState(() {
        file = ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 30);
      });
    } else {
      setState(() {
        file = ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
      });
    }
  }

  startUpload(BuildContext context, int lepaStvarID) {
    print('latitude je ' + latitude.toString() + 'longitude je ' + longitude.toString());
    if (null == tmpFile) {
      return;
    }
    print(tmpFile);
    int idGrada;
    int pom=0;
    dajGrad(latitude, longitude).then((value){
      print(value.locality);
      for(grad in gradovi){

        if(grad.naziv_grada_cir == value.locality){
          idGrada = grad.id;
          pom = 1;
          print('nasao je ' + grad.naziv_grada_lat);
          break;
        }
      }
      if(pom == 0){
        print('nisam nasao grad pa sam stavio kragujevac UPSS');
        idGrada = 28;
      }
        print(idGrada.toString() + ' ' + value.locality);
        service.uploadImage(tmpFile, user.id, _textController.text, latitude, longitude, idGrada, odabraneKategorije, context, lepaStvarID);
      

    });

    //service.uploadImage(tmpFile, user.id, _textController.text, latitude, longitude);
    //service.addImage(user.id, _textController.text, latitude, longitude);
  }

  Future<Address> dajGrad(double latitude, double longitude) async {
    final coordinates = new Coordinates(latitude, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    //print(first.addressLine);
    String gradic = first.locality;
    return first;
  }

  Widget showImage() {
    file.then((value){
      if(value == null){
        setState(() {
          img = false;
          file = null;
        });
      }
    });
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data && img == true) {
          tmpFile = snapshot.data;
          
          base64Image = base64Encode(snapshot.data.readAsBytesSync());

          return Container(
            child: Image.file(
              snapshot.data,
              width:400,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Text('');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (latitude == null) {
      dajPoziciju();
    }

    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

      },
      child: Scaffold(
      appBar: AppBar(
        title: Text("Dodavanje nove objave",
        style: TextStyle(color: Colors.white)),
      ),
      body: gradovi==null || kategorije == null? 
      Center(child:Container(
        child:CircularProgressIndicator()
      ))
      : SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          child: new Column(
          children: <Widget>[

            Container(
              child: Column(children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text('Uneti tekstualnu objavu', 
                  style:gf.GoogleFonts.ubuntu(
                    fontSize: 18, 
                    fontWeight: 
                    FontWeight.bold)
                  ),
                  margin:EdgeInsets.fromLTRB(25.0, 20, 0.0, 0.0),
                  
                ),

                new Container(
                      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 2.0),
                      child: TextFormField(
                            
                            controller: _textController,
                            textCapitalization: TextCapitalization.sentences,
                            textAlign: TextAlign.start,
                            cursorWidth: 2.0,
                            autofocus: false,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                hintText: "Unesite željeni tekst...",
                                labelText: 'Tekst'),
                            maxLines: 3,
                          ),
                    ),

              ],)
            ),

            Center(
              child:Container(
              child: Column(children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text('Dodavanje fotografije', 
                  style:gf.GoogleFonts.ubuntu(
                    fontSize: 18, 
                    fontWeight: 
                    FontWeight.bold)
                  ),
                  margin:EdgeInsets.fromLTRB(25.0, 20, 0.0, 0.0),
                  
                ),
                img == true? Container(
                  alignment: Alignment.topRight,
                  padding:EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  child:IconButton(
                    icon: Icon(Icons.cancel,
                    size:40.0
                    ),
                    onPressed: (){
                      setState(() {
                        img = false;
                      });
                    },
                  )
                ): SizedBox(),
                file != null?
                Container(
                  width:250,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                  decoration: BoxDecoration(
                  ),
                  child: showImage(),
                ):SizedBox(height:20),
                Container(
                  alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width:MediaQuery.of(context).size.width * .65,
              height: 120.0,
              child: Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)
                  ),
                  width: 80,
                  height: 80,
                  child: IconButton(icon:Icon(
                    Icons.camera_alt, size: 40, color: Colors.black),
                    onPressed: () {
                          chooseImage(true);
                          setState(() {
                            img = true;
                          });
                        },
                    ),

              ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                  ),
                  width: 80,
                  height: 80,
                  child: IconButton(icon:Icon(
                    Icons.photo, size: 40, color: Colors.black),
                    onPressed: () {
                          chooseImage(false);
                          setState(() {
                            img = true;
                          });
                        },
                    ),
              ),
                
              ],)
              
            ),
            Container(
                      alignment: Alignment.topLeft,
                      child: Text('Odabir lokacije:', 
                      style:gf.GoogleFonts.ubuntu(
                        fontSize: 18, 
                        fontWeight: 
                        FontWeight.bold)
                      ),
                      margin:EdgeInsets.fromLTRB(25.0, 0, 0.0, 10.0),
                      
                    ),
                /*new DropdownButton(
                              items: buildDropdownMenuItems(gradovi),
                              value: selected,
                              onChanged: (value) {
                                setState(() {
                                  selected = value;
                                });
                              }),*/
                img == true?
                Column(children: <Widget>[
                  Container(
                  child: Text(
                      'Da li želite da koristite trenutnu lokaciju ili želite da odaberete proizvoljnu?'),
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 10.0),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioChange),
                      Text('Vaša lokacija'),
                      Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioChange),
                      Text("Proizvoljna lokacija"),
                    ],
                  ),
                  _radioValue == 0 //Ako je na radio button-u odabrana 'Vasa Lokacija'
                      ? adresa!=null? 
                        Container(
                          margin:EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                          child: Text(adresa)
                        )
                      : 
                      Container(
                          margin:EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                          child:Text('Još uvek tražimo Vašu lokaciju, proverite da li je uključena lokacija na uređaju.',
                          textAlign: TextAlign.center),
                        )
                      : Column(children: <Widget>[
                        proizvoljnaAdresa!=""?
                        Container(
                          margin:EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                          child: Text(proizvoljnaAdresa)
                        ):Text(''),
                        Container(
                        margin:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child:RaisedButton(
                        
                          child: Text('Obeležite lokaciju na mapi'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Mapa2()
                                  /*prikazMape(latitude, longitude)*/)).then((value){
                                    if(value == 'nista'){
                                      print('nista');
                                    }else{
                                      var result = value.toString().split(' ');
                                      setState(() {
                                        latitude = double.parse(result[0]);
                                        longitude = double.parse(result[1]);
                                        dajGrad(latitude, longitude).then((value){
                                          proizvoljnaAdresa = value.addressLine;
                                        });
                                      });
                                    }
                                  });
                          },
                        ))

                      ],) 
                ],):
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                  child: Column(children: <Widget>[
                    Container(
                      margin:EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                      child:Text('Ukoliko ne želite da objava sadrži i fotografiju potrebno je da odaberete grad na koji će se objava odnositi',
                      textAlign: TextAlign.center,
                      ),
                    ),
                    DropdownButton(
                    items: buildDropdownMenuItems(gradovi),
                    value: selected,
                    onChanged: (value) {
                      setState(() {
                        selected = value;
                      });
                    })
                  ],)
                  
                )
                
              ],)
            )),
            Container(
              child: Column(children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text('Odabir kategorije objave', 
                  style:gf.GoogleFonts.ubuntu(
                    fontSize: 18, 
                    fontWeight: 
                    FontWeight.bold)
                  ),
                  margin:EdgeInsets.fromLTRB(25.0, 20, 0.0, 0.0),
                ),

                Container(
                  margin:EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                      child:Text('Da li Vaša objava predstavlja neki problem?',
                      textAlign: TextAlign.center,
                      ),
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 0,
                        groupValue: _radioProblemi,
                        onChanged: radioButtonChanges,
                      ),
                      Text('Problem'),
                      Radio(
                        value: 1,
                        groupValue: _radioProblemi,
                        onChanged: radioButtonChanges,
                      ),
                      Text('Ne predstavlja problem'),
                    ],
                  ), 
                ),
                Container(
                      margin:EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                      child:Text('Odaberite kategoriju objave',
                      textAlign: TextAlign.center,
                      ),
                    ),

                _radioProblemi == 0?

                Column(children: <Widget>[
                  Container(
                  child:DropdownButton(
                    items: buildDropdownMenuItemsKategorije(kategorije),
                    value: selectedKategorija,
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        selectedKategorija = value;
                      });
                    })
                ),
                Container(
                  child: RaisedButton(child: Text('Dodajte kategoriju'), onPressed: (){
                    if( odabraneKategorije.firstWhere((element) => element == selectedKategorija.id, orElse: () => null) == null){
                                  setState(() {
                                    imenaOdabranihKategorija.add(selectedKategorija.kategorija);
                                    odabraneKategorije.add(selectedKategorija.id);
                                  }); 
                                  print(odabraneKategorije);
                                }
                  },)
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: imenaOdabranihKategorija.length == 0? 
                  Text('Objava mora sadržati minimum jednu kategoriju', style: TextStyle(
                    color: Colors.red
                  )): 
                  listKategorija()
                )
                ],)
                
                :

                Column(children: <Widget>[
                  Container(
                  child:DropdownButton(
                    items: buildDropdownMenuItemsLepeKategorije(lepeKategorije),
                    value: selectedLepeKategorije,
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        selectedLepeKategorije = value;
                      });
                    })
                ),
                /*Container(
                  child: RaisedButton(child: Text('Dodajte kategoriju'), onPressed: (){
                    if( odabraneLepeKategorije.firstWhere((element) => element == selectedLepeKategorije.id, orElse: () => null) == null){
                                  setState(() {
                                    if(imenaOdabranihLepihKategorija.length == 0){
                                      imenaOdabranihLepihKategorija.add(selectedLepeKategorije.kategorija);
                                      odabraneLepeKategorije.add(selectedLepeKategorije.id);
                                    }else{
                                      imenaOdabranihLepihKategorija.removeAt(0);
                                      odabraneLepeKategorije.removeAt(0);
                                      imenaOdabranihLepihKategorija.add(selectedLepeKategorije.kategorija);
                                      odabraneLepeKategorije.add(selectedLepeKategorije.id);
                                    }
                                    /*imenaOdabranihLepihKategorija.add(selectedLepeKategorije.kategorija);
                                    odabraneLepeKategorije.add(selectedLepeKategorije.id);*/
                                  }); 
                                  print(odabraneLepeKategorije);
                                }
                  },)
                ),*/
                /*Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: imenaOdabranihLepihKategorija.length == 0? 
                  Text('Objava mora imati kategoriju', style: TextStyle(
                    color: Colors.red
                  )): 
                  listLepeKategorija()
                )*/
                ],), 
                
                SizedBox(height:10)
                
              ],)
            ),
            new Container(
              child: img == false
                  ? new Container(
                    margin:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child:RaisedButton(
                      textColor: Colors.white,
                      color: Color(0xFF49c486),
                      child: Text('Objavite'),
                      onPressed: () {
                        int lepaStvarID;
                        if((_radioProblemi == 0 && odabraneKategorije.length == 0)){
                          _nemaKategorijeDialog();
                        }else if(_textController.text ==""){
                          _nemaTekstaDialog();
                        }else if(selected == null){
                          _nemaGradaDialog();
                        } else{
                          print('usao ovde');
                          //obavestenjeZaObjavu();
                          Fluttertoast.showToast(
                            msg: "Objavljivanje je u toku... Molimo sačekajte trenutak",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color(0xFF49c486),
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                          List<int> kategorije = List<int>();
                          if(_radioProblemi == 0){
                            lepaStvarID = 0;
                            kategorije.addAll(odabraneKategorije);
                          }else{
                            lepaStvarID = selectedLepeKategorije.id;
                            List<int> _kategorije = List<int>();
                            _kategorije.add(selectedLepeKategorije.id);
                            kategorije.addAll(_kategorije);
                          }
                          servis.newTextPost(_textController.text, user.id, selected, kategorije, lepaStvarID, context).then((value){
                            setState(() {
                              img = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) =>  MyBottomBar.withIndex(0)),
                            );
                          });
                        }
                      },
                    ))
                  : new Container(
                      child: RaisedButton(
                        onPressed: () async {
                          int lepaStvarID;
                          if(_radioProblemi == 0 && odabraneKategorije.length == 0){
                            _nemaKategorijeDialog();
                          }else if(latitude == null || longitude == null){
                            _nemaLokacijeDialog();
                          } else{
                            //obavestenjeZaObjavu();
                            Fluttertoast.showToast(
                              msg: "Objavljivanje je u toku... Molimo sačekajte trenutak",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color(0xFF49c486),
                              textColor: Colors.white,
                              fontSize: 16.0
                            );
                            List<int> kategorije = List<int>();
                            if(_radioProblemi == 0){
                              lepaStvarID = 0;
                              kategorije.addAll(odabraneKategorije);
                            }else{
                              lepaStvarID = selectedLepeKategorije.id;
                              List<int> _kategorije = List<int>();
                              _kategorije.add(selectedLepeKategorije.id);
                              kategorije.addAll(_kategorije);
                            }
                            startUpload(context, lepaStvarID);
                          }
                        },
                        child: Text(
                          "Objavite",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Color(0xFF49c486),
                      ),
                      margin: EdgeInsets.all(20.0),
                    ),
            ),
          ],
        ),
        )
      ),
    ));
  }

  Widget malaKategorija(String naziv, int flag){
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      padding: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
      child:Row(children: <Widget>[
        Text(naziv),
        SizedBox(width: 7.0,),
        Column(children: <Widget>[
          SizedBox(
            height:20.0,
            width:20.0,
            child:
              IconButton(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              alignment: AlignmentDirectional.center,
              iconSize:20.0,
              onPressed: (){
                setState(() {
                  if(flag == 0){
                    odabraneKategorije.removeAt(imenaOdabranihKategorija.indexOf(naziv));
                    imenaOdabranihKategorija.remove(naziv);
                  }else{
                    odabraneLepeKategorije.removeAt(imenaOdabranihLepihKategorija.indexOf(naziv));
                    imenaOdabranihLepihKategorija.remove(naziv);
                  }
                });
              },
              icon: Icon(Icons.cancel)
            ),
          ),
        ],)
        
        
      ],),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }

  Widget buildText(String str){
    return Text(
      str,
      style:gf.GoogleFonts.ubuntu(),
    );
  }

  void _nemaKategorijeDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Obaveštenje'),
            content: buildText('Morate odabrati kategoriju objave.'),
            actions: <Widget>[
              FlatButton(
                child: buildText('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _nemaLokacijeDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Obaveštenje'),
            content: buildText('Žao nam je ali došlo je do greške, aplikacija nije uspela da nadje Vašu lokaciju, proverite da li je lokacija na uređaju uključena, pa pokušajte ponovo.'),
            actions: <Widget>[
              FlatButton(
                child: buildText('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _nemaGradaDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Obaveštenje'),
            content: buildText('Morate odabrati grad na koji će se objava odnositi. Grad se bira u delu "Odabir lokacije", problem je najverovarnije nastao zato što je lokacija na uređaju najverovatnije isključena. Odaberite grad i pokušajte ponovo.'),
            actions: <Widget>[
              FlatButton(
                child: buildText('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _nemaTekstaDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Obaveštenje'),
            content: buildText('Morate uneti neki tekst ukoliko niste uneli sliku.'),
            actions: <Widget>[
              FlatButton(
                child: buildText('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void obavestenjeZaObjavu() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Uspešno!'),
            content: buildText('Molimo sačekajte koji trenutak, objava je uspešno izbačena.'),
            actions: <Widget>[
              FlatButton(
                child: buildText('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget listKategorija()
  {
    return new SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child:Row(children: imenaOdabranihKategorija.map((ime) => malaKategorija(ime,0)).toList())
    ) ;
  }

  Widget listLepeKategorija()
  {
    return new SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child:Row(children: imenaOdabranihLepihKategorija.map((ime) => malaKategorija(ime,1)).toList())
    ) ;
  }

  void _handleRadioChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  void radioButtonChanges(int value) {
    setState(() {
      _radioProblemi = value;
    });
  }

  List<DropdownMenuItem<Grad>> buildDropdownMenuItems(List _gradovi) {
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

  List<DropdownMenuItem<KategorijaObjave>> buildDropdownMenuItemsKategorije(List _kategorije) {
    List<DropdownMenuItem<KategorijaObjave>> items = List();
    for (KategorijaObjave kategorija in _kategorije) {
      items.add(
        DropdownMenuItem(
          value: kategorija,
          child: Text(kategorija.kategorija),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<LepeKategorije>> buildDropdownMenuItemsLepeKategorije(List _kategorije) {
    List<DropdownMenuItem<LepeKategorije>> items = List();
    for (LepeKategorije kategorija in _kategorije) {
      items.add(
        DropdownMenuItem(
          value: kategorija,
          child: Text(kategorija.kategorija),
        ),
      );
    }
    return items;
  }



  Future<String> dajTrenutniGrad() async {
    final coordinates = new Coordinates(latitude, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    String gradic = first.locality;
    return gradic;
  }

   void dajGradove() {
    servis.dajGradove().then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        gradovi = list.map((model) => Grad.fromObject(model)).toList();
        dajPoziciju();
      });
    });
  }

  void dajKategorije() {
    servis.fetchKategorije().then((response){
      print(response.body);
      Iterable list = json.decode(response.body);
      setState(() {
        kategorije = list.map((model) => KategorijaObjave.fromObject(model)).toList();
        selectedKategorija = kategorije[0];
      });
    });
  }

  void dajLepeStvari() {
    servis.fetchLepeStvari().then((response){
      print(response.body);
      Iterable list = json.decode(response.body);
      setState(() {
        lepeKategorije = list.map((model) => LepeKategorije .fromObject(model)).toList();
        selectedLepeKategorije = lepeKategorije[0];
      });
    });
  }


}
