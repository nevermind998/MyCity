import 'dart:convert';
import 'dart:html';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:webApp/models/Korisnik.dart';
import 'package:webApp/screens/AppBarPage.dart';
import 'dart:html' as html;
import 'package:webApp/services/api_services.dart';

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
  final key = GlobalKey<FormState>();
  Korisnik user;
  bool flag=true;
  double sirina;

  bool pass=false;

  initState() {
    /*
    try {
      if(html.window.sessionStorage["adminUloga"]=="admin" || html.window.sessionStorage["adminUloga"]=="superuser")
      {
        Navigator.pushNamed(context, "/appbarWeb");
      }
    } on Exception catch (exception) {
      CircularProgressIndicator();
    } catch (error) {
      CircularProgressIndicator();
    }
*/
    novaController.text="";
    super.initState();

  }

  FocusNode _textNode = new FocusNode();
  FocusNode _textNode1 = new FocusNode();

  fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _login()
  {
    var bytes = utf8.encode(passwordController.text);
    var digest = sha1.convert(bytes);

    var body = jsonEncode({
      "username" : usernameController.text,
      "password" : digest.toString()
    });

    api_services().login(context, body);

  }


  Widget build(BuildContext context) {
    sirina=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body:  SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical:(sirina/200)),
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
                          style:TextStyle(fontSize:15+sirina/250,fontWeight: FontWeight.bold)
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
                            /*
                            focusNode:_textNode,
                          onFieldSubmitted: (term){
                            fieldFocusChange(context, _textNode, _textNode1);
                          },
                          */
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
                            controller: passwordController,
                            focusNode:_textNode1,
                            onFieldSubmitted: (term){
                               _textNode1.unfocus();
                               _login();
                            },
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

/*
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        width: sirina/(sirina/320),
                        height: 50.0,
                        child: TextFormField(
                          onFieldSubmitted: ,
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
*/
                    Container(
                      width: 260,
                      height: 60,
                      alignment: Alignment.center,
                      child:RaisedButton(
                        elevation: 5.0,
                        onPressed: () {
                          _login();
                        },
                        padding: EdgeInsets.only(left:28.0,top: 10.0,right:28.0,bottom:10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.greenAccent[700],
                        child: Text(
                          'Prijava',
                          style: TextStyle(
                            color: Color(0xEEFFFFFF),
                            letterSpacing: 1.5,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
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
                      width: sirina/2.4,
                      alignment: Alignment.center,
                      child:Text("Moj Grad",
                          style:TextStyle(fontSize: 30+sirina/250,fontWeight: FontWeight.bold)
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
