import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:mob_app/screens/OdvojenaObjava.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart' as gf;

class Mapa extends StatefulWidget {
  List<Objava> objave;
  Mapa(List<Objava> _objave) {
    this.objave = _objave;
  }
  @override
  _MapaState createState() => new _MapaState(objave);
}

class _MapaState extends State<Mapa> {
  Position trenutna_pozicija;
  List<Objava> objave;
  List<Map<String, double>> pozicije = List<Map<String, double>>();
  int k = 0;
  List<Marker> markeri = List<Marker>();
  List<int> indexObjava = List<int>();
  api_services servis = api_services();
  Objava pritisnutaObjava;

  initState(){
    super.initState();
    setPermissions();
    dajPoziciju().then((value) {
      setState(() {
        trenutna_pozicija = value;
      });
    });

  }

  _MapaState(List<Objava> _objave) {
    this.objave = _objave;
    for (int i = 0; i < objave.length; i++) {
      if (objave[i].latitude != null) {
        indexObjava.add(i);
        pozicije.add(
            {"latitude": objave[i].latitude, "longitude": objave[i].longitude});
      }
    }

    markeri = napraviMarkere();
  }

  Widget buildText(String str){
    return Text(
      str,
      style:gf.GoogleFonts.ubuntu(),
    );
  }

  Future<Dialog> prikaziDialog(Objava o) {
    Widget slika;
    if(o.vlasnik.url_slike != null){
      slika = Container(
        width: 50.0,
        height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(api_services.url_za_slike + o.vlasnik.url_slike,
            ),fit:BoxFit.fill)
            
          ),
        );
    }else{
      slika = Icon(Icons.account_circle, size:25.0);
    }
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: slika
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(children: <Widget>[
                          Text('@' + o.vlasnik.username, style: gf.GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                          buildText(o.vlasnik.ime + ' ' + o.vlasnik.prezime,)
                        ],),
                        
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: o.tekstualna_objava != null
                        ? buildText(o.tekstualna_objava.tekst)
                        : Column(children: <Widget>[
                          buildText(o.slika.opis_slike),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            height: 100.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(
                                    2.0,
                                    2.0
                                  ) 
                                )
                              ]
                            ),
                            child:Image.network(
                              api_services.url_za_slike + o.slika.urlSlike,
                          ))
                          
                        ],
                         ),
                  ),
                  RaisedButton(child: Text('Idi na objavu',style: gf.GoogleFonts.ubuntu(color: Colors.white),),onPressed: (){
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OdvojenaObjava(o)
                                /*prikazMape(latitude, longitude)*/));
                  },color: Colors.lightGreen,)
                ],
              ),
            ),
          );
        });
  }

  List<Marker> napraviMarkere() {
    k = 0;
    int pom = 0;
    List<Marker> _markeri = List<Marker>();
    Marker _marker;
    Objava objava;
    for(var i=0; i<pozicije.length; i++) {
      _marker = new Marker(
          width: 45.0,
          height: 45.0,
          point: new LatLng(pozicije[i]['latitude'], pozicije[i]['longitude']),
          builder: (context) => new Container(
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.red,
                  iconSize: 45.0,
                  onPressed: () {
                    prikaziDialog(objave[indexObjava[i]]);
                  },
                ),
              ));
      _markeri.add(_marker);
    };
    return _markeri;
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
                appBar: new AppBar(title: new Center(child:Text('Mapa',
                style:gf.GoogleFonts.ubuntu(
                  color: Colors.white
                )))),
                body: new FlutterMap(
                    options: new MapOptions(
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
                      new MarkerLayerOptions(markers: markeri)
                    ]),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back),
                  backgroundColor: Colors.greenAccent[700],
                )),
          );
  }
}
