class Grad{
  int id;
  String naziv_grada_lat;
  String naziv_grada_cir;

  Grad({this.id, this.naziv_grada_lat,this.naziv_grada_cir});
  
  factory Grad.fromJson(Map<String, dynamic> json){
    return Grad(
      id: json['id'],
      naziv_grada_lat: json['naziv_grada_lat'],
      naziv_grada_cir: json['naziv_grada_cir'],
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['naziv_grada_lat'] = naziv_grada_lat;
    map['naziv_grada_cir'] = naziv_grada_cir;


    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Grad.fromObject(dynamic o){
    this.id = o["id"];
    this.naziv_grada_lat = o["naziv_grada_lat"];
    this.naziv_grada_cir = o["naziv_grada_cir"];
  }

}