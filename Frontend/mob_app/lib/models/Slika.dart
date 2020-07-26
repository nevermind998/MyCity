import 'package:mob_app/models/Grad.dart';
import 'package:mob_app/models/Pomocna.dart';

class Slika{
  int id;
  int idObjave;
  double georeferenciranjeX;
  double georeferenciranjeY;
  String opis_slike;
  String urlSlike;
  int idGrada;
  Pomocna pomocna;

  Slika({this.id,this.idObjave,this.georeferenciranjeX,this.georeferenciranjeY,this.opis_slike,this.urlSlike,this.idGrada, this.pomocna});

  factory Slika.fromJson(Map<String, dynamic> json){
    return Slika(
      //id: json['id'],
      idObjave: json['idObjave'],
      georeferenciranjeX: json['georeferenciranjeX'],
      georeferenciranjeY: json['georeferenciranjeY'],
      opis_slike: json['opis_slike'],
      urlSlike: json['urlSlike']
    );
  }

   Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["idObjave"] = idObjave;
    map["georeferenciranjeX"] = georeferenciranjeX;
    map["georeferenciranjeY"] = georeferenciranjeY;
    map["opis_slike"] = opis_slike;
    map["urlSlike"] = urlSlike;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

    Slika.fromObject(dynamic o){
    this.id = o["id"];
    this.idObjave = o["idObjave"];
    if(o["x"] == 0){
      this.georeferenciranjeX = 0.0;
    }else{
      this.georeferenciranjeX = o["x"];
    }
    if(o["y"] == 0){
      this.georeferenciranjeY = 0.0;
    }else{
      this.georeferenciranjeY = o["y"];
    }
    this.opis_slike = o["opis_slike"];
    this.urlSlike = o["urlSlike"];
    this.pomocna = new Pomocna.fromObject(o["objave"]);
  }

}