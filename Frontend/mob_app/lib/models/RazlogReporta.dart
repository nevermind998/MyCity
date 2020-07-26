import 'package:mob_app/models/Slika.dart';
import 'package:mob_app/models/TekstualnaObjava.dart';

class RazlogReporta{
  int id;
  String razlog;

  RazlogReporta({this.id, this.razlog});
  
  factory RazlogReporta.fromJson(Map<String, dynamic> json){
    return RazlogReporta(
      id: json['id'],
      razlog: json['razlog']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['razlog'] = razlog;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  RazlogReporta.fromObject(dynamic o){
    this.id = o["id"];
    this.razlog = o["razlog"];
  }

}