import 'package:webApp/models/Korisnik.dart';

class KomentariObjave{

  Korisnik korisnik;
  int idObjave;

  KomentariObjave({this.korisnik,this.idObjave});

    factory KomentariObjave.fromJson(Map<String, dynamic> json){
    return KomentariObjave(
      korisnik: json['korisnik'],
      idObjave: json['idObjave'],
      
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["korisnik"] = korisnik;
    map["idObjave"] = idObjave;

    return map;
  }

  KomentariObjave.fromObject(dynamic o){
    

    if(o["vlasnikObjave"] != null){
      this.korisnik = new Korisnik.fromObject(o["korisnik"]);
    }else{
      this.korisnik = null;
    }

    this.idObjave = o["idObjave"];
  }


}