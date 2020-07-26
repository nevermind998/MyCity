import 'package:mob_app/models/Slika.dart';
import 'package:mob_app/models/TekstualnaObjava.dart';

class KategorijaObjave{
  int id;
  String kategorija;

  KategorijaObjave({this.id, this.kategorija});
  
  factory KategorijaObjave.fromJson(Map<String, dynamic> json){
    return KategorijaObjave(
      id: json['id'],
      kategorija: json['kategorija']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['kategorija'] = kategorija;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  KategorijaObjave.fromObject(dynamic o){
    this.id = o["id"];
    this.kategorija = o["kategorija"];
  }

}