import 'package:flutter/material.dart';
import 'package:mob_app/models/Slika.dart';
import 'package:mob_app/models/TekstualnaObjava.dart';

class LepeKategorije{
  int id;
  String kategorija;
  Color boja;
  AssetImage stiker;

  LepeKategorije({this.id, this.kategorija, this.boja, this.stiker});
  
  factory LepeKategorije.fromJson(Map<String, dynamic> json){
    return LepeKategorije(
      id: json['id'],
      kategorija: json['naziv']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['naziv'] = kategorija;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  LepeKategorije.fromObject(dynamic o){
    this.id = o["id"];
    this.kategorija = o["naziv"];
  }

}