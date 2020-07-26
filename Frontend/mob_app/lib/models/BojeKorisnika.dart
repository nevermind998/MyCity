

import 'package:mob_app/models/BojaProfila.dart';

class BojeKorisnika{
  int id;
  List<BojaProfila> boje = List<BojaProfila>();
  BojaProfila bojaKorisnika;
  int razlika;

  BojeKorisnika({this.id, this.boje, this.bojaKorisnika, this.razlika});
  
  factory BojeKorisnika.fromJson(Map<String, dynamic> json){
    return BojeKorisnika(
      id: json['id'],
      boje: json['boje'],
      bojaKorisnika: json['bojaKorisnika'],
      razlika: json['razlika']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['boje'] = boje;
    map['bojaKorisnika'] = bojaKorisnika;
    map['razlika'] = razlika;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  BojeKorisnika.fromObject(dynamic o){
    this.id = o["id"];
    
    if(o["boje"] != null){
      var rest = o["boje"] as List;
      this.boje = rest.map<BojaProfila>((e) => BojaProfila.fromObject(e)).toList();
    }

    if(o["bojaKorisnika"] != null){
      this.bojaKorisnika = BojaProfila.fromObject(o["bojaKorisnika"]);
    }

    this.razlika = o["poeniDoSledeceBoje"];

  }

}