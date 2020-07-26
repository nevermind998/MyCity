import 'package:mob_app/models/Slika.dart';
import 'package:mob_app/models/TekstualnaObjava.dart';

class BojaProfila{
  int id;
  String main_boja;
  String tamnija_boja;
  String senka;

  BojaProfila({this.id, this.main_boja, this.tamnija_boja, this.senka});
  
  factory BojaProfila.fromJson(Map<String, dynamic> json){
    return BojaProfila(
      id: json['id'],
      main_boja: json['main_boja'],
      tamnija_boja: json['tamnija_boja'],
      senka: json['senka']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['main_boja'] = main_boja;
    map['tamnija_boja'] = tamnija_boja;
    map['senka'] = senka;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  BojaProfila.fromObject(dynamic o){
    this.id = o["id"];
    this.main_boja = o["main_boja"];
    this.tamnija_boja = o["tamnija_boja"];
    this.senka = o["senka"];
  }

}