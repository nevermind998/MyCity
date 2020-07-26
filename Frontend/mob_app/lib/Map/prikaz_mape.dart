import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:mob_app/screens/OdvojenaObjava.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:permission_handler/permission_handler.dart';

class Mapa2 extends StatefulWidget {
  @override
  _Mapa2State createState() => new _Mapa2State();
}

class _Mapa2State extends State<Mapa2> {

  int potvrda = 0;
  Position _pozicija;
  Position trenutna_pozicija;
  int k = 0;
  api_services servis = api_services();
  List<Marker> marker = List<Marker>();
  Address _adresa;

  initState() {
    super.initState();
    setPermissions();
    dajPoziciju().then((value) {
      setState(() {
        trenutna_pozicija = value;
        _pozicija = value;
        marker.add(new Marker(
            height: 45.0,
            width: 45.0,
            point: new LatLng(value.latitude, value.longitude),
            builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45.0,
                    onPressed: () {},
                  ),
                )));
      });
    });
  }

  Future<Address> dajAdresu(double lat, double lon) async {
    final coordinates = new Coordinates(lat, lon);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    //print(first.addressLine);
    String gradic = first.locality;
    return first;
  }

  Widget vratiAdresu(double latitude, double longitude){
    if(_adresa == null){
      dajAdresu(latitude, longitude).then((value){
        setState(() {
          _adresa = value;
          print(_adresa.addressLine);
        });
      });
      return new CircularProgressIndicator();
    }else{
      return Text(_adresa.addressLine);
    }
  }

  Future dialog(double latitude, double longitude){
    dajAdresu(latitude, longitude).then((value){
        prikaziDialog(value.addressLine, latitude, longitude).then((value){
          setState(() {
            _pozicija = Position(latitude: latitude, longitude:longitude);
          });
        });
      });
  }

  Future<Dialog> prikaziDialog(String adresa, double latitude, double longitude) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(adresa),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Container(
                          child: RaisedButton(
                        child: Text('Nazad'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                      Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: RaisedButton(
                            color: Colors.lightGreen,
                            child: Text('Postavi marker', style: TextStyle(color: Colors.white),),
                            onPressed: () {
                              marker[0] = new Marker(
                                height: 45.0,
                                width: 45.0,
                                point: new LatLng(latitude, longitude),
                                builder: (context) => new Container(
                                      child: IconButton(
                                        icon: Icon(Icons.location_on),
                                        color: Colors.red,
                                        iconSize: 45.0,
                                        onPressed: () {},
                                      ),
                                    ));
                              Navigator.of(context).pop();
                            },
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
          ;
        });
  }

  Future<Dialog> potvrdiDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              child: Container(
                height: 69,
                child:Column(children: <Widget>[
                Text('Da li želite da potvrdite lokaciju?'),
                Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.lightGreen,
                    child: Text('Da', style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      setState(() {
                        potvrda = 1;
                      });
                      Navigator.of(context).pop();
                    },
                  ),SizedBox(width:20),
                  RaisedButton(
                    child: Text('Ne'),
                    onPressed: (){
                      setState(() {
                        potvrda = 0;
                      });
                      Navigator.of(context).pop();
                    },
                    
                  )
                ]
              ),
              ],)
            ),
          ));
          ;
        });
  }

  Future<Position> dajPoziciju() async {
    Position pozicija = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return pozicija;
  }

  void setPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
  }

  @override
  Widget build(BuildContext context) {
    return trenutna_pozicija == null
        ? new MaterialApp(
          debugShowCheckedModeBanner: false,
          home:new Scaffold(
            body:Center(child:Container(
              child:Container(
                  height: 65, width: 65, child: CircularProgressIndicator()))
          ))
        ) 
        : new MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primaryColor: Colors.greenAccent[700]),
            home: new Scaffold(
                appBar: new AppBar(title: new Center(child:Text('Mapa', style: TextStyle(color:Colors.white),))),
                body: new FlutterMap(
                    options: new MapOptions(
                        onTap: (value) {
                          dialog(value.latitude, value.longitude);
                          
                          //build(context);
                        },
                        center: new LatLng(trenutna_pozicija.latitude,
                            trenutna_pozicija.longitude),
                        minZoom: 2.0),
                    layers: [
                      new TileLayerOptions(
                          urlTemplate:
                              "https://api.mapbox.com/styles/v1/nikolakgvaske/ck8ghw9h20rha1iqp4pz7u90c/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoibmlrb2xha2d2YXNrZSIsImEiOiJjazhnaHFibzAwMWR3M2ducmY0ejE5YmY4In0.nIpba--ah-mEyGJNgc2Xhg",
                          additionalOptions: {
                            'accessToken':
                                'pk.eyJ1Ijoibmlrb2xha2d2YXNrZSIsImEiOiJjazhnaHFibzAwMWR3M2ducmY0ejE5YmY4In0.nIpba--ah-mEyGJNgc2Xhg',
                            'id': 'mapbox.mapbox-streets-v8'
                          }),
                      new MarkerLayerOptions(markers: marker)
                    ]),
                    
                floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          potvrdiDialog().then((value){
                            if(potvrda == 1){
                             print(_pozicija.latitude.toString() + ' ' + _pozicija.longitude.toString());
                             String odgovor = _pozicija.latitude.toString() + ' ' + _pozicija.longitude.toString();
                              Navigator.pop(context, odgovor);
                            }else{
                              Navigator.pop(context,'nista');
                            }
                          });
                        },
                        child: Icon(Icons.arrow_back),
                        backgroundColor: Colors.greenAccent[700],
                      ),
                
                
                ),
          );
  }
}
