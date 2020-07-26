import './Dislajk.dart';
import './Komentar.dart';
import './Lajk.dart';
import './Report.dart';

class AktivnostiKorisnika{
  List<Lajk> lajkovi;
  List<Dislajk> dislajkovi;
  List<Komentar> komentari;
  List<Report> reportovi;

  AktivnostiKorisnika(List<Lajk> _lajkovi, List<Dislajk> _dislajkovi, List<Komentar> _komentari, List<Report> _reportovi){
    this.lajkovi = _lajkovi;
    this.dislajkovi = _dislajkovi;
    this.komentari = _komentari;
    this.reportovi = _reportovi;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["lajkovi"] = lajkovi;
    map["dislajkovi"] = dislajkovi;
    map['komentari'] = komentari;
    map['reportovi'] = reportovi;
    
    return map;
  }

  AktivnostiKorisnika.fromObject(dynamic o){
    if(o["lajkovi"] != null){
      Iterable list = o["lajkovi"];
      print(list.length);
      this.lajkovi = new List<Lajk>();
      for(var i=0; i<o["lajkovi"].length; i++){
        this.lajkovi.add(o["lajkovi"][i]);
      }
    }

    if(o["dislajkovi"] != null){
      print("usao u dislajkove");
      this.dislajkovi = new List<Dislajk>();
      for(var i=0; i<o["dislajkovi"].length; i++){
        this.dislajkovi.add(o["dislajkovi"][i]);
      }
    }

    if(o["komentari"] != null){
      print("usao u komentare");
      this.komentari = new List<Komentar>();
      for(var i=0; i<o["komentari"].length; i++){
        this.komentari.add(o["komentari"][i]);
      }
    }

    if(o["reportovi"] != null){
      print("usao u reportove");
      this.reportovi = new List<Report>();
      for(var i=0; i<o["reportovi"].length; i++){
        this.reportovi.add(o["reportovi"][i]);
      }
    }

  }

}