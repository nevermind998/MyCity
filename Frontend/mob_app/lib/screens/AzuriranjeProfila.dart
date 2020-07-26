import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mob_app/models/Grad.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:fluttertoast/fluttertoast.dart';


class AzuriranjeProfila extends StatefulWidget {
  _AzuriranjeProfilaState createState() => _AzuriranjeProfilaState();
}

class _AzuriranjeProfilaState extends State<AzuriranjeProfila> {

  Korisnik user;
  api_services servis = api_services();
  TextEditingController _imeController = TextEditingController();
  TextEditingController _prezimeController = TextEditingController();
  TextEditingController _biografijaController = TextEditingController();
  TextEditingController _brojTelefonaController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _novaSifraController = TextEditingController();
  TextEditingController _novaSifra2Controller = TextEditingController();
  TextEditingController _staraSifraController = TextEditingController();
  List<Grad> gradovi = List<Grad>();
  double latitude;
  double longitude;
  Grad selected;
  List<String> gradoviImena = List<String>();
  List<int> noviGradovi = List<int>();
  List<Row> vrste = List<Row>();
  int j=0;
  String novo_ime;
  String novo_prezime;
  String nova_biografija;
  String nov_telefon;
  String novi_username;
  String novaSifra;
  String novaSifra2;
  String staraSifra;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Grad> gradoviKorisnika = List<Grad>();
  Future<File> file;
  File tmpFile;
  String base64Image;
  File pomocniFile;
  File slika;


  void get_localUser() async{
    api_services().getUser().then((value){
      servis.fetchKorisnikaPoId(value.id).then((response){
        String jsonString = '[' + response.body + ']';
        Iterable list = json.decode(jsonString);

        List<Korisnik> pomocna = List<Korisnik>();
        
        pomocna = list.map((model) => Korisnik.fromObject(model)).toList();
        setState(() {
          file = null;
          user = pomocna[0];

          dajGradoveKorisnika();
          /*user.gradovi.forEach((element) {
            noviGradovi.add(element.id);
            gradoviImena.add(element.naziv_grada_lat);
          });*/
          //noviGradovi.addAll(user.gradovi);
          novo_ime = user.ime;
          novo_prezime = user.prezime;

          if(user.biografija != null){
            nova_biografija = user.biografija;
          }else{
            nova_biografija = "";
          }

          if(user.email != null){
            nov_telefon = user.email;
          }else{
            nov_telefon = "";
          }
        });
      });
    });
  }

  void initState() {
    super.initState();
    get_localUser();
    dajGradove();
  }

  void dajGradoveKorisnika() {
    servis.dajGradoveZaKorisnika(user.id).then((response) {
      Iterable list = json.decode(response.body);
      setState(() {
        gradoviKorisnika = list.map((model) => Grad.fromObject(model)).toList();

        gradoviKorisnika.forEach((element) {
          noviGradovi.add(element.id);
          gradoviImena.add(element.naziv_grada_lat);
        });

      });
    });
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

  Future<String> dajTrenutniGrad() async {
    final coordinates = new Coordinates(latitude, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    print('Grad je ' + first.locality);
    String gradic = first.locality;
    return gradic;
  }

   void dajPoziciju() {
    Future<Position> _position = servis.getCurrentLocation().then((value) {
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
      });
      dajTrenutniGrad().then((nazivGrada) {
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

  List<DropdownMenuItem<Grad>> buildDropdownMenuItems(List _gradovi) {
    List<DropdownMenuItem<Grad>> items = List();
    for (Grad grad in _gradovi) {
      items.add(
        DropdownMenuItem(
          value: grad,
          child: Text(grad.naziv_grada_lat, style: gf.GoogleFonts.ubuntu(),),
        ),
      );
    }
    return items;
  }

  Widget maliGrad(String ime){
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      padding: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
      child:Row(children: <Widget>[
        Text(ime),
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
                  noviGradovi.removeAt(gradoviImena.indexOf(ime));
                  gradoviImena.remove(ime);
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

  Widget listaImenaGradova()
  {
    return new SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child:Row(children: gradoviImena.map((ime) => maliGrad(ime)).toList())
    ) ;
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
            var slika = FileImage(
              snapshot.data
            );
            tmpFile = snapshot.data;

          return Flexible(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.0,
                              spreadRadius: 1.0,
                              color: Colors.green,
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                3.0, //down
                              )
                            )
                          ],
                          color:Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image: slika, fit: BoxFit.fill)
                          ),
                          /*,
              child: Image.file(
                snapshot.data,
                fit: BoxFit.fill,
            )*/)
            
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Došlo je do greške prilikom biranja fotografije',
            textAlign: TextAlign.center,
          );
        } else {
          return Text('');
        }
      },
    );
  }

  void _showDialog() {
    file.then((value){
      if(value == null){
        print('ne postoji');
      }else{
        return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Izmena profilne fotografije'),
            content: Column(children: <Widget>[
              Text('Da li ste sigurni da želite da postavite ovu fotografiju kao profilnu?'),
              
              
              showImage()
            ],),
            
            actions: <Widget>[
              FlatButton(
                child: Text('Odustani'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Postavi'),
                onPressed: () {
                  servis.promenaProfilneFotografije(tmpFile);
                  Fluttertoast.showToast(
                    msg: "Izmena slike može da potraje, slika će uskoro biti promenjena za to vreme uživajte u aplikaciji, hvala na razumevanju,",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xFF49c486),
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      }
    });
    
  }

  

  void _showDialogObavestenje(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Obaveštenje'),
            content: Text(text),
            
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }


  Widget build(BuildContext context) {
    if (gradovi == null) {
      dajGradove();
    }

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    double dajProcenatSirine(double broj){
      return _width * broj / 100;
    }

    _imeController.text = novo_ime;
    _prezimeController.text = novo_prezime;
    _biografijaController.text = nova_biografija;
    _brojTelefonaController.text = nov_telefon;

      

      return new Scaffold(
          appBar: new AppBar(
            title: user != null? Text(user.ime +" "+ user.prezime, style: TextStyle(color: Colors.white)): Text(''),
          ),
          body: user == null? Center(child:CircularProgressIndicator()) : SingleChildScrollView(
            child: new Center(
              child: new Form(
                key: _formKey,
             child: new Column(
                children: <Widget>[

                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: 250.0,
                  decoration: BoxDecoration(
                    color: Colors.green[200]
                  ),
                  child: Column(children: <Widget>[
                    Center(
                      child:Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 18.0),
                        alignment: Alignment.bottomRight,
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.0,
                              spreadRadius: 1.0,
                              color: Colors.green,
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                3.0, //down
                              )
                            )
                          ],
                          color:Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image: NetworkImage(api_services.url_za_slike + user.url_slike), fit: BoxFit.fill),
                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 10, 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                          ),
                          child: IconButton(icon: Icon(Icons.edit),
                            onPressed:(){
                              
                              setState(() {
                                file = ImagePicker.pickImage(source: ImageSource.gallery);
                                
                              });
                               _showDialog();
                            }
                          )
                        )
                        
                      )
                    ),
                    Container(child: Text(
                      'Izmena profila',
                      style: gf.GoogleFonts.ubuntu(
                        color: Colors.green[600],
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500
                      )
                    ))

                  ],) 
                ),

                new Container(
                  width: dajProcenatSirine(90),
                  margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.grey,
                        offset: Offset(
                          5.0,
                          5.0
                        ),

                      )
                    ]
                  ),
                  child: Column(children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(left:15.0),
                        child:Text("Ime:",style: new TextStyle(fontSize: 20.0),),
                      ),
                      new Container(
                        margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                          child: new TextFormField(
                            
                            controller: _imeController,
                            onChanged: (String value){
                                novo_ime = value;
                            },
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0))
                              ),
                              hintText: 'Unesite ime',
                            ),
                          ),
                        ),

                        new Container(
                        margin: EdgeInsets.only(left:15.0),
                        child:Text("Prezime:",style: new TextStyle(fontSize: 20.0),),
                        ),
                        new Container(
                        margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                          child: new TextFormField(
                            controller: _prezimeController,
                            onChanged: (String value){
                                novo_prezime = value;
                            },
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0))
                              ),
                              hintText: 'Unesite prezime',
                            ),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(left:15.0),
                          child:Text("O Vama:",style: new TextStyle(fontSize: 20.0),),
                          ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                            child: new TextFormField(
                              
                              controller: _biografijaController,
                              onChanged: (String value){
                                nova_biografija = value;
                            },
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 5.0),
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                                ),
                                hintText: 'O Vama',
                              ),
                              maxLines: 4,
                              minLines: 1,
                              autocorrect: false,
                              autofocus: false,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                  ],)
                ),

                new Container(
                  width: dajProcenatSirine(90),
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.grey,
                        offset: Offset(
                          5.0,
                          5.0
                        ),

                      )
                    ]
                  ),
                  child: Column(children: <Widget>[
                    new Container(
                          margin: EdgeInsets.only(left:0.0),
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          child:Text("Započnite ili prekinite praćenje nekog grada",
                            style: new TextStyle(fontSize: 15.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                        
                        new DropdownButton(
                            items: buildDropdownMenuItems(gradovi),
                            value: selected,
                            onChanged: (value) {
                              setState(() {
                                selected = value;
                                novo_ime = _imeController.text;
                                novo_prezime = _prezimeController.text;
                                nova_biografija = _biografijaController.text;
                                nov_telefon = _brojTelefonaController.text;
                              });
                            }),

                            new Container(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child:IconButton(icon:Icon(
                                  Icons.add_circle_outline,
                                  size: 35.0,
                                  color: Colors.black54
                                ), onPressed: (){

                                if( noviGradovi.firstWhere((element) => element == selected.id, orElse: () => null) == null){
                                  setState(() {
                                    gradoviImena.add(selected.naziv_grada_lat);
                                    noviGradovi.add(selected.id);
                                    novo_ime = _imeController.text;
                                    novo_prezime = _prezimeController.text;
                                    nova_biografija = _biografijaController.text;
                                    nov_telefon = _brojTelefonaController.text;
                                  }); 
                                  print(noviGradovi);
                                }

                              },)
                            ),

                      ],),
                  
                  Container(
                    padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 10.0),
                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: listaImenaGradova()
                  ),
                  ],)
                ),

                Container(
                  width: dajProcenatSirine(90),
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.grey,
                        offset: Offset(
                          5.0,
                          5.0
                        ),

                      )
                    ]
                  ),
                  child: Column(children: <Widget>[
                    new Container(
                          margin: EdgeInsets.only(left:15.0),
                          child:Text("Korisničko ime:",style: new TextStyle(fontSize: 20.0),),
                          ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                            child: new TextFormField(
                              
                              controller: _usernameController,
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 5.0),
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                                ),
                                hintText: 'Korisničko ime',
                              ),
                              minLines: 1,
                            ),
                          ),
                          new Container(
                          margin: EdgeInsets.only(left:15.0),
                          child:Text("Stara lozinka:",style: new TextStyle(fontSize: 20.0),),
                          ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                            child: new TextFormField(
                              obscureText: true,
                              controller: _staraSifraController,
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 5.0),
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                                ),
                                hintText: 'Stara lozinka',
                              ),
                              minLines: 1,
                            ),
                          ),
                    new Container(
                          margin: EdgeInsets.only(left:15.0),
                          child:Text("Nova lozinka:",style: new TextStyle(fontSize: 20.0),),
                          ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                            child: new TextFormField(
                              obscureText: true,
                              controller: _novaSifraController,
                              decoration: new InputDecoration(
                                
                                contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 5.0),
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                                ),
                                hintText: 'Nova lozinka',
                              ),
                              minLines: 1,
                              validator: (String value){
                                if(value != _novaSifra2Controller.text){
                                  return "Sifre se ne poklapaju";
                                }
                                return null;
                              },
                            ),
                          ),
                    new Container(
                          margin: EdgeInsets.only(left:15.0),
                          child:Text("Nova lozinka ponovo:",style: new TextStyle(fontSize: 20.0),),
                          ),
                        new Container(
                          margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                            child: new TextFormField(
                              obscureText: true,
                              controller: _novaSifra2Controller,
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 5.0),
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                                ),
                                hintText: 'Nova lozinka ponovo',
                              ),
                              minLines: 1,
                              validator: (String value){
                                if(value != _novaSifraController.text){
                                  return "Sifre se ne poklapaju";
                                }
                                return null;
                              },
                            ),
                          ),
                    
                  ],)
                ),

                
                  

                  new Container(
                    margin: EdgeInsets.all(15.0),
                    child:new RaisedButton(
                      onPressed: (){
                        if (!_formKey.currentState.validate()) {
                          return null;
                        } else if(noviGradovi.length == 0){
                          _showDialogObavestenje('Morate da pratite barem jedan grad');
                        } else if((_usernameController.text!="" && _staraSifraController.text =="") || (_novaSifraController.text!="" && _staraSifraController.text =="")){
                          _showDialogObavestenje('Ako ste uneli korisničko ime ili novu šifru morate uneti i trenutnu šifru');
                        }else{
                          String _staraSifra = "";
                          String _novaSifra = "";
                          
                          if(_staraSifraController.text!=""){
                            var bytes = utf8.encode(_staraSifraController.text);
                            var digest = sha1.convert(bytes);
                            _staraSifra = digest.toString();
                          }
                          if(_novaSifraController.text!=""){
                            var bytes = utf8.encode(_novaSifraController.text);
                            var digest = sha1.convert(bytes);
                            _novaSifra = digest.toString();
                          }

                          var body = jsonEncode({
                            "korisnik":{
                              "id" : user.id,
                              "ime" : _imeController.text!=""? _imeController.text: null,
                              "prezime": _prezimeController.text!=""? _prezimeController.text: null,
                              "biografija": _biografijaController.text!=""? _biografijaController.text: null,
                              "username": _usernameController.text!=""? _usernameController.text: null,
                              "password": _staraSifraController.text!=""? _staraSifra: null
                            },
                            "newPassword": _novaSifra,
                            "idGradova": noviGradovi
                          });
                          print(body);

                          servis.azurirajPodatke(context,body,user);
                        }
                      },
                      child: Text("Izmeni podatke"),
                    )
                  )
                ],
              )
              )
            ),
          )
        );
  }
}