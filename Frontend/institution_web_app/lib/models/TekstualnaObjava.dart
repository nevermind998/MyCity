class TekstualnaObjava{
  int id;
  int idObjave;
  String tekst;
  String vreme;

  TekstualnaObjava({this.idObjave, this.tekst,this.vreme});
  
  factory TekstualnaObjava.fromJson(Map<String, dynamic> json){
    return TekstualnaObjava(
      idObjave: json['objaveID'],
      tekst: json['tekst'],
      vreme: json['vreme']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["objaveID"] = idObjave;
    map["tekst"] = tekst;
    map["vreme"] = vreme;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  TekstualnaObjava.fromObject(dynamic o){
    this.id = o["id"];
    this.idObjave = o["objaveID"];
    this.tekst = o["tekst"];
    this.vreme = o["vreme"];
  }

}