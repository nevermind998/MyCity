import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mob_app/models/Dislajk.dart';
import 'package:mob_app/models/KategorijaObjave.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/models/Lajk.dart';
import 'package:mob_app/models/Grad.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:mob_app/screens/BottomBar.dart';
import 'package:mob_app/screens/LoginPage.dart';
import 'package:mob_app/screens/ProfilePage.dart';
import 'package:mob_app/screens/AzuriranjeProfila.dart';
import 'package:mob_app/screens/SplahScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:google_fonts/google_fonts.dart' as gf;

class api_services {

  //local
  /*static String url = "http://192.168.1.6:45455/api";
  static String url_za_slike = "http://192.168.1.6:45455//";*/

  //server_main
  /*static String url = "http://147.91.204.116:2068/api";
  static String url_za_slike = "http://147.91.204.116:2068//";*/

  //server_nas
  static String url = "http://147.91.204.116:2068/api";
  static String url_za_slike = "http://147.91.204.116:2068//";

  final key = GlobalKey<FormState>();
  Korisnik user;
  List<Lajk> lajkovi;
  List<Dislajk> dislajkovi;
  String token;

  String get _url => url;
  String get _urlSlike => url_za_slike;

  api_services(){
    setToken();
  }

  Future setToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString('token')!= null){
      this.token = 'Bearer ' + preferences.getString('token');
    }
  }

  

  void setPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
  }

  Future<Position> getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future fetchTekstualneObjave() async {
    String _url = url + "/TekstualneObjave";
    return await http.get(_url);
  }

  Future fetchKorisnikaPoId(int id) async {
    var url = api_services.url + "/Korisnik/dajKorisnika";

    var body = jsonEncode({"idKorisnika": id});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);
    });
  }

  Future nepostojeciKorisnik(int id) async{
    String _url = api_services.url + "/Korisnik/dajKorisnika";

    var body = jsonEncode({
      "idKorisnika": id
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };

    print('usao vree ' + id.toString());

    return await http.post(_url, headers: header, body: body);

  }

  Future zaboravljenaSifra(String username) async{
    String _url = api_services.url + "/Korisnik/zaboravljenaSifra";

    var body = jsonEncode({
      "username": username
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };

    return await http.post(_url, headers: header, body: body);
  }

  void azurirajPodatke(BuildContext context, String body, Korisnik user) {
    String _url = api_services.url + "/Korisnik/azuriranjeProfila";
    //print(user.id);

    setToken().then((value){

      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    http.post(_url, body: body, headers: header).then((response) {
      print('Ovo je response body ' + response.body);
      print('Status je ' + response.statusCode.toString());

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
      } else if(response.statusCode == 404){
        _showDialog('Pogrešna lozinka, pokušajte ponovo.', context);
      } else if(response.statusCode == 204){
        _showDialog('Korisničko ime već postoji, pokušajte neko drugo.', context);
      }
    });

    });
  }

  Future fetchObjaveZaGrad(List<int> idGrada, int id) async {
    var url = api_services.url + "/Objave/prikaziSveObjaveZaGradove";

    var body = jsonEncode({"idGradova": idGrada, "idKorisnika":id});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);
    });

    
  }

  Future fetchObjave(int id) async {
    var url = api_services.url + "/Objave/prikaziSveObjave";

    var body = jsonEncode({"idKorisnika": id});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);
    });

    
  }

  Future fetchObjaveZaDatum(int id, String vreme) async {
    var url = api_services.url + "/Objave/prikaziObjavaPoGradovimaOdDatuma";

    List<Grad> _gradovi = List<Grad>();
    List<int> _gradoviId = List<int>();

    return dajGradoveZaKorisnika(id).then((response) async {
      Iterable list = json.decode(response.body);
        _gradovi = list.map((model) => Grad.fromObject(model)).toList();
        _gradovi.forEach((element) {
          _gradoviId.add(element.id);
        });

      var body = jsonEncode({"idGradova": _gradoviId, "vreme":vreme, "idKorisnika": id});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);

    });

    
  });

  }

  Future fetchNajpopularnijeObjave(int id) async {
    var url = api_services.url + "/Objave/prikaziNajpopularnijihObjavaPoGradovima";

    List<Grad> _gradovi = List<Grad>();
    List<int> _gradoviId = List<int>();

    return dajGradoveZaKorisnika(id).then((response) async {
      Iterable list = json.decode(response.body);
        _gradovi = list.map((model) => Grad.fromObject(model)).toList();
        _gradovi.forEach((element) {
          _gradoviId.add(element.id);
        });

      var body = jsonEncode({"idGradova": _gradoviId, "idKorisnika":id});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);

    });

    
  });

  }

  Future fetchNajnepopularnijeObjave(int id) async {
    var url = api_services.url + "/Objave/prikaziNajnepopularnijihObjavaPoGradovima";

    List<Grad> _gradovi = List<Grad>();
    List<int> _gradoviId = List<int>();

    return dajGradoveZaKorisnika(id).then((response) async {
      Iterable list = json.decode(response.body);
        _gradovi = list.map((model) => Grad.fromObject(model)).toList();
        _gradovi.forEach((element) {
          _gradoviId.add(element.id);
        });

      var body = jsonEncode({"idGradova": _gradoviId, "idKorisnika": id});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);

    });

    
  });

  }

  Future fetchKategorije() async{
    var url = api_services.url + "/Objave/dajKategorijeProblema";

    var body = '{}';

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };

    return await http.post(url, headers: header, body: body);
  
  }

   Future fetchKategorijeInstitucije(int id) async{
    var url = api_services.url + "/Institucije/dajKategorijeZaInstituciju";

    var body = jsonEncode({
      "idInstitucije":id
    });

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);
    });
  
  }

    Future fetchLepeStvari() async{
    var url = api_services.url + "/Objave/dajLepeStvari";

    var body = '{}';

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);
    });
  
  }

  Future fetchKomentareKaoReseni(int id) async{
    var url = api_services.url + "/Komentari/dajOznaceneKaoReseniProblemiZaObjavu";

    var body = jsonEncode({"idObjave": id});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);
    });
  }

  Future newTextPost(String text , int id, Grad grad, List<int> kategorije, int lepaStvar, BuildContext context) async {
    var url = api_services.url + "/Objave/dodajTekstualnuObjavu";

    var body = jsonEncode({
      "tekst": text, 
      "idKorisnika": id, 
      "idGrada":grad.id,
      "idKategorija": kategorije,
      "LepaStvarID":lepaStvar
    });

    print('body u dodaj post je ' + body);

    setToken().then((value){
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(url, headers: header, body: body).then((response) {
      print(response.body);
      
      /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  MyBottomBar.withIndex(0)),
          );*/

      /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyBottomBar.withIndex(0)
                    /*prikazMape(latitude, longitude)*/));*/
    });
    });
  }

 Future registration(String body,BuildContext context) {
    String url = api_services.url + "/Korisnik/Registracija";
      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json"
      };
      return http.post(url, headers: header, body: body);
  }

  Future sacuvajKorisnika(String body,BuildContext context) {
    String url = api_services.url + "/Korisnik/sacuvajKorisnika";
      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json"
      };
      return http.post(url, headers: header, body: body);
  }


  saveToken(Map<String, dynamic> jsonObject) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', jsonObject['token']);
    await preferences.setString('user', json.encode(jsonObject));
  }

  Future<Korisnik> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> jsonObject =
        json.decode(preferences.getString('user'));
    user = new Korisnik.fromObject(jsonObject);
    print('Ime korisnika u servisu ' + user.ime);
    return user;
  }

  void login(BuildContext context, String body) {
    String url = api_services.url + "/Korisnik/login";

    print(body);

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };
    http.post(url, headers: header, body: body).then((response) {
      print('login: statusCode je ' + response.statusCode.toString());
      if(response.statusCode == 200){
        print(response.body);
        Map<String, dynamic> jsonObject = json.decode(response.body);

        saveToken(jsonObject);

        getUser();
        //var payload = json.decode(ascii.decode(base64.decode(base64.normalize(response.body.split(".")[1]))));
        //print(payload);
        Korisnik logovani_korisnik = new Korisnik();
        logovani_korisnik = Korisnik.fromObject(jsonObject);

        if (response.statusCode == 200) {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyBottomBar()),
          );
         /* Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyBottomBar()));*/
        } else {
          print('netacno');
          /*Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyBottomBar()));*/
        }
    }else{
      _showDialog('Netačno korisničko ime ili lozinka, pokušajte ponovo.', context);
    }
    });
    
  }

  Widget buildText(String str) {
    return Text(
      str,
      style: gf.GoogleFonts.ubuntu(),
    );
  }

  void _showDialog(String text, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Obaveštenje'),
            content:
                buildText(text),
            actions: <Widget>[
              FlatButton(
                child: buildText('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future addLike(int idKorisnika, int idObjave) {
    String _url = url + "/Lajkovi/dodajLajk";

    var body = jsonEncode({"idKorisnika": idKorisnika, "idObjave": idObjave});

    return setToken().then((value){
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url, body: body, headers: header);
    });
  }

  void getLajkovi() {
    String _url = url + "/Lajkovi";
    http.get(_url).then((response) {
      Iterable list = json.decode(response.body);

      lajkovi = list.map((model) => Lajk.fromObject(model)).toList();
      for (var i = 0; i < lajkovi.length; i++)
        print(lajkovi[i].idKorisnika.toString() +
            " " +
            lajkovi[i].idObjave.toString());
    });
  }

  Future addDislike(int idKorisnika, int idObjave) {
    String _url = url + "/Dislajkovi/dodajDislajk";

    var body = jsonEncode({"idKorisnika": idKorisnika, "idObjave": idObjave});

    return setToken().then((value){
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url, body: body, headers: header);
    });
  }

  void getDislajkovi() {
    String _url = url + "/Dislajkovi";
    http.get(_url).then((response) {
      Iterable list = json.decode(response.body);

      dislajkovi = list.map((model) => Dislajk.fromObject(model)).toList();
      for (var i = 0; i < dislajkovi.length; i++)
        print(dislajkovi[i].idKorisnika.toString() +
            " " +
            dislajkovi[i].idObjave.toString());
    });
  }

  Future fetchAktivnosti(int id) async {
    String _url = url + '/Objave/aktivnostiKorisnika';

    String body = json.encode({"idKorisnika": id});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(_url, body: body, headers: header);
    });
  }

  Future fetchObjaveByIdKorisnika(int id) async {
    var url = api_services.url + "/Objave/dajSveObjaveByIdKorisnika";

    var body = jsonEncode({"idKorisnika": id});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);
    });
  }

  Future fetchObjaveByIdInstitucija(int id, int idKorisnika) async {
    var url = api_services.url + "/Institucije/reseneObjaveZaInstituciju";

    var body = jsonEncode({"idInstitucije": id, "aktivanKorisnik":idKorisnika});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);
    });
  }

  Future fetchinfoObjava(int id, int idKorisnika) async{
    var url = api_services.url + "/Objave/dajSveZaObjavu";

    var body = jsonEncode({"idObjave": id, "idKorisnika": idKorisnika});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);
    });
  }

  Future fetchLikes(int idObjave) async {
    String _url = url + '/Lajkovi/dajLajkove';

    String body = json.encode({"idObjave": idObjave});

    return setToken().then((value) async {

      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(_url, body: body, headers: header);
    });

    
  }

  Future fetchDislikes(int idObjave) async {
    String _url = url + '/Dislajkovi/dajDislajkove';

    String body = json.encode({"idObjave": idObjave});

    return setToken().then((value) async{

      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(_url, body: body, headers: header);
    });

    
  }

  Future fetchComments(int idObjave, int idKorisnika) async {
    String _url = url + '/Komentari/dajKomentare';

    String body = json.encode({"idObjave": idObjave, "idKorisnika":idKorisnika});

    return setToken().then((value) async {

      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(_url, body: body, headers: header);

    });

    
  }

  Future fetchReseneComments(int idObjave) async {
    String _url = url + '/Komentari/dajOznaceneKaoReseniProblemiZaObjavu';

    String body = json.encode({"idObjave": idObjave});

    return setToken().then((value) async {

      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(_url, body: body, headers: header);

    });
  }

  Future fetchKorisnikePretraga(String text) async {
    var url = api_services.url + "/Korisnik/pretraga";

    var body = jsonEncode({"filter": text});

    return setToken().then((value) async {

      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);

    });
  }

  Future dajGradoveZaKorisnika(int idKorisnika) async{
    var url = api_services.url + '/GradKorisnici/dajGradoveZaKorisnika';
    var body = jsonEncode({"idKorisnika":idKorisnika});
    return setToken().then((value) async {

      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return await http.post(url, headers: header, body: body);

    });
  }

  Future dajRazlogePrijave() async{
    var url = api_services.url + '/Report/dajRazlogePrijave';
    var body = "";
    return setToken().then((value) async {
      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json"
      };

      return await http.post(url, headers: header, body: body);

    });
  }

  Future reportPost(int idObjave, int idRazloga, int idKorisnika){
    String _url = url + '/Report/dodajReport';

    var body = jsonEncode({
      "idObjave": idObjave,
      "idKorisnika": idKorisnika,
      "RazlogID": idRazloga
    });

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url,headers: header, body: body);
    });
  }

  Future reportComment(int idKomentara, int idKorisnika){
    String _url = url + '/ReportKomentara/dodajReport';

    var body = jsonEncode({
      "idKomentara": idKomentara,
      "idKorisnika": idKorisnika
    });

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url,headers: header, body: body);
    });
  }

  Future dajBoje(int idKorisnika){
    var url = api_services.url + '/Korisnik/dajBoje';
    var body = jsonEncode({
      "idKorisnika":idKorisnika
    });

    return setToken().then((value) async {
      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Authorization": this.token
      };

      return await http.post(url, headers: header, body: body);

    });
  }

  Future dajbrojObavestenja(int idKorisnika){
    var url = api_services.url + '/Obavestenja/brojNeprocitanih';
    var body = jsonEncode({
      "idKorisnika":idKorisnika
    });

    return setToken().then((value) async {
      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Authorization": this.token
      };

      return await http.post(url, headers: header, body: body);
    });
  }

  Future dajObavestenje(int idKorisnika){
    var url = api_services.url + '/Obavestenja/dajObavestenja';
    var body = jsonEncode({
      "idKorisnika":idKorisnika
    });

    return setToken().then((value) async {
      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Authorization": this.token
      };

      return await http.post(url, headers: header, body: body);
    });
  }

  Future potvrdiObavestenja(int idKorisnika){
    print('potvrdiObavestenja');
    var url = api_services.url + '/Obavestenja/procitano';
    var body = jsonEncode({
      "idKorisnika":idKorisnika
    });

    return setToken().then((value) async {
      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Authorization": this.token
      };

      return await http.post(url, headers: header, body: body);
    });
  }

  Future uploadImageComment(File imageFile, String text, int user_id, int idObjave, int poslata_slika, int resen_problem) async {
    if(imageFile!=null){
      print(imageFile.toString() + ', usao u imageFile!=null');
      var _url = url + '/Komentari/dodajSliku';
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      print(imageFile.toString());

      var uri = Uri.parse(_url);
      var request = new http.MultipartRequest("POST", uri);

      var multipathFile = new http.MultipartFile('slika', stream, length,
          filename: basename(imageFile.path));

      request.files.add(multipathFile);
      var response;
      return response = await request.send().then((value){
        value.stream.transform(utf8.decoder).listen((event) {
          print(event);
        });
        return setComment(text, user_id, idObjave, poslata_slika, resen_problem);

          
      });
     // print(response.statusCode);
      /*return response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });*/
    }else{
      return setComment(text, user_id, idObjave, poslata_slika, resen_problem);
    }
  }

  uploadImage(File imageFile, int idKorisnika, String opis, double x, double y, int idGrada, List<int> kategorija, BuildContext context, int lepaStvar) async {
    var _url = url + '/Objave/dodajSliku';
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    print(imageFile.toString());

    var uri = Uri.parse(_url);
    var request = new http.MultipartRequest("POST", uri);

    var multipathFile = new http.MultipartFile('slika', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipathFile);
    var response = await request.send().then((value){
      addImage(idKorisnika, opis, x, y, idGrada, kategorija, context, lepaStvar);

      value.stream.transform(utf8.decoder).listen((event) {
        print(event);
      });
      
    });
    
    //print(response.statusCode);
    /*response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });*/
  }

  promenaProfilneFotografije(File imageFile) async {
    var _url = url + '/Korisnik/dodajProfilnuSliku';
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    print(imageFile.toString());

    setToken().then((value) async {
        Map<String, String> header = {
        "Authorization": this.token
      };

      print(header);

      var uri = Uri.parse(_url);
      var request = new http.MultipartRequest("POST", uri);
      request.headers.addAll(header);

      var multipathFile = new http.MultipartFile('slika', stream, length,
          filename: basename(imageFile.path));

      request.files.add(multipathFile);
      var response = await request.send().then((value){

        value.stream.transform(utf8.decoder).listen((event) {
          print(event);
        });
        
      });

    });

    
    
    //print(response.statusCode);
    /*response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });*/
  }

  void addImage(int idKorisnika, String opis, double x, double y, int idGrada, List<int> kategorija, BuildContext context, int lepaStvar){
    String _url = url + "/Objave/dodajOpisSlike";

    var body = jsonEncode({"opis_slike": opis, "idKorisnika":idKorisnika, "x":x, "y":y, "idGrada":idGrada, "idKategorija":kategorija, "lepaStvarID":lepaStvar});

    setToken().then((value){
      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Authorization": this.token
      };

      http.post(_url, headers: header, body: body).then((response) {
        Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyBottomBar.withIndex(0)));
      });
    });
  }

  Future<Position> dajPoziciju() async {
    Position pozicija = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return pozicija;
  }

  

  Future setComment(String text, int user_id, int idObjave, int poslata_slika, int resen_problem) {
    String _url = url + "/Komentari/dodajKomentar";

    var body = json
        .encode({"idKorisnika": user_id, "idObjave": idObjave, "tekst": text, "poslataSlika":poslata_slika, "oznacenKaoResen":resen_problem});

    return setToken().then((value){
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url, body: body, headers: header);
    });
  }

  Future addLikeComment(int idKorisnika, int idKomentara) {
    String _url = url + "/LajkoviKomentara/dodajLajk";

    var body = jsonEncode({"idKorisnika": idKorisnika, "idKomentara": idKomentara});

    return setToken().then((value) async {
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url, body: body, headers: header);
    });
  }

  Future addDislikeComment(int idKorisnika, int idKomentara) {
    String _url = url + "/DislajkoviKomentara/dodajDislajk";

    var body = jsonEncode({"idKorisnika": idKorisnika, "idKomentara": idKomentara});

    return setToken().then((value){
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url, body: body, headers: header);
    });
  }

  Future deletePost(int idObjave){
    String _url = url + '/Objave/brisanjeObjave';

    var body = jsonEncode({
      "idObjave":idObjave
    });

    return setToken().then((value){
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url,headers: header, body: body);
    });
  }


  Future editComment(int idKomentara, String tekst){
    String _url = url + '/Komentari/izmenaKomentara';

    var body = jsonEncode({
      "id":idKomentara,
      "tekst":tekst
    });

    return setToken().then((value){
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url,headers: header, body: body);
    });

  }

  Future editTextPost(int idObjave, String tekst){
    String _url = url + '/Objave/izmenaTekstualneObjave';

    var body = jsonEncode({
      "ObjaveID":idObjave,
      "tekst":tekst
    });

    return setToken().then((value){
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url,headers: header, body: body);
    });

  }

  Future editOpisSlike(int idObjave, String tekst){
    String _url = url + '/Objave/izmenaSlike';

    var body = jsonEncode({
      "ObjaveID":idObjave,
      "opis_slike":tekst
    });

    return setToken().then((value){
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url,headers: header, body: body);
    });

  }

  Future deleteComment(int idKomentara, int idObjave){
    String _url = url + '/Komentari/brisanjeKomentara';

    var body = jsonEncode({
      "idKomentara": idKomentara,
      "idObjave": idObjave
    });

    return setToken().then((value) async {

      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Authorization": this.token
      };

      return await http.post(_url,headers: header, body: body);
    });
  }

  Future logOut(int idKorisnika, BuildContext context) async{
    String _url = url + '/Korisnik/odjava';
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var body = jsonEncode({
      "idKorisnika":idKorisnika
    });

    setToken().then((value){
      print('usao u setToken()');
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url,headers: header, body: body).then((response) async{
      print(response.statusCode);
     // if(response.statusCode == 200){
        preferences.remove('user');
        preferences.remove('token');
        return response;

        /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyLoginPage()),
          );*/
        /*Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyLoginPage()));*/
     // }
    });
    });
  }

  Future dajGradove() async {
    //List<Grad> gradovi = List<Grad>();
    String _url = url + '/Gradovi';
    return await http.get(_url);
  }



  Future resenProblemSaKomentarima(var body, int idObjave, BuildContext context){
    String _url = url + '/Komentari/dodajViseResenja';

    setToken().then((value){
      Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization": this.token
    };

    return http.post(_url,headers: header, body: body).then((response){
      print(response.statusCode);
      problemJeResen(idObjave, context);
      //Navigator.pop(context);
    });
    });
  }

  void problemJeResen(int idObjave, BuildContext context){
    String _url = url + '/Objave/problemJeResen';

    setToken().then((value){
      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Authorization": this.token
      };

      var body = jsonEncode({
        "idObjave":idObjave
      });

      http.post(_url,headers: header, body: body).then((response){
        print(response.statusCode);
        Navigator.pop(context);
      });

    });
  }

}
