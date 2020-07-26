
class Slika{
  int id;
  int idObjave;
  double georeferenciranjeX;
  double georeferenciranjeY;
  String opis_slike;
  String urlSlike;
  String vreme;
  Slika({this.id,this.idObjave,this.georeferenciranjeX,this.georeferenciranjeY,this.opis_slike,this.urlSlike,this.vreme});

  factory Slika.fromJson(Map<String, dynamic> json){
    return Slika(
      //id: json['id'],
      idObjave: json['objaveID'],
      georeferenciranjeX: json['georeferenciranjeX'],
      georeferenciranjeY: json['georeferenciranjeY'],
      opis_slike: json['opis_slike'],
      urlSlike: json['urlSlike'],
        vreme:json['vreme']
    );
  }

   Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["objaveID"] = idObjave;
    map["georeferenciranjeX"] = georeferenciranjeX;
    map["georeferenciranjeY"] = georeferenciranjeY;
    map["opis_slike"] = opis_slike;
    map["urlSlike"] = urlSlike;
    map["vreme"] = vreme;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

    Slika.fromObject(dynamic o){
    this.id = o["id"];
    this.idObjave = o["objaveID"];
    this.georeferenciranjeX = o["x"];
    this.georeferenciranjeY = o["y"];
    this.opis_slike = o["opis_slike"];
    this.urlSlike = o["urlSlike"];
    this.vreme = o["vreme"];
  }

}