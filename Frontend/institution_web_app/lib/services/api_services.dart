import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webApp/screens/kodPage.dart';
import '../screens/appBarPage.dart';
import '../screens/loginPage.dart';
import '../screens/profilePage.dart';
import '../models/Lajk.dart';
import '../models/Dislajk.dart';
import '../models/Korisnik.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:google_fonts/google_fonts.dart' as gf;

import '../screens/registracijaPage.dart';
//kreiranje sesije
//html.window.sessionStorage['adminInfo'] = res.body;
class api_services{

  static String url = "http://147.91.204.116:2068/api";
 static String url_za_slike = "http://147.91.204.116:2068//";
 //static String url="http://127.0.0.1:53431/api";
 //static String url_za_slike = "http://127.0.0.1:53431//";
  String get _url => url;
   final key = GlobalKey<FormState>();
  Korisnik user;
  List<Lajk> lajkovi;
  List<Dislajk> dislajkovi;



  Future dajGradove() async {

    String _url = url + '/Gradovi';
    return await http.get(_url);
  }
   static Future fetchUser() async{
    return await http.get(url);
  }
  Future fetchDajKategorije() async {
    var url = api_services.url + "/Objave/dajKategorijeProblema";
    var body = jsonEncode({"idGrada": 0});
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
    };

    return await http.post(url, headers: header,body: body);
  }
  Future fetchDajKategorijeinstitucije(int id) async {
    var url = api_services.url + "/Institucije/dajKategorijeZaInstituciju";
    var body = jsonEncode({"idInstitucije": id});
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header,body: body);
  }


  Future fetchlogujesedalje(var body) async {
    var url = api_services.url + "/Institucije/sacuvajKorisnika";

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
    };

    return await http.post(url, headers: header,body: body);
  }

  Future fetchodustaoodLogovanja(var body) async {
    var url = api_services.url + "/Korisnik/potvrdaKoda";

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
    };

    return await http.post(url, headers: header,body: body);
  }



  Future dajGradoveZaKorisnika(int idKorisnika) async{
    var url = api_services.url + '/GradKorisnici/dajGradoveZaKorisnika';
    var body = jsonEncode({"idKorisnika":idKorisnika});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchReseneObjave(int id) async {
    var url = api_services.url + "/Objave/dajReseneObjave";

    var body = jsonEncode({"id_korisnika": id});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchGradoveKorisnika(int id) async {
    var url = api_services.url + "GradKorisnici/dajGradoveZaKorisnika";

    var body = jsonEncode({"idKorisnika": id});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
    "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchObjave(int id) async {
    var url = api_services.url + "/Objave/prikaziSveObjave";

    var body = jsonEncode({"id_korisnika": id});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
    "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchZatvori(int idObjave,int idInstitucije) async {
    var url = api_services.url + "/Objave/problemJeResen";

    var body = jsonEncode({
      "idObjave": idObjave,
      "idInstitucije":idInstitucije
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future riport(int idObjave,int idInstitucije) async {
    var url = api_services.url + "/Report/dodajReport";

    var body = jsonEncode({
      "idKorisnika":idInstitucije,
      "idObjave": idObjave
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }
   Future fetchTekstualneObjave() async {
    String _url = url + "/TekstualneObjave";
    return await http.get(_url);
  }

  Future<Korisnik> getUserSession() async {
    Map<String, dynamic> jsonObject =json.decode(html.window.sessionStorage['userInfo']);
    user = new Korisnik.fromObject(jsonObject);
    return user;
  }

 void novaSifra(String username)
 {
   String _url = url+"/Korisnik/zaboravljenaSifra";
   var body=jsonEncode({
     "username":username
   });

   Map<String, String> header = {
     "Accept": "application/json",
     "Content-type": "application/json"
   };

   http.post(_url, headers: header, body: body).then((response) {
   });
 }
  void registration(String body, BuildContext context) {

    String _url=url+"/Institucije/Registracija";

      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
      };

      http.post(_url, headers: header, body: body).then((response) {
      if(response.statusCode ==403)
      {
        _showDialog1(context,"Postojeća mail adresa.","Pokusajte ponovo.");
        RegistrationPageState.registracija=false;
      }
      if(response.statusCode ==204)
      {
        _showDialog1(context,"Korisničko ime je zauzato.","Pokusajte ponovo.");
        RegistrationPageState.registracija=false;
      }
      if(response.statusCode ==200)
      {
        int  kod=int.parse(response.body);
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => kodPage(kod,body)));
      }

    });
  }

  Widget _buildText(String str,double size,int broj )
  {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child:Text(str,style:gf.GoogleFonts.ubuntu(color:broj==1?Color.fromRGBO(42, 184, 115, 1):Colors.white,fontSize: size,fontWeight: FontWeight.bold),)
    );

  }
  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: _buildText('Pogrešno korisničko ime ili lozinka.',16,1),
            content: _buildText('Molimo Vas da pokušate opet.',16,1),
            actions: <Widget>[
              FlatButton(
                child: _buildText('Zatvori',16,1),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void loginInstitution(BuildContext context, String body)
  {
    String _url=url+"/Institucije/login";

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type":"application/json"
    };


    http.post(_url, headers: header, body: body).then((response){


      if(response.statusCode == 200){
        Map<String,dynamic> jsonObject=json.decode(response.body);

        html.window.sessionStorage['userInfo'] = response.body;
        html.window.sessionStorage['token']=jsonObject['token'];
        Korisnik logovani_korisnik = new Korisnik();
        logovani_korisnik = Korisnik.fromObject(jsonObject);
        getUserSession();
        //Navigator.push(context, MaterialPageRoute(builder: (context) => AppBarPage()));
        Navigator.pushNamed(context, "/appbarWeb");
      }else{
        _showDialog(context);
      }

    });

  }

  void oznaciKaoResen(int idObjave, int idInstitucije){
    String _url = url + '/Objave/problemJeResen';

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    var body = jsonEncode({
      "idObjave":idObjave,
      "idInstitucije":idInstitucije
    });

    http.post(_url,headers: header, body: body).then((response){

    });

  }

  void getLajkovi(){
    String _url = url + "/Lajkovi";
    http.get(_url).then((response){
      Iterable list = json.decode(response.body);

      lajkovi = list.map((model) => Lajk.fromObject(model)).toList();

    });
  }

  Future addDislike(int idKorisnika, int idObjave){
    String _url = url + "/Dislajkovi/dodajDislajk";

    var body = jsonEncode({
      "idKorisnika":idKorisnika,
      "idObjave":idObjave
    });

    Map<String, String> header = {
       "Accept": "application/json",
       "Content-type":"application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return http.post(_url,body: body, headers: header);
  }

  void getDislajkovi(){
    String _url = url + "/Dislajkovi";
    http.get(_url).then((response){
      Iterable list = json.decode(response.body);

      dislajkovi = list.map((model) => Dislajk.fromObject(model)).toList();

    });
  }

  void logOut(int idKorisnika, BuildContext context) async{
    String _url = url + '/Korisnik/odjava';


    var body = jsonEncode({
      "idKorisnika":idKorisnika
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    http.post(_url,headers: header, body: body).then((response){
      if(response.statusCode == 200){
        html.window.sessionStorage.clear();
        AppBarPageState.trenIndex=0;
        Navigator.of(context).pushNamedAndRemoveUntil('/',ModalRoute.withName('/loginWeb'));
      }

    });
  }
  Future fetchnereseneObjaveByIdKorisnikaiKategorije(int idkategorije,int idkor) async {
    var url = api_services.url + "/Objave/prikazNeResenihObjavaPoKategoriji";
    var body = jsonEncode({
      "idKorisnika":idkor,
      "kategorija":idkategorije

    });
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }
  Future fetchreseneObjaveByIdKorisnikaiKategorije(int idkategorije,int idkor) async {
    var url = api_services.url + "/Objave/prikazResenihObjavaPoKategoriji";
    var body = jsonEncode({
      "idKorisnika":idkor,
      "kategorija":idkategorije

    });
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchObjaveByIdKorisnika(int id,int idUlogovaneIns) async {
    var url = api_services.url + "/Objave/dajProfilInstituciji";
    var body = jsonEncode({
      "idKorisnika": id,
      "aktivanKorisnik":idUlogovaneIns
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchObjaveGradaInstitucijeKojeNisuResene(int id) async {
    var url = api_services.url + "/Institucije/prikazPocetneStrane";
    var body = jsonEncode({"idInstitucije": id});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future dajRazlogePrijave() async{
    var url = api_services.url + '/Report/dajRazlogePrijave';
    var body = "";

      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
      };

      return await http.post(url, headers: header, body: body);

  }

  Future deleteComment(int idKomentara, int idObjave){
    String _url = url + '/Komentari/brisanjeKomentara';

    var body = jsonEncode({
      "idKomentara": idKomentara,
      "idObjave": idObjave
    });


      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Authorization":"Bearer "+html.window.sessionStorage['token']
      };

       return http.post(_url,headers: header, body: body);

  }
  Future reportPost(int idObjave, int idRazloga, int idKorisnika){
    String _url = url + '/Report/dodajReport';

    var body = jsonEncode({
      "idObjave": idObjave,
      "idKorisnika": idKorisnika,
      "RazlogID": idRazloga
    });


      Map<String, String> header = {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Authorization":"Bearer "+html.window.sessionStorage['token']
      };

      return http.post(_url,headers: header, body: body);

  }



  Future reportComm(int idkojm, int idRazloga, int idKorisnika){
    String _url = url + '/ReportKomentara/dodajReport';

    var body = jsonEncode({
      "idKomentara": idkojm,
      "idKorisnika": idKorisnika,
      "id": idRazloga
    });


    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return http.post(_url,headers: header, body: body);

  }

  Future fetchObjaveGradaInstitucijeKojejesuResene(int id,int logkor) async {
    var url = api_services.url + "/Institucije/reseneObjaveZaInstituciju";
    var body = jsonEncode({
      "idInstitucije": id,
      "aktivanKorisnik":logkor
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }
  Future fetchObjaveByIdInstitucije(int id,int idKor) async {
    var url = api_services.url + "/Institucije/reseneObjaveZaInstituciju";

    var body = jsonEncode({
      "idInstitucije": id,
      "aktivanKorisnik":idKor
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchKorisnikePretraga(String text) async {
    var url = api_services.url + "/Korisnik/pretraga";

    var body = jsonEncode({"filter": text});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }
  Future fetchKorisnik(int idkorisnika) async {
    var url = api_services.url + "/Korisnik/dajKorisnika";

    var body = jsonEncode({"idKorisnika":idkorisnika});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future addLike(int idKorisnika, int idObjave) {
    String _url = url + "/Lajkovi/dodajLajk";

    var body = jsonEncode({"idKorisnika": idKorisnika, "idObjave": idObjave});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return http.post(_url, body: body, headers: header);
  }

  Future fetchLikes(int idObjave) async {
    String _url = url + '/Lajkovi/dajLajkove';

    String body = json.encode({"idObjave": idObjave});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(_url, body: body, headers: header);
  }

  Future fetchDislikes(int idObjave) async {
    String _url = url + '/Dislajkovi/dajDislajkove';

    String body = json.encode({"idObjave": idObjave});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(_url, body: body, headers: header);
  }

  Future fetchComments(int idObjave,int idKor) async {
    String _url = url + '/Komentari/dajKomentare';

    String body = json.encode({
      "idObjave": idObjave,
      "idKorisnika":idKor
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(_url, body: body, headers: header);
  }

  Future fetchReseneComments(int idObjave) async {
    String _url = url + '/Komentari/dajOznaceneKaoReseniProblemiZaObjavu';

    String body = json.encode({"idObjave": idObjave});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    return await http.post(_url, body: body, headers: header);
  }

    Future<Position> getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

   Future addLikeComment(int idKorisnika, int idKomentara) {
    String _url = url + "/LajkoviKomentara/dodajLajk";

    var body = jsonEncode({"idKorisnika": idKorisnika, "idKomentara": idKomentara});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

   return  http.post(_url, body: body, headers: header);
  }

  Future addDislikeComment(int idKorisnika, int idKomentara) {
    String _url = url + "/DislajkoviKomentara/dodajDislajk";

    var body = jsonEncode({"idKorisnika": idKorisnika, "idKomentara": idKomentara});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

   return  http.post(_url, body: body, headers: header);
  }



  Future setComment(String text, int user_id, int idObjave, int poslata_slika, int resen_problem) {
    String _url = url +"/Komentari/dodajKomentar";

    var body = json.encode({"idKorisnika": user_id, "idObjave": idObjave, "tekst": text, "poslataSlika":poslata_slika, "oznacenKaoResen":resen_problem});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

   return  http.post(_url, body: body, headers: header);
  }

  void promenaProfilne(String str)
  {
    String _url = url +"/Korisnik/dodajProfilnuSliku";

    var body = jsonEncode({
      "urlSlike":str
    });



    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    http.post(_url, body: body, headers: header).then((response) {

    });
  }

  void menjalica(int idInst,String base)
  {
    String _url = url +"/Institucije/dodajProfilnuSliku";

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    var body=json.encode({
      "urlSlike":base
    });
    http.post(_url, body: body, headers: header).then((response) {

    });
  }



  void brisanjekorisnika(int idInst)
  {
    String _url = url +"/Korisnik/brisanjeKorisnika";

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    var body=json.encode({
      "idKorisnika":idInst
    });
    http.post(_url, body: body, headers: header).then((response) {

    });
  }



  void slikaKomentara(int idInst,int idObjave,String slika,String t)
  {
    String _url = url +"/Komentari/dodajResenjeOdInstitucije";

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };

    var body=json.encode({
      "idInstitucije":idInst,
      "idObjave":idObjave,
      "base64":slika,
      "tekst":t
    });

    http.post(_url, body: body, headers: header).then((response) {

    });
  }

  uploadImageComment(File imageFile, String text, int user_id, int idObjave, int poslata_slika, int resen_problem) async {
    if(imageFile!=null){
      var _url = url + '/Komentari/dodajSliku';
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();


      var uri = Uri.parse(_url);
      var request = new http.MultipartRequest("POST", uri);

      var multipathFile = new http.MultipartFile('slika', stream, length,
          filename: basename(imageFile.path));

      request.files.add(multipathFile);
      var response = await request.send().then((value){
        setComment(text, user_id, idObjave, poslata_slika, resen_problem);
      });

      response.stream.transform(utf8.decoder).listen((value) {

      });
    }else{
      setComment(text, user_id, idObjave, poslata_slika, resen_problem);
    }
  }

 Future  azuriranje(String body, BuildContext context) async {
    String _url = url + "/Institucije/azuriranjeProfila";

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['token']
    };


     return http.post(_url, body: body, headers: header);

  }

  void _showDialog1(BuildContext context,String str,String str1) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: _buildText(str,16,1),
            content: _buildText(str1,16,1),
            actions: <Widget>[
              FlatButton(
                child: _buildText('Zatvori',16,1),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

}