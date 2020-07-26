import './Grad.dart';

class Korisnik{
  int id;
  String email;
  String ime;
  String prezime;
  String biografija;
  String username;
  String password;
  String urlSlike;
  String uloga;
  int poeni;
  int ocenaAplikacije;
  //List<Grad> gradovi;
  int brojPrijavljenihKomentara;
  int brojPrijavljenihObjava;

  Korisnik({this.email, this.ime, this.prezime, this.biografija,this.username,this.password,this.urlSlike,this.uloga,this.poeni,
  this.ocenaAplikacije,this.brojPrijavljenihKomentara,this.brojPrijavljenihObjava

  });
  
  factory Korisnik.fromJson(Map<String, dynamic> json){
    return Korisnik(
        email: json['email'],
      ime: json['ime'],
      prezime: json['prezime'],
      biografija: json['biografija'],
	    username: json['username'],
      password: json['password'],
	    urlSlike: json['urlSlike'],
      uloga: json['uloga'],
      poeni: json['poeni'],
        ocenaAplikacije:json['ocenaAplikacije'],
    //    gradovi: json['gradovi'],
        brojPrijavljenihKomentara: json['brojPrijavljenihKomentara'],
      brojPrijavljenihObjava: json['brojPrijavljenihObjava']

    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["email"] = email;
    map["ime"] = ime;
    map["prezime"] = prezime;
    map["biografija"] = biografija;	
  	map["username"] = username;
    map["password"] = password;
    map["urlSlike"] = urlSlike;
    map["uloga"] = uloga;
    map["poeni"] = poeni;
    map['ocenaAplikacije'] = ocenaAplikacije;
    map["brojPrijavljenihKomentara"] = brojPrijavljenihKomentara;
    map["brojPrijavljenihObjava"] = brojPrijavljenihObjava;

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
    this.password = o["password"];
  	this.urlSlike = o["urlSlike"];
    this.uloga = o["uloga"];
    this.poeni = o["poeni"];
    this.ocenaAplikacije=o["ocenaAplikacije"];
/*
    if(o["gradovi"] != null){
      print("usao u gradove");
      this.gradovi = new List<Grad>();
      for(var i=0; i<o["gradovi"].length; i++){
        print(o["gradovi"][i]);
        this.gradovi.add(o["gradovi"][i]);
      }
    }
*/
    this.brojPrijavljenihObjava = o["brojPrijavljenihObjava"];
    this.brojPrijavljenihKomentara = o["brojPrijavljenihKomentara"];
  }

}