import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:webApp/models/Dislajk.dart';
import 'package:webApp/models/Korisnik.dart';
import 'package:webApp/models/Lajk.dart';
import 'package:webApp/screens/AppBarPage.dart';
import 'package:webApp/screens/loginPage.dart';

//html.window.sessionStorage['adminInfo'] = res.body;

class api_services{

  //static String url="http://127.0.0.1:53431/api";
  //static String url_za_slike = "http://127.0.0.1:53431//";
  static String url="http://147.91.204.116:2068/api";
  static String url_za_slike = "http://147.91.204.116:2068//";
  String get _url => url;
  final key = GlobalKey<FormState>();
  Korisnik user;
  List<Lajk> lajkovi;
  List<Dislajk> dislajkovi;
/*
   static Future fetchUser() async{
    return await http.get(url);
  }
*/
  Future fetchObjaveGradaInstitucijeKojejesuResene(int id) async {
    var url = api_services.url + "/Institucije/prikaziReseneProbleme";
    var body = jsonEncode({"idInstitucije": id});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(url, headers: header, body: body);
  }
  Future fetchKorisnik(int idkorisnika) async {
    var url = api_services.url + "/Korisnik/dajKorisnika";

    var body = jsonEncode({"idKorisnika":idkorisnika});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(url, headers: header, body: body);
  }
  Future fetchLikes(int idObjave) async {
    String _url = url + '/Lajkovi/dajLajkove';

    String body = json.encode({"idObjave": idObjave});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(_url, body: body, headers: header);
  }
  Future fetchDislikes(int idObjave) async {
    String _url = url + '/Dislajkovi/dajDislajkove';

    String body = json.encode({"idObjave": idObjave});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(_url, body: body, headers: header);
  }
  Future fetchObjave(int idGrada,int idKat) async {
    var url = _url + "/Administrator/dajObjave";

    var body = jsonEncode({
        "kategorija":idKat,
        "grad":idGrada
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchObjaveByIdInstitucije(int id) async {
    var url = api_services.url + "/Institucije/reseneObjaveZaInstituciju";

    var body = jsonEncode({"idInstitucije": id});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
    "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchKategorije() async{
    var url = api_services.url + "/Objave/dajKategorijeProblema";
    var body = jsonEncode({"kategorija": 0});
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };
    return await http.post(url, headers: header, body: body);
  }

  Future fetchOcena() async {
    var url = api_services.url + "/Administrator/ocenaAplikacije";
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };
    return await http.post(url, headers: header);
  }

  Future fetchAktuelneGradove() async {
    var url = api_services.url + "/Administrator/gradoviSaNajviseObjava";
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };
    return await http.post(url, headers: header);
  }

  Future fetchAktuelneKategorije() async {
    var url = api_services.url + "/Administrator/kategorijeSaNajviseObjava";
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };
    return await http.post(url, headers: header);
  }

  Future fetchTop10Gradova() async{
    var url = api_services.url + "/Administrator/top10GradovaPoPoenima";
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };
    return await http.post(url, headers: header);
  }

  Future fetchTop10Korisnika() async{
    var url = api_services.url + "/Administrator/top10KorisnikaPoPoenima";
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };
    return await http.post(url, headers: header);
  }

  Future fetchStatistikaKategorije(int kategorija) async{
    var url= api_services.url + "/Administrator/statistikaPoKategoriji";

    var body = jsonEncode({
      "kategorija": kategorija
    });


    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchTabelaObjava(int idGrada, int kategorija,int vreme) async{
    var url;
    if(vreme==1)
    {
      url= api_services.url + "/Administrator/tabelaObjavaZa7Dana";
    }
    if(vreme==2)
    {
        url= api_services.url + "/Administrator/tabelaObjavaZa30Dana";
    }
    if(vreme==3)
    {
      url= api_services.url + "/Administrator/tabelaObjava";
    }


    var body = jsonEncode({
      "idGrada":idGrada,
      "kategorija": kategorija
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future dajGradove() async {
    String _url = url + '/Gradovi';
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
    };
    return await http.get(_url, headers: header);
  }


  Future getKorisniciZaPrijave(var body) async{
    String url = _url + "/Administrator/prikazKorisnika";
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(url, headers: header, body: body);
  }

  Future fetchStatistika(int idGrada, int kategorija,int vreme) async{
    var url;
    if(vreme==1)
    {
      url= api_services.url + "/Administrator/prikaziStatistikuZa7Dana";
    }
    if(vreme==2)
    {
      url= api_services.url + "/Administrator/prikaziStatistikuZa30Dana";
    }
    if(vreme==3)
    {
      url= api_services.url + "/Administrator/prikaziStatistikuOduvek";
    }


    var body = jsonEncode({
      "idGrada":idGrada,
      "kategorija": kategorija
    });
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(url, headers: header, body: body);
  }


  Future fetchNepozeljniKomentari() async {
    String _url = url + "/Administrator/Komentari";
    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
    };
    return await http.post(_url, headers: header);
  }

   Future<Korisnik> getUserSession() async {
    Map<String, dynamic> jsonObject =json.decode(html.window.sessionStorage['adminInfo']);
    user = new Korisnik.fromObject(jsonObject);
    return user;
  }


  void postaviZaAdmina(Korisnik korisnik)
  {
    String _url = url+"/Administrator/postavljanjeAdmina";

    var body=jsonEncode({
      "idKorisnika": korisnik.id
    });

    Map<String, String> header = {
    "Accept": "application/json",
    "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    http.post(_url, headers: header, body: body).then((response) {

    });

  }

  void postaviZaKorisnika(Korisnik korisnik)
  {
    String _url = url+"/Administrator/vratiUloguKorisnika";

    var body=jsonEncode({
      "idKorisnika": korisnik.id
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    http.post(_url, headers: header, body: body).then((response) {

    });

  }

  Future fetchComments(int idObjave) async {
    String _url = url + '/Komentari/dajKomentare';

    String body = json.encode({"idObjave": idObjave});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(_url, body: body, headers: header);
  }

    Future fetchObjaveByIdKorisnika(int id) async {
    var url = api_services.url + "/Objave/dajSveObjaveByIdKorisnika";

    var body = jsonEncode({"idKorisnika": id});

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(url, headers: header, body: body);
  }

  void obrisiObjavu(int idObjave)
  {
    String _url = url+"/Administrator/brisanjeObjave";

    var body=jsonEncode({
      "idObjave":idObjave,
    });

    Map<String, String> header = {
    "Accept": "application/json",
    "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };
    
    http.post(_url, headers: header, body: body).then((response) {
        
    });
  }

  void obrisiKomentare(int idKomentara)
  {
    String _url = url+"/Administrator/brisanjeKomentara";


    var body=jsonEncode({
      "idKomentara":idKomentara,
    });

    Map<String, String> header = {
    "Accept": "application/json",
    "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };
    

    http.post(_url, headers: header, body: body).then((response) {

        
    });
  }

  void obrisiKorisnika(int idKorisnika)
  {
    String _url = url+"/Administrator/brisanjeKorisnika";


    var body=jsonEncode({
      "idKorisnika":idKorisnika,
      "idAdmina":user.id
    });


    Map<String, String> header = {
    "Accept": "application/json",
    "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };
    
    http.post(_url, headers: header, body: body).then((response) {
        
    });
  }

  void obrisiAdmina(int idKorisnika)
  {
    String _url = url+"/Administrator/brisanjeAdmina";


    var body=jsonEncode({
      "idKorisnika":idKorisnika,
      "idAdmina":user.id
    });


    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    http.post(_url, headers: header, body: body).then((response) {

    });
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

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pogrešno korisničko ime ili lozinka'),
            content: Text('Uneli ste pogrešno korisničko ime ili lozinku. Molimo vas da pokušate opet.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Zatvori'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
  
  void login(BuildContext context, String body)
  {
	  String _url=url+"/Administrator/loginWeb";

    Map<String, String> header = {
     "Accept": "application/json",
     "Content-type":"application/json"
    };

    http.post(_url, headers: header, body: body).then((response){

        if(response.statusCode == 200){
          Map<String,dynamic> jsonObject=json.decode(response.body);
          html.window.sessionStorage['adminInfo'] = response.body;

          html.window.sessionStorage['adminToken']=jsonObject['token'];

          html.window.sessionStorage['adminUloga']=jsonObject['uloga'];


          getUserSession();

          Navigator.pushNamed(context, '/appbarWeb');
/*
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AppBarPage()));

*/

      }
      else{
        _showDialog(context);

      }

    });

  }	

  Future fetchKorisnikePretraga(String text) async{
    var url = api_services.url + "/Korisnik/pretraga";

    var body = jsonEncode({
      "filter": text
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(url, headers: header, body: body);
  }
/*
  Future fetchTekstualneObjave() async{
    String _url = url + "/TekstualneObjave";
    return await http.get(_url);
  }
*/
  
  void getLajkovi(){
    String _url = url + "/Lajkovi";
    http.post(_url).then((response){
      Iterable list = json.decode(response.body);

      lajkovi = list.map((model) => Lajk.fromObject(model)).toList();
    });
  }

  Future getReport  (int ido) async {
    String _url = url + "/Report/dajReportoveZaAdmina";
    var body = jsonEncode({
      "idObjave": ido
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    return await http.post(_url, headers: header, body: body);
  }

  void getDislajkovi(){
    String _url = url + "/Dislajkovi";
    http.post(_url).then((response){
      Iterable list = json.decode(response.body);

      dislajkovi = list.map((model) => Dislajk.fromObject(model)).toList();
    });
  }

  void logOut(int idKorisnika, BuildContext context) async{
    String _url = url + '/Administrator/odjava';

    var body = jsonEncode({
      "idKorisnika":idKorisnika
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    http.post(_url,headers: header, body: body).then((response){
      if(response.statusCode == 200){
        html.window.sessionStorage.remove('adminInfo');
        html.window.sessionStorage.remove('adminToken');

        html.window.sessionStorage.remove('adminUloga');

        html.window.sessionStorage.clear();
        html.window.sessionStorage.remove('Idkorisnika');
        html.window.sessionStorage.clear();
        html.window.sessionStorage.remove('zaKomentare');
        html.window.sessionStorage.clear();
        html.window.sessionStorage.remove('IDObjave');
        html.window.sessionStorage.clear();
        html.window.sessionStorage.remove('IDKorisnika');
        html.window.sessionStorage.clear();
        html.window.sessionStorage.remove('strana');
        html.window.sessionStorage.clear();
        AppBarPageState.trenIndex=0;
        //Navigator.of(context).pop();

        //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

        //Navigator.of(context).pushReplacementNamed('/');
        //Navigator.of(context).removeRoute();

        Navigator.of(context).pushNamedAndRemoveUntil('/',ModalRoute.withName('/loginWeb'));

        //Navigator.pushNamed(context, '/loginWeb');
      }

    });
  }

  void dodajPoene(int idKorisnika,int poeni)
  {
    String _url = url + '/Administrator/dodajPoeneKorisniku';
    var body = jsonEncode({
      "poeni": poeni,
      "idKorisnika":idKorisnika
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    http.post(_url,headers: header, body: body).then((response){
    });
  }

  void oduzmiPoene(int idKorisnika,int poeni)
  {
    String _url = url + '/Administrator/oduzmiPoeneKorisniku';
    var body = jsonEncode({
      "poeni": poeni,
      "idKorisnika":idKorisnika
    });

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/json",
      "Authorization":"Bearer "+html.window.sessionStorage['adminToken']
    };

    http.post(_url,headers: header, body: body).then((response){
    });
  }
}