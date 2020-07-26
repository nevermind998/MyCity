import 'package:mob_app/models/Slika.dart';
import 'package:mob_app/models/TekstualnaObjava.dart';

class Report{
  int id;
  int idKorisnika;
  int idObjave;
  int razlogId;

  Report({this.id, this.idKorisnika, this.idObjave, this.razlogId});
  
  factory Report.fromJson(Map<String, dynamic> json){
    return Report(
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

  Report.fromObject(dynamic o){
    this.id = o["id"];
    this.idKorisnika = o["idKorisnika"];
    this.idObjave = o["idObjave"];
  }

}