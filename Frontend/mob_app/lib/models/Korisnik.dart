import 'package:mob_app/models/BojaProfila.dart';
import 'package:mob_app/models/Grad.dart';

class Korisnik{
  int id;
  String email;
  String ime;
  String prezime;
  String biografija;
  //List<int> gradovi = List<int>();
  String username;
  List<Grad> gradovi = List<Grad>();
  int poeni;
  String url_slike;
  String uloga;

  //String gradovi;

  Korisnik({this.email, this.ime, this.prezime, this.biografija, this.gradovi, this.username, this.poeni,
  this.url_slike, this.uloga});
  
  factory Korisnik.fromJson(Map<String, dynamic> json){
    return Korisnik(
      email: json['email'],
      ime: json['ime'],
      prezime: json['prezime'],
      biografija: json['biografija']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["email"] = email;
    map["ime"] = ime;
    map["prezime"] = prezime;
    map["biografija"] = biografija;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Korisnik.fromObject(dynamic o){
    
    this.id = o["id"];
    this.email = o["email"];
    this.ime = o["ime"];
    this.prezime = o["prezime"];
    this.biografija = o["biografija"];
    this.username = o["username"];
    if(o["poeni"] != null){
      this.poeni = o["poeni"];
    }
    if(o["urlSlike"]!=null){
      //print('Korisnik.dart urlSlike = ' + o["urlSlike"]);
      this.url_slike = o["urlSlike"];
    }else{
      this.url_slike = '';
    }
    if(o["uloga"]!=null){
      this.uloga = o["uloga"];
    }else{
      this.uloga = "";
    }
    if(o["gradovi"]!=null){
      var rest = o["gradovi"] as List;
      this.gradovi = rest.map<Grad>((e) => Grad.fromObject(e)).toList();
    }
    /*if(o["bojaProfila"] != null){
      this.boja = BojaProfila.fromObject(o["bojaProfila"]);
    }else{
      this.boja = null;
    }*/

    //this.gradovi = pomocna;
    /*this.gradovi = List.castFrom(o["idGradova"]);
    print(this.gradovi);*/
    //print(o["idGradova"]);
    //this.gradovi = o["idGradova"];
    //print(gradovi);
  }

}