
class Statistika{
  int idGrada;
  int brojKorisnika;
  int brojGradjana;
  int brojInstitucija;
  int brojResenihProblema;
  int brojNeresenihProblema;
  int ukupanBroj;
  int brojPrijavljenihObjava;


  Statistika({this.idGrada, this.brojKorisnika,this.brojGradjana,this.brojInstitucija, this.brojResenihProblema,this.brojNeresenihProblema,this.ukupanBroj,this.brojPrijavljenihObjava});

  factory Statistika.fromJson(Map<String, dynamic> json){
    return Statistika(
        idGrada: json['idGrada'],
        brojKorisnika: json['brojKorisnika'],
        brojGradjana: json['brojGradjana'],
        brojInstitucija: json['brojInstitucija'],
        brojResenihProblema: json['brojResenihProblema'],
        brojNeresenihProblema: json['brojNeresenihProblema'],
        ukupanBroj:json['ukupnanBroj'],
        brojPrijavljenihObjava: json['brojPrijavljenihObjava']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['brojGradjana'] = brojGradjana;
    map['brojInstitucija'] = brojInstitucija;
    map['brojKorisnika'] = brojKorisnika;
    map['brojResenihProblema'] = brojResenihProblema;
    map['brojNeresenihProblema'] = brojNeresenihProblema;
    map['ukupnanBroj'] = ukupanBroj;
    map['brojPrijavljenihObjava'] = brojPrijavljenihObjava;
    if(idGrada != null){
      map["idGrada"] = idGrada;
    }
    return map;
  }

  Statistika.fromObject(dynamic o){
    this.idGrada = o["idGrada"];
    this.brojNeresenihProblema = o["brojNeresenihProblema"];
    this.brojResenihProblema = o["brojResenihProblema"];
    this.brojInstitucija = o["brojInstitucija"];
    this.brojGradjana = o["brojGradjana"];
    this.brojKorisnika = o["brojKorisnika"];
    this.ukupanBroj = o["ukupnanBroj"];
    this.brojPrijavljenihObjava = o["brojPrijavljenihObjava"];
  }

}

class TopGrad{
  int idGrada;
  String nazivGrada;
  int brojPoena;
  int ukupno;

  TopGrad({this.idGrada,this.nazivGrada,this.brojPoena,this.ukupno});

  factory TopGrad.fromJson(Map<String, dynamic> json){
    return TopGrad(
        idGrada: json['idGrada'],
        nazivGrada: json['nazivGrada'],
        ukupno: json['ukupno'],
        brojPoena: json['brojPoena']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['nazivGrada'] = nazivGrada;
    map['brojPoena'] = brojPoena;
    map['ukupno'] = ukupno;

    if(idGrada != null){
      map["idGrada"] = idGrada;
    }
    return map;
  }

  TopGrad.fromObject(dynamic o){
    this.idGrada = o["idGrada"];
    this.nazivGrada = o["nazivGrada"];
    this.brojPoena = o["brojPoena"];
    this.ukupno = o["ukupno"];
  }

}

class TopKorisnik{
  int idKorisnika;
  String username;
  int brojPoena;

  TopKorisnik({this.idKorisnika,this.username,this.brojPoena});

  factory TopKorisnik.fromJson(Map<String, dynamic> json){
    return TopKorisnik(
        idKorisnika: json['idKorisnika'],
        username: json['username'],
        brojPoena: json['brojPoena']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['username'] = username;
    map['brojPoena'] = brojPoena;


    if(idKorisnika != null){
      map["idKorisnika"] = idKorisnika;
    }
    return map;
  }

  TopKorisnik.fromObject(dynamic o){
    this.idKorisnika = o["idKorisnika"];
    this.username = o["username"];
    this.brojPoena = o["brojPoena"];
  }

}

class TabelaObjava{

  int brojResenihObjava;
  int brojNeresenihObjava;
  int prosecnaBrojLajkovaR;
  int prosecnaBrojDislajkovaR;
  int prosecnaBrojPrijavaR;
  int prosecnaBrojKomentaraR;
  int prosecnaBrojLajkovaN;
  int prosecnaBrojDislajkovaN;
  int prosecnaBrojPrijavaN;
  int prosecnaBrojKomentaraN;

  TabelaObjava({this.brojResenihObjava, this.brojNeresenihObjava, this.prosecnaBrojLajkovaR, this.prosecnaBrojDislajkovaR, this.prosecnaBrojPrijavaR, this.prosecnaBrojKomentaraR, this.prosecnaBrojLajkovaN, this.prosecnaBrojDislajkovaN, this.prosecnaBrojPrijavaN, this.prosecnaBrojKomentaraN});

}

class TopKategorija{
  int idKategorije;
  String imeKategorije;
  int ukupanBroj;
  int brojResenihProblema;
  int brojNeresenihProblema;

  TopKategorija({this.idKategorije,this.imeKategorije,this.ukupanBroj,this.brojResenihProblema,this.brojNeresenihProblema});

  factory TopKategorija.fromJson(Map<String, dynamic> json){
    return TopKategorija(
        idKategorije: json['idKategorije'],
        imeKategorije: json['imeKategorije'],
        ukupanBroj: json['ukupnanBroj'],
        brojResenihProblema: json['brojResenihProblema'],
        brojNeresenihProblema: json['brojNeresenihProblema']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['imeKategorije'] = imeKategorije;
    map['ukupnanBroj'] = ukupanBroj;
    map['brojResenihProblema'] = brojResenihProblema;
    map['brojNeresenihProblema'] = brojNeresenihProblema;

    if(idKategorije != null){
      map["idKategorije"] = idKategorije;
    }
    return map;
  }

  TopKategorija.fromObject(dynamic o){
    this.idKategorije = o["idKategorije"];
    this.imeKategorije = o["imeKategorije"];
    this.ukupanBroj = o["ukupnanBroj"];
    this.brojResenihProblema = o["brojResenihProblema"];
    this.brojNeresenihProblema = o["brojNeresenihProblema"];
  }

}

/*
  factory TabelaObjava.fromJson(Map<String, dynamic> json){
    return TabelaObjava(
        brojResenihObjava = json['brojResenihObjava'],
        brojNeresenihObjava = json['brojNeresenihObjava'],
        prosecnaBrojLajkovaR = json['prosecnaBrojLajkovaR'],
        prosecnaBrojDislajkovaR = json['prosecnaBrojDislajkovaR'],
        prosecnaBrojPrijavaR = json['prosecnaBrojPrijavaR'],
        prosecnaBrojKomentaraR = json['prosecnaBrojKomentaraR'],
        prosecnaBrojLajkovaN = json['prosecnaBrojLajkovaN'],
        prosecnaBrojDislajkovaN = json['prosecnaBrojDislajkovaN'],
        prosecnaBrojPrijavaN = json['prosecnaBrojPrijavaN'],
        prosecnaBrojKomentaraN = json['prosecnaBrojKomentaraN']
    );
  }
 */