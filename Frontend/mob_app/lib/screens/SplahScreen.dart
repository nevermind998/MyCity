import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mob_app/screens/BottomBar.dart';
import 'package:mob_app/screens/LoginPage.dart';
import 'package:mob_app/screens/RegistrationPage.dart';
import 'package:mob_app/screens/TextPage.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart' as gf;

class MySplash extends StatefulWidget {
  MySplashState createState() => MySplashState();
}

class MySplashState extends State<MySplash> {
  String token = '';
  api_services servis = new api_services();

  void initState() {
    super.initState();

    //Future.delayed(Duration(seconds: 4), () {
      isLogged().then((value) {
        if (value == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyBottomBar()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyLoginPage()),
          );
        }
      });
   // });
  }

  Future<bool> isLogged() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if(pref.getString('token') == null){
      print('nema nista');
      return false;
    }

    Map<String, dynamic> jsonObject =
          json.decode(pref.getString('user'));
          print('json objext je ' + jsonObject.toString());
      Korisnik extractedUser = new Korisnik();
      Korisnik userBack = new Korisnik();
      extractedUser = Korisnik.fromObject(jsonObject);

      return servis.nepostojeciKorisnik(extractedUser.id).then((value){

      String jsonString = '[' + value.body + ']';
      Iterable list = json.decode(jsonString);

      List<Korisnik> pomocna = List<Korisnik>();
      
      pomocna = list.map((model) => Korisnik.fromObject(model)).toList();
      userBack = pomocna[0];

        print('userBack je ' + userBack.toString());
        print('value body je ' + value.body);
       print('status code je ' +value.statusCode.toString());
       print('token je ' + pref.getString('token'));
       print('mailovi su ' + userBack.email + ', ' + extractedUser.email);
       if (value.statusCode != 200 || userBack.email != extractedUser.email) {
           servis.logOut(extractedUser.id, context);
        return false;
      } else {
        return true;
      }
      });
      

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dobrodošli', style: gf.GoogleFonts.ubuntu(
            color: Colors.white
          ))
        ),
        body: Center(
          child: Text('Molimo sačekajte...', style: gf.GoogleFonts.ubuntu(
            
          ))
        ));
  }
}
