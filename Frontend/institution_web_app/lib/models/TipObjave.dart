class TipObjave{
  int id;
  String vrsta;

  TipObjave({this.vrsta});
  
  factory TipObjave.fromJson(Map<String, dynamic> json){
    return TipObjave(
      vrsta: json['vrsta']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["vrsta"] = vrsta;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  TipObjave.fromObject(dynamic o){
    this.id = o["id"];
    this.vrsta = o["vrsta"];
  }

}