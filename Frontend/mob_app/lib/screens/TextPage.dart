import 'dart:convert';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mob_app/Map/prikaz_mape.dart';
import 'package:mob_app/Map/prikaz_mape2.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:mob_app/models/TekstualnaObjava.dart';
import 'package:mob_app/models/TipObjave.dart';
import '../screens/HomePage.dart';
import '../screens/BottomBar.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:mob_app/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Grad.dart';

class TextPage extends StatefulWidget {
  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  double latitude;
  double longitude;
  List<Grad> gradovi;
  Grad selected;
  api_services servis = api_services();

    String token = '';
    Korisnik user;

    getToken() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String _token = preferences.getString('token');
      Map<String, dynamic> jsonObject = json.decode(preferences.getString('user'));
      Korisnik extractedUser = new Korisnik();
      extractedUser = Korisnik.fromObject(jsonObject);
      setState(() {
        token = _token;
        user = extractedUser;
      });
  }


  initState(){
    super.initState();
    getToken();
  }

  void setPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
  }

  Future<Position> _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  void dajPoziciju() {
    Future<Position> _position = servis.getCurrentLocation().then((value) {
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
      });
      dajTrenutniGrad().then((naziv_grada) {
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

  @override
  Widget build(BuildContext context) {
    if(user == null){
      return Center(child:Container(child: new CircularProgressIndicator(),padding: EdgeInsets.all(10.0),));
    }
    if(gradovi == null){
      dajGradove();
      return Center(child:Container(child: new CircularProgressIndicator(),padding: EdgeInsets.all(10.0),));
    }
    print(user.prezime);
    double _width_of_screen = MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width / 10;

    var _textController = TextEditingController();

    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          "Text page",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          SizedBox(height: 15.0),
          Center(
              child: SizedBox(
                  width: _width_of_screen,
                  child: TextFormField(
                    controller: _textController,
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    cursorWidth: 2.0,
                    autofocus: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Post something...",
                        labelText: 'Text'),
                    maxLines: 6,
                  ))),
          Row(
            children: <Widget>[
              RaisedButton(
                textColor: Colors.white,
                color: Colors.greenAccent[700],
                child: Text('Post'),
                onPressed: () {
                  //servis.newTextPost(_textController.text, user.id, selected, context);
                },
              ),
              Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 40.0, 0.0))
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
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
    );
  }
}
