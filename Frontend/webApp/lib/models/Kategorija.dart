class Kategorija{
  int id;
  String kategorija;

  Kategorija({this.id, this.kategorija});

  factory Kategorija.fromJson(Map<String, dynamic> json){
    return Kategorija(
        id: json['id'],
        kategorija: json['kategorija']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['kategorija'] = kategorija;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Kategorija.fromObject(dynamic o){
    this.id = o["id"];
    this.kategorija = o["kategorija"];
  }

}