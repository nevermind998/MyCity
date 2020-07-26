import 'package:flutter/material.dart';
import 'package:mob_app/screens/BottomBar.dart';
import 'package:mob_app/screens/RegistrationPage.dart';
import 'package:mob_app/screens/SplahScreen.dart';
import './screens/TextPage.dart';
import './screens/HomePage.dart';
import './screens/CameraPage.dart';
import './screens/ProfilePage.dart';
import './screens/SearchPage.dart';
import './screens/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
    home:MySplash(),
    //home:MyBottomBar(),
      theme: ThemeData(
        primaryColor: Color(0xFF49c486),
      ),
    );
  }
}