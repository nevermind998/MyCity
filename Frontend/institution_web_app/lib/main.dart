import 'dart:ui';

import 'package:flutter/material.dart';

import 'screens/appBarPage.dart';
import 'screens/homePage.dart';
import 'screens/loginPage.dart';
import 'screens/registracijaPage.dart';


void main() {
  runApp(MyAppless());
}

class MyAppless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Moj Grad',
        routes:<String,WidgetBuilder>{
          '/homeWeb' : (BuildContext context) => new HomePage(),
          '/appbarWeb' : (BuildContext context) => new AppBarPage(),
          '/loginWeb' : (BuildContext context) => new LoginPage(),
          '/registracijaWeb' : (BuildContext context) => new RegistrationPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: LoginPage()
    );
  }
}

