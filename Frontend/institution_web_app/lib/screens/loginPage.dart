import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import '../services/api_services.dart';
import 'registracijaPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController novaController = TextEditingController();
  api_services servis = api_services();
  bool pass=false;

  initState() {
    super.initState();
  }




  void _showDialogZaboravljenaSifra() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Zaboravljena lozinka'),
            content: Container(
              height: 130,
              child: Column(
                children: <Widget>[
                  new Container(
                    width: 270,
                    child: Text('Da bi ste promenili lozinku unesite vase korisničko ime. Dobićete email sa daljim instrukcijama.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left:10,top:15,right: 10,bottom:5),
                    child: SizedBox(
                      width: 270.0,
                      height: 40.0,
                      child: TextFormField(
                        controller: novaController,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: "Korisničko ime",

                        ),
                        maxLines: 1,
                        autocorrect: false,
                        autofocus: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text('Zatvori'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: Text('Potvrdi'),
                onPressed: () {

                  setState(() {
                    if(novaController.text!="")
                    {
                      servis.novaSifra(novaController.text);
                    }

                  });

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  FocusNode _textNode = new FocusNode();
  FocusNode _textNode1 = new FocusNode();

  fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void login()
  {
    var bytes = utf8.encode(passwordController.text);
    var digest = sha1.convert(bytes);

    var body = jsonEncode({
      "username" : usernameController.text,
      "password" : digest.toString()
    });
    api_services().loginInstitution(context, body);
  }


  double sirina;
  Widget build(BuildContext context) {
    sirina=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
        body:  SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical:10+(sirina/200)),
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Container(

                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 200),
                alignment: Alignment.center,
                width: sirina /2,

                child: Column(
                  children: <Widget>[
                     Container(
                      child: Text("Za pristup aplikaciji Moj grad morate biti prijavljeni.",
                      style:gf.GoogleFonts.ubuntu(color:Color.fromRGBO(42, 184, 115, 1),fontSize:18+sirina/250,fontWeight: FontWeight.bold)
                        ),
                    ),
                  SizedBox(
                    height: 30,
                  ),
                         Container(
                          child: Container(
                            width: sirina/(sirina/350),
                            height: 50.0,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(

					            controller: usernameController,

                              decoration:  InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Korisničko ime",
                                  ),
                                  maxLines: 1,
                                  autocorrect: false,
                                  autofocus: false,
                            ),
                          ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                         Container(
                           padding: EdgeInsets.symmetric(horizontal: 15),
                          child: SizedBox(
                            width: sirina/(sirina/320),
                            height: 50.0,
                            child: TextFormField(
                              focusNode:_textNode1,
                              onFieldSubmitted: (term){
                                _textNode1.unfocus();
                                login();
                              },
					              controller: passwordController,

                              decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Lozinka",

                                  ),
                                  obscureText: true,
                                  maxLines: 1,
                                  autocorrect: false,
                                  autofocus: false,
                            ),
                          ),
                    ),


                    Container(
                      alignment: Alignment.center,
                        width:sirina/(sirina/500),
                        color: Color.fromRGBO(0, 0, 0, 0),
                        margin: EdgeInsets.only(left: 20),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child:GestureDetector(
                          child: Text("Zaboravljena lozinka?", style: TextStyle(color: Color.fromRGBO(42, 184, 115, 1),fontSize:16+sirina/250,),),
                          onTap: () => _showDialogZaboravljenaSifra(),

                        )
                    ),


                    Container(

                          width: 260,
                          height: 60,
                          alignment: Alignment.center,
                          child:RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              login();
                            },
                            padding: EdgeInsets.only(left:28.0,top: 10.0,right:28.0,bottom:10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color:Color.fromRGBO(42, 184, 115, 1),
                            child: Text(
                              'Prijava',
                              style:  gf.GoogleFonts.ubuntu(color:Colors.white,fontSize: 13+sirina/250,)
                            ),
                          ),
                        ),


                        Container(
                          width: 270,
                          height: 60,
                          alignment: Alignment.center,
                          child:RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegistrationPage()),
                              );
                            },
                            padding: EdgeInsets.only(left:28.0,top: 10.0,right:28.0,bottom:10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color:Color.fromRGBO(42, 184, 115, 1),
                            child: Text(
                              'Registracija',
                              style: gf.GoogleFonts.ubuntu(color:Colors.white,fontSize: 13+sirina/250,)
                            ),
                          ),
                        ),

                  ],
                ),
              ),
               Container(
                 width: sirina/2.3,

                  alignment: Alignment.center,
                    child: Wrap(
                      direction: Axis.vertical,
                      children: <Widget>[
                             Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 50),
                              height: 500,
                              width: sirina/2.3,
                              child:Image.asset('images/logo_aplikacija.jpg', ),
                        ),
                         SizedBox(
                           height: 20,
                         ),

                             Container(
                               width: sirina/2.3,
                               alignment: Alignment.center,
                              child:Text("Moj Grad",
                                  style:gf.GoogleFonts.ubuntu(color:Color.fromRGBO(42, 184, 115, 1),fontSize: 30+sirina/250,fontWeight: FontWeight.bold)
                                  ),
                        ),

                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
    );
  }
}
