import 'package:mob_app/models/Pomocna.dart';

class TekstualnaObjava{
  int id;
  int idObjave;
  String tekst;
  Pomocna pomocna;

  TekstualnaObjava({this.idObjave, this.tekst, this.pomocna});
  
  factory TekstualnaObjava.fromJson(Map<String, dynamic> json){
    return TekstualnaObjava(
      idObjave: json['idObjave'],
      tekst: json['tekst']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["idObjave"] = idObjave;
    map["tekst"] = tekst;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  TekstualnaObjava.fromObject(dynamic o){
    this.id = o["id"];
    this.idObjave = o["idObjave"];
    this.tekst = o["tekst"];
    if(o["objave"]!= null){
      this.pomocna = new Pomocna.fromObject(o["objave"]);
    }
  }

}