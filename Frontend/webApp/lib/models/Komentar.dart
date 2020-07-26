import './Korisnik.dart';

class Komentar{
  int id;
  Korisnik korisnik;
  int idObjave;
  String tekst;
  String url_slike;
  int brojLajkova;
  int brojReporta;
  int brojDislajkova;
  int brojKomentara;
  int korisnikLajkovao;
  int korisnikaDislajkovao;
  int korisnikReportovao;
  int oznacenKaoResen;

  Komentar({this.id, this.korisnik, this.idObjave, this.tekst, this.url_slike,
  this.brojLajkova,
    this.brojReporta,
  this.brojDislajkova,
  this.brojKomentara,
  this.korisnikLajkovao,
  this.korisnikaDislajkovao,
  this.korisnikReportovao,
  this.oznacenKaoResen
  });
  
  factory Komentar.fromJson(Map<String, dynamic> json){
    return Komentar(
      id: json['id'],
      korisnik: json['korisnik'],
      idObjave: json['idObjave'],
      tekst: json['tekst'],
      url_slike: json['urlSlike']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['korisnik'] = korisnik;
    map['idObjave'] = idObjave;
    map['tekst'] = tekst;
    map['urlSlike'] = url_slike;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Komentar.fromObject(dynamic o){
    this.id = o["id"];
    this.korisnik = new Korisnik.fromObject(o["korisnik"]);
    this.idObjave = o["idObjave"];
    this.tekst = o["tekst"];
    this.url_slike = o['urlSlike'];
    this.brojLajkova = o["brojLajkova"];
    this.brojDislajkova = o["brojDislajkova"];
    this.oznacenKaoResen = o["oznacenKaoResen"];
    this.brojReporta=o["brojReporta"];
  }

}