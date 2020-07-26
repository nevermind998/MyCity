class Kategorija{
  int id;
  String naziv;


  Kategorija({this.id, this.naziv});

  factory Kategorija.fromJson(Map<String, dynamic> json){
    return Kategorija(
      id: json['id'],
      naziv: json['kategorija']

    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['kategorija'] = naziv;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Kategorija.fromObject(dynamic o){
    this.id = o["id"];
    this.naziv = o["kategorija"];
  }
}