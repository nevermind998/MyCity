import './Korisnik.dart';
import './Slika.dart';
import './TekstualnaObjava.dart';

class Objava{
  int id;
  int idTipa;
  int idKorisnika;
  Korisnik vlasnik;
  TekstualnaObjava tekstualna_objava;
  Slika slika;
  int brojLajkova;
  int brojReporta;
  int brojDislajkova;
  int brojKomentara;
  int resenaObjava;
  int korisnikLajkovao;
  int korisnikaDislajkovao;
  int korisnikReportovao;
  double latitude;
  double longitude;
  String vreme;
  Objava({this.id, this.tekstualna_objava, this.slika, this.idKorisnika, this.vlasnik,
  this.brojLajkova,
  this.brojReporta,
  this.brojDislajkova,
  this.brojKomentara,
    this.resenaObjava,
  this.korisnikLajkovao,
  this.korisnikaDislajkovao,
  this.korisnikReportovao,
  this.latitude,
  this.longitude,
    this.vreme
  });
  
  factory Objava.fromJson(Map<String, dynamic> json){
    return Objava(
      id: json['id'],
      tekstualna_objava: json['tekstualna_objava'],
      slika: json['slika'],
      idKorisnika: json['idKorisnika'],
      vlasnik: json['vlasnikObjave'],
      vreme: json['vreme2']

    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["tekstualna_objava"] = tekstualna_objava;
    map["slika"] = slika;
    map['idKorisnika'] = idKorisnika;
    map['vlasnikObjave'] = vlasnik;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Objava.fromObject(dynamic o){
    if(o["tekstualna_objava"] != null){
      this.tekstualna_objava = new TekstualnaObjava.fromObject(o["tekstualna_objava"]);
      //this.id = this.tekstualna_objava.idObjave;
    }
    else{
      this.tekstualna_objava = null;
    }

    if(o["slika"] != null){
      this.slika = new Slika.fromObject(o["slika"]);
      //this.id = this.slika.idObjave;
      this.latitude = this.slika.georeferenciranjeX;
      this.longitude = this.slika.georeferenciranjeY;
    }
    else
      this.slika = null;

    if(o["vlasnikObjave"] != null){
      this.vlasnik = new Korisnik.fromObject(o["vlasnikObjave"]);
    }else{
      this.vlasnik = null;
    }

    this.brojLajkova = o["brojLajkova"];
    this.brojDislajkova = o["brojDislajkova"];
    this.brojKomentara = o["brojKomentara"];
    this.korisnikLajkovao = o["aktivanKorisnikLajkovao"];
    this.korisnikaDislajkovao = o["aktivanKorisnikDislajkovao"];
    this.korisnikReportovao = o["aktivanKorisnikReport"];
    this.vreme = o["vreme2"];
    this.brojReporta=o["brojReporta"];
    this.id = o["idObjave"];
    this.idKorisnika = o["idKorisnika"];
    this.resenaObjava=o["resenaObjava"];

  }

}