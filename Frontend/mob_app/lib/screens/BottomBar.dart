import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/screens/CameraPage.dart';
import 'package:mob_app/screens/HomePage.dart';
import 'package:mob_app/screens/LoginPage.dart';
import 'package:mob_app/screens/ProfilePage.dart';
import 'package:mob_app/screens/SearchPage.dart';
import 'package:mob_app/screens/TextPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBottomBar extends StatefulWidget {
  int index;
  MyBottomBar(){
    this.index = 0;
  }
  MyBottomBar.withIndex(int _index){
    this.index = _index;
  }
  @override
  _MyBottomBarState createState() => _MyBottomBarState(index);
}

class _MyBottomBarState extends State<MyBottomBar> {
  _MyBottomBarState(index){
    trenIndex = index;
  }
  int trenIndex;
  final List<Widget> _pages=[
    HomePage(),
    SearchPage(),
    CameraPage(),
    ProfilePage(),
  ];

  void onTappedBar(int index)
  {
    setState(() {
      trenIndex=index;
    });
    if(index == 0){
      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context) => MyBottomBar.withIndex(0)),
                        (Route<dynamic> route) => false);
    }
  }

  final PageStorageBucket bucket = PageStorageBucket();

  Color boja = Color(0xFF49c486);
  
  

  Widget build(BuildContext context) {

    void setTrenIndex(int ind){
      this.trenIndex = ind;
    }

    return Scaffold(
      body:_pages[trenIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onTappedBar,
        currentIndex: trenIndex,
        items:[
          BottomNavigationBarItem(
            icon:new Icon(Icons.home),
            title: Container(height:10.0),
            backgroundColor: boja,
          ),

          BottomNavigationBarItem(
            icon:new Icon(Icons.search),
            title: Container(height:10.0),
            backgroundColor: boja,
          ),

          BottomNavigationBarItem(
            icon:new Icon(Icons.camera),
            title: Container(height:10.0),
            backgroundColor: boja,
          ),

          BottomNavigationBarItem(
            icon:new Icon(Icons.person),
            title: Container(height:10.0),
            backgroundColor: boja,
          ),
        ],
      ),
    );
  }
}