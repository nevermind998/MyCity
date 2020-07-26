import 'package:mob_app/models/Grad.dart';
import 'package:mob_app/models/Korisnik.dart';

class Pomocna{
  int id;
  int idTipa;
  int idKorisnika;
  Korisnik korisnik;
  int resenaObjava;
  String vreme;
  int idGrada;
  Grad grad;

  Pomocna({this.id,this.idTipa,this.idKorisnika,this.korisnik,this.resenaObjava,this.vreme,this.idGrada, this.grad});

  factory Pomocna.fromJson(Map<String, dynamic> json){
    return Pomocna(
      //id: json['id'],
    );
  }

   Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

    Pomocna.fromObject(dynamic o){
    this.id = o["id"];
    this.idTipa = o["idTipa"];
    this.idKorisnika = o["korisnikID"];
    this.korisnik = new Korisnik.fromObject(o["korisnik"]);
    this.idGrada = o["gradID"];
    if(o["grad"]!=null){
      this.grad = new Grad.fromObject(o["grad"]);
    }
    this.vreme = o["vreme"];
  }

}