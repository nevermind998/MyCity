import 'package:flutter/material.dart';
import 'package:mob_app/models/KategorijaObjave.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/models/LepeKategorije.dart';
import 'package:mob_app/models/Pomocna.dart';
import 'package:mob_app/models/Slika.dart';
import 'package:mob_app/models/TekstualnaObjava.dart';

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
  int resena;
  double latitude;
  double longitude;
  int idGrada;
  String vreme;
  Pomocna objave;
  List<KategorijaObjave> kategorije;
  LepeKategorije lepaKategorija;

  Objava({this.id, this.tekstualna_objava, this.slika, this.idKorisnika, this.vlasnik,
  this.brojLajkova,
  this.brojDislajkova,
  this.brojKomentara,
  this.korisnikLajkovao,
  this.korisnikaDislajkovao,
  this.korisnikReportovao,
  this.latitude,
  this.longitude,
  this.resena,
  this.idGrada,
  this.vreme,
  this.objave,
  this.kategorije,
  this.lepaKategorija
  });
  
  factory Objava.fromJson(Map<String, dynamic> json){
    return Objava(
      id: json['idObjave'],
      tekstualna_objava: json['brojLajkova'],
      slika: json['brojDislajkova'],
      idKorisnika: json['idKorisnika'],
      vlasnik: json['vlasnikObjave']
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
      //this.vreme = this.tekstualna_objava.pomocna.vreme.split('T')[0];
    }
    else{
      this.tekstualna_objava = null;
    }

    if(o["slika"] != null){
      this.slika = new Slika.fromObject(o["slika"]);
      this.latitude = this.slika.georeferenciranjeX;
      this.longitude = this.slika.georeferenciranjeY;
      //this.vreme = this.slika.pomocna.vreme.split('T')[0];
    }
    else
      this.slika = null;

    if(o["vlasnikObjave"] != null){
      this.vlasnik = new Korisnik.fromObject(o["vlasnikObjave"]);
    }else{
      this.vlasnik = null;
    }

    

    this.id = o["idObjave"];
    this.brojLajkova = o["brojLajkova"];
    this.brojDislajkova = o["brojDislajkova"];
    this.brojKomentara = o["brojKomentara"];
    this.korisnikLajkovao = o["aktivanKorisnikLajkovao"];
    this.korisnikaDislajkovao = o["aktivanKorisnikDislajkovao"];
    this.korisnikReportovao = o["aktivanKorisnikReport"];
    this.resena = o["resenaObjava"];
    this.vreme = o["vreme2"];
    
    if(o["lepaStvar"] != null){
      this.lepaKategorija = new LepeKategorije.fromObject(o["lepaStvar"]);

      if(this.lepaKategorija.kategorija == "Pohvale"){
        this.lepaKategorija.boja = Color(0xFF59b300);
        this.lepaKategorija.stiker = AssetImage('images/clapping.png');
      }else
      if(this.lepaKategorija.kategorija == "Događaji"){
        this.lepaKategorija.boja = Color(0xFF99004d);
        this.lepaKategorija.stiker = AssetImage('images/calendar.png');
      }else
      if(this.lepaKategorija.kategorija == "Građanska inicijativa"){
        this.lepaKategorija.boja = Color(0xFFff9900);
        this.lepaKategorija.stiker = AssetImage('images/crowd.png');
      }

      this.kategorije = null;
    }else if(o["kategorije"] != null){
      this.lepaKategorija = null;
      var rest = o["kategorije"] as List;
      this.kategorije = rest.map<KategorijaObjave>((e) => KategorijaObjave.fromObject(e)).toList();
    }




    this.idKorisnika = o["idKorisnika"];
  }

}