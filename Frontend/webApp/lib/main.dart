import 'package:flutter/material.dart';
import 'package:webApp/screens/AppBarPage.dart';
import 'package:webApp/screens/PostPage.dart';
import 'package:webApp/screens/UserPage.dart';
import 'package:webApp/screens/loginPage.dart';
import 'package:webApp/screens/homePage.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Moj Grad',
        routes:<String,WidgetBuilder>{
          '/homeWeb' : (BuildContext context) => new HomePage(),
          '/loginWeb' : (BuildContext context) => new LoginPage(),
          '/' : (BuildContext context) => new LoginPage(),
          '/userWeb' : (BuildContext context) => new UserPage(),
          '/appbarWeb' : (BuildContext context) => new AppBarPage(),
          '/postWeb' : (BuildContext context) => new AppBarPage(),
          '/appbarWeb/postWeb' : (BuildContext context) => new AppBarPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        //home: LoginPage()
    );
  }
}

