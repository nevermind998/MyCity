import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:mob_app/models/Slika.dart';
import 'package:mob_app/models/TekstualnaObjava.dart';

class Obavestenje{
  int id;
  int procitano;
  int resena;
  int komentarID;
  int lajkID;
  Korisnik korisnik = new Korisnik();
  Objava objava = new Objava();

  Obavestenje({this.id, this.procitano, this.komentarID, this.lajkID, this.korisnik, this.objava, this.resena});
  
  factory Obavestenje.fromJson(Map<String, dynamic> json){
    return Obavestenje(
      id: json['id'],
      procitano: json['procitano'],
      komentarID: json['komentarID'],
      lajkID: json['lajkID'],
      korisnik: json['korisnik'],
      objava: json['objava'],
      resena: json['resena']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['procitano'] = procitano;
    map['komentarID'] = komentarID;
    map['lajkID'] = lajkID;
    map['korisnik'] = korisnik;
    map['objava'] = objava;
    map['resenje'] = resena;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Obavestenje.fromObject(dynamic o){
    this.id = o["id"];
    this.procitano = o["procitano"];
    this.komentarID = o["komentarID"];
    this.lajkID = o["lajkID"];
    this.korisnik = new Korisnik.fromObject(o["korisnik"]);
    this.objava = new Objava.fromObject(o["objava"]);
    this.resena = o["resenje"];
  }

}