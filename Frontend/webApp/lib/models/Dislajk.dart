class Dislajk{
  int id;
  int idKorisnika;
  int idObjave;

  Dislajk({this.id, this.idKorisnika, this.idObjave});
  
  factory Dislajk.fromJson(Map<String, dynamic> json){
    return Dislajk(
      id: json['id'],
      idKorisnika: json['idKorisnika'],
      idObjave: json['idObjave']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['idKorisnika'] = idKorisnika;
    map['idObjave'] = idObjave;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Dislajk.fromObject(dynamic o){
    this.id = o["id"];
    this.idKorisnika = o["idKorisnika"];
    this.idObjave = o["idObjave"];
  }

}