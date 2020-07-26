import './Korisnik.dart';
import './Slika.dart';
import './TekstualnaObjava.dart';
import './Grad.dart';

class Objava{
  int id;
  int idTipa;
  int idKorisnika;
  Korisnik vlasnik;
  TekstualnaObjava tekstualna_objava;
  Slika slika;
  int brojLajkova;
  int brojDislajkova;
  int brojKomentara;
  int korisnikLajkovao;
  int korisnikaDislajkovao;
  int korisnikReportovao;
  double latitude;
  double longitude;
  Grad grad;
String vreme;
  int lepaStvarID;
  int resena;
  Objava({this.id, this.tekstualna_objava, this.slika, this.idKorisnika, this.vlasnik,
  this.brojLajkova,
  this.brojDislajkova,
  this.brojKomentara,
  this.korisnikLajkovao,
  this.korisnikaDislajkovao,
  this.korisnikReportovao,
  this.latitude,
  this.longitude,
  this.grad,
    this.vreme,
    this.lepaStvarID,
    this.resena
  });
  
  factory Objava.fromJson(Map<String, dynamic> json){
    return Objava(
      id: json['id'],
      tekstualna_objava: json['tekstualna_objava'],
      slika: json['slika'],
      idKorisnika: json['idKorisnika'],
      vlasnik: json['vlasnikObjave'] ,
        vreme: json['vreme2'],
        lepaStvarID: json['lepaStvarID']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["tekstualna_objava"] = tekstualna_objava;
    map["slika"] = slika;
    map['idKorisnika'] = idKorisnika;
    map['vlasnikObjave'] = vlasnik;
    map['vreme2'] = vreme;
    map['lepaStvarID'] = lepaStvarID;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Objava.fromObject(dynamic o){
    if(o["tekstualna_objava"] != null){
      this.tekstualna_objava = new TekstualnaObjava.fromObject(o["tekstualna_objava"]);
      this.id = this.tekstualna_objava.idObjave;
    }
    else{
      this.tekstualna_objava = null;
    }

    if(o["slika"] != null){
      this.slika = new Slika.fromObject(o["slika"]);
      this.id = this.slika.idObjave;
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
    this.lepaStvarID = o["lepaStvarID"];
    this.resena = o["resenaObjava"];

    if(o["grad"]!=null)
    {
      this.grad=new Grad.fromObject(o["grad"]);
    }
    else
    {
      this.grad=null;
    }

    this.idKorisnika = o["idKorisnika"];
  }

}