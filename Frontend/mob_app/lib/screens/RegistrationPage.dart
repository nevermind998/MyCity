import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:location_permissions/location_permissions.dart';

import 'dart:ui';
import 'loginPage.dart';
import '../services/api_services.dart';
import '../models/Grad.dart';

class MyRegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<MyRegistrationPage> {
  @override
  Grad selected;
  bool greska_kod_registrovanja = false;
  List<Grad> gradovi;
  double visina = 40;
  double sirina = 250;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  api_services servis = api_services();
  double latitude;
  double longitude;
  int grad_pom = 0;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordAgainController = TextEditingController();
  TextEditingController _imeController = TextEditingController();
  TextEditingController _prezimeController = TextEditingController();
  TextEditingController _kontaktController = TextEditingController();
  TextEditingController _biografijaController = TextEditingController();
  TextEditingController _gradController = TextEditingController();

  @override
  initState(){
    // TODO: implement initState
    super.initState();
    PermissionHandler().requestPermissions([PermissionGroup.location]).then((value){
      print('usao ovde' + value.toString());
    });
    //setPermissions();
    //dozvole();
  }

  /*dozvole() async {
    PermissionStatus permission = await LocationPermissions().requestPermissions();
  }*/

  void dajPoziciju() {
    Future<Position> _position = servis.getCurrentLocation().then((value) {
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
      });
      dajTrenutniGrad().then((nazivGrada) {
        setState(() {
          grad_pom = 1;
        });
        //print(nazivGrada);
        gradovi.forEach((element) {
          if (element.naziv_grada_cir == nazivGrada) {
            setState(() {
              selected = element;
            });
          }
        });
        if (selected == null) {
          selected = gradovi[0];
        }
        print(selected.naziv_grada_lat);
      });
    });
  }

  Future<String> dajTrenutniGrad() async {
    final coordinates = new Coordinates(latitude, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    print('Grad je ' + first.locality);
    String gradic = first.locality;
    return gradic;
  }

   /*void setPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);

  }*/

  Widget _buildIme() {
    return Container(
      width: sirina,
      child: TextFormField(
        style: gf.GoogleFonts.ubuntu(),
        textCapitalization: TextCapitalization.sentences,
        controller: _imeController,
        decoration: InputDecoration(
          prefixIcon: Padding(
              child: Icon(Icons.account_circle, size: 30.0),
              padding: EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintText: 'Unesite ime...',
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return "Nije uneto ime";
          }
          if (!RegExp("^[A-ZŠĐČĆŽ][A-Za-zŠšĐđŽžČčĆć]{1,}").hasMatch(value)) {
            return "Ime moz+že sadržati samo slova i mora počinjati velikim slovom";
          }
          return null;
        },
        onSaved: (String value) {},
      ),
    );
  }

  Widget _buildPrezime() {
    return Container(
      width: sirina,
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: _prezimeController,
        decoration: InputDecoration(
          prefixIcon: Padding(
              child: Icon(Icons.account_circle, size: 30.0),
              padding: EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
       /*   hintText: 'Unesite prezime...',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),*/
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return "Nije uneto prezime!";
          }
          if (!RegExp("^[A-ZŠĐČĆŽ][A-Za-zŠšĐđŽžČčĆć]{1,}").hasMatch(value)) {
            return "Prezime moze sadržati samo slova i mora počinjati velikim slovom";
          }
          return null;
        },
        onSaved: (String value) {},
      ),
    );
  }

  Widget _buildKontakt() {
    return Container(
      width: sirina,
      child: TextFormField(
        controller: _kontaktController,
        decoration: InputDecoration(
          prefixIcon: Padding(
              child: Icon(Icons.account_circle, size: 30.0),
              padding: EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
         /* hintText: 'Unesite e-mail...',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),*/
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return "Nije unet e-mail";
          }else if(
            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9šđžčć.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)
          ){
            return "E-mail adresa nije validna";
          }
          else{
          return null;
          }
        },
        onSaved: (String value) {},
      ),
    );
  }

  Widget _buildBiografija() {
    return Container(
      width: sirina,
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: _biografijaController,
        decoration: InputDecoration(
          prefixIcon: Padding(
              child: Icon(Icons.account_circle, size: 30.0),
              padding: EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintText: 'O Vama...',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        validator: (String value) {
          return null;
        },
        onSaved: (String value) {},
      ),
    );
  }

  Widget _buildGrad() {
    return Container(
      width: sirina,
      child: TextFormField(
        controller: _gradController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return "Nije unet Grad!";
          }
          if (!RegExp("^[A-Z][a-z]{1,}").hasMatch(value)) {
            return "Niste lepo uneli grad!";
          }
          return null;
        },
        onSaved: (String value) {},
      ),
    );
  }

  Widget _buildKorisnickoIme() {
    return Container(
      width: sirina,
      child: TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          prefixIcon: Padding(
              child: Icon(Icons.account_circle, size: 30.0),
              padding: EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
         /* hintText: 'Unesite korisnicko ime...',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),*/
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return "Nije uneto korisničko ime";
          }
          if (!RegExp("^[A-ZŠĐŽČĆa-zšđžčć0-9._]{1,}").hasMatch(value)) {
            return "Korisničko ime može sadržati samo slova i brojeve";
          }
          return null;
        },
        onSaved: (String value) {},
      ),
    );
  }

  Widget _buildSifra() {
    return Container(
      width: sirina,
      child: TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Padding(
              child: Icon(Icons.account_circle, size: 30.0),
              padding: EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
       /*   hintText: 'Unesite lozinku...',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),*/
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return "Nije uneta šifra";
          }
          if (value.length < 6) {
            return "Šifra mora imati više od 6 karaktera";
          }
          _formKey.currentState.save();
          return null;
        },
        onSaved: (String value) {},
      ),
    );
  }

  Widget _buildSifraPonovo() {
    return Container(
      width: sirina,
      child: TextFormField(
        controller: _passwordAgainController,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Padding(
              child: Icon(Icons.account_circle, size: 30.0),
              padding: EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
        /*  hintText: 'Unesite ponovo lozinku...',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),*/
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        validator: (String value) {
          if (value != _passwordController.text) {
            return "Šifre se ne poklapaju";
          } else {
            if (value.isEmpty) {
              return "Nije uneta šifra";
            }
            if (value.length < 6) {
              return "Šifra mora imati više od 6 karaktera";
            }
            return null;
          }
        },
        onSaved: (String value) {},
      ),
    );
  }

  Widget _buildText(String str, double size) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          str,
          style: gf.GoogleFonts.ubuntu(fontSize: size),
        ));
  }

  Widget _buildDugmeZaRegistraciju() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5.0),
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          textColor: Colors.white,
          color: Colors.green,
          child: _buildText("Registruj se", 16),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (!_formKey.currentState.validate()) {
              return null;
            } else if(selected == null){
              _showDialogObavestenje('Morate odabrati neki grad.', context);
            }  
            else{
              visina = 30;
              _formKey.currentState.save();
              var bytes = utf8.encode(_passwordController.text);
              var crypto_password = sha1.convert(bytes);

              var body = jsonEncode({
                "korisnik": {
                  "ime": _imeController.text,
                  "prezime": _prezimeController.text,
                  //"Grad": selected.naziv ,
                  "biografija": _biografijaController.text,
                  "email": _kontaktController.text,
                  "username": _usernameController.text,
                  "password": crypto_password.toString()
                },
                "idGradova": [selected.id]
              });
              Fluttertoast.showToast(
                    msg: "Samo trenutak...",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xFF49c486),
                    textColor: Colors.white,
                    fontSize: 16.0
                );

              api_services().registration(body, context).then((value) {
                if(value.statusCode == 403){
                  _showDialogObavestenje('E-mail adresu je već postoji, odaberite drugu.', context);
                }else if(value.statusCode == 204){
                  _showDialogObavestenje('Korisničko ime je zauzeto, odaberite drugo.', context);
                }else{
                  
                  int kod = int.parse(value.body);

                  print('kod je ' + value.body.toString());
                  print('response body je ' + value.body);
                  print('status je ' + value.statusCode.toString());

                  _showDialog(kod, _kontaktController.text, body);
                }
              });
            }
          }),
    );
  }

  void _showDialogObavestenje(String text, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText2('Obaveštenje'),
            content:
                buildText2(text),
            actions: <Widget>[
              FlatButton(
                child: buildText2('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

   Widget buildText2(String str) {
    return Text(
      str,
      style: gf.GoogleFonts.ubuntu(),
    );
  }

  void _showDialog(int kod, String email, String body) {
    TextEditingController _kodController = TextEditingController();
    bool greska = false;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
            return AlertDialog(
              title: Text('Potvrdite kod'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      child: Text('Na email adresu: ' +
                          email +
                          ' Vam je stigao kod, unesite kod u formu ispod.')),
                  Container(
                      child: TextFormField(
                    controller: _kodController,
                  )),
                  greska == true ? Text('Pogrešan kod', style:gf.GoogleFonts.ubuntu(
                    color: Colors.red,
                    fontSize: 10
                  )) : SizedBox(height: 5.0)
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Odustani'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Potvrdi'),
                  onPressed: () {
                    if (_kodController.text == kod.toString()) {
                      print('dobro');
                      servis.sacuvajKorisnika(body, context).then((value) {
                        Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context) => MyLoginPage()),
                        (Route<dynamic> route) => false);
                        //Navigator.of(context).pop();
                        /*Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => MyLoginPage()));*/
                        //Navigator.of(context).pop();
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyLoginPage()));*/
                      });
                    } else {
                      setState(() {
                        greska = true;
                      });
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Widget _buildDugmeZaVracanje() {
    return Container(
      padding: const EdgeInsets.all(5.0),
      alignment: Alignment.center,
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          textColor: Colors.white,
          color: Colors.green,
          child: _buildText("Nazad na prijavu", 16),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyLoginPage()),
            );
          }),
    );
  }

  List<DropdownMenuItem<Grad>> buildDropdownMenuItems(List _gradovi) {
    List<DropdownMenuItem<Grad>> items = List();
    for (Grad grad in _gradovi) {
      items.add(
        DropdownMenuItem(
          value: grad,
          child: Text(
            grad.naziv_grada_lat,
            style: gf.GoogleFonts.ubuntu(),
          ),
        ),
      );
    }
    return items;
  }

  Widget _buildSlika(String str, double visina, double sirina) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 1.0),
      child: Image.asset(str, height: visina, width: sirina),
    );
  }

  void dajGradove() {
    print('usao');
    servis.dajGradove().then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        gradovi = list.map((model) => Grad.fromObject(model)).toList();
        dajPoziciju();
      });
    });
  }

  Widget build(BuildContext context) {
    if (gradovi == null) {
      dajGradove();
    }

    return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text("Registracija",
                  style: gf.GoogleFonts.ubuntu(color: Colors.white)),
              centerTitle: true,
            ),
            body: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildSlika('images/logo_aplikacija.png', 150.0, 100.0),
                      _buildText("Moj Grad", 20.0),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildText("Ime:", 15),
                      _buildIme(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildText("Prezime:", 15),
                      _buildPrezime(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildText("Kontakt:", 15),
                      _buildKontakt(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildText("O Vama:", 15),
                      _buildBiografija(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildText("Grad:", 15),
                          SizedBox(
                            width: 20.0,
                          ), /*gradovi == null || latitude == null*/ grad_pom == 0
                          ? Column(
                            children: <Widget>[
                              SizedBox(height:10),
                              CircularProgressIndicator(),
                              SizedBox(height:10),
                              Container(
                                alignment:Alignment.center,
                                width:300,
                                child:Text('Nalaženje Vaše lokacije je u toku, proverite da li je lokacija na uređaju uključena, ukoliko nalaženje Vaše lokacije potraje preporučujemo da sami odaberete grad. Da li želite sami da odaberete grad bez preporuke aplikacije?',
                                textAlign: TextAlign.center,)
                              ),
                              Container(child:
                                  IconButton(
                                    icon: Icon(
                                      Icons.check_circle_outline,
                                      size:30,
                                      color:Colors.green
                                      ),
                                    onPressed: (){
                                      if(gradovi != null){
                                        setState(() {
                                          grad_pom = 1;
                                          selected = gradovi[0];
                                        });
                                      }else{
                                        Fluttertoast.showToast(
                                          msg: "Došlo je do greške prilikom prikupljanja gradova iz baze podataka, molimo pokušajte za koji trenutak ponovo. Hvala.",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Color(0xFF49c486),
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                      }
                                    },
                                  )
                              )
                            ],
                          ) 
                          : 
                          new DropdownButton(
                              items: buildDropdownMenuItems(gradovi),
                              value: selected,
                              onChanged: (value) {
                                setState(() {
                                  selected = value;
                                });
                              }),
                        ],
                      ),
                      _buildText("Korisničko ime:", 15),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildKorisnickoIme(),
                      SizedBox(
                        height: 10.0,
                      ),
                      greska_kod_registrovanja == true
                          ? _buildText("Korisničko ime je već zauzeto.", 16)
                          : Container(),
                      _buildText("Unesite lozinku:", 15),
                      _buildSifra(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildText("Unesite lozinku ponovo:", 15),
                      _buildSifraPonovo(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildDugmeZaRegistraciju(),
                      _buildDugmeZaVracanje(),
                      _buildSlika('images/logo_tima.png', 80.0, 50.0),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
