import 'package:mob_app/models/Slika.dart';
import 'package:mob_app/models/TekstualnaObjava.dart';

class Lajk{
  int id;
  int idKorisnika;
  int idObjave;

  Lajk({this.id, this.idKorisnika, this.idObjave});
  
  factory Lajk.fromJson(Map<String, dynamic> json){
    return Lajk(
      id: json['id'],
      idKorisnika: json['idKorisnika'],
      idObjave: json['idObjave']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['idKorisnika'] = idKorisnika;
    map['idObjave'] = idObjave;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Lajk.fromObject(dynamic o){
    this.id = o["id"];
    this.idKorisnika = o["idKorisnika"];
    this.idObjave = o["idObjave"];
  }

}