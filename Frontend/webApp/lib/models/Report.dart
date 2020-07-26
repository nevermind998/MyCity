class Report{
  int idKorisnika;
  String razlog;
  String username;
  String profilnaSlika;

  Report({this.razlog, this.idKorisnika, this.username,this.profilnaSlika});
  
  factory Report.fromJson(Map<String, dynamic> json){
    return Report(
        razlog: json['razlog'],
      idKorisnika: json['id'],
        profilnaSlika: json['urlSlike'],
        username: json['username']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = idKorisnika;
    map['razlog'] = razlog;
    map['urlSlike'] = profilnaSlika;
    map['username'] = username;

    return map;
  }

  Report.fromObject(dynamic json){
    this.razlog=json['razlog'];
    this.idKorisnika=json['id'];
    this. profilnaSlika=json['urlSlike'];
    this.username= json['username'];
  }

}