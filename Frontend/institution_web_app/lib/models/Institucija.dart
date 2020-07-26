class Institucija
{
  int id;
  String broj_telefona;
  String username; 
  String password;
  String naziv ;
  String biografija;
  String city;
  String urlSlike;
  String token;


  Institucija({this.broj_telefona,this.username,this.password,this.naziv,this.biografija,this.city,this.urlSlike=null,this.token=null});

  factory Institucija.fromJson(Map<String, dynamic> json){
    return Institucija(
      broj_telefona: json['broj_telefona'],
      username: json['username'],
      password: json['password'],
      biografija: json['biografija'],
      naziv: json['naziv'],
	    urlSlike: json['urlSlike'],
      token: json['token']
	  
    );
  }

    Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["broj_telefona"] = broj_telefona;
    map["username"] = username;
    map["password"] = password;
    map["biografija"] = biografija;	
    map["naziv"] = naziv;
    map["urlSlike"] = urlSlike;
    map["token"] = token;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

    Institucija.fromObject(dynamic o){
    this.id = o["id"];
    this.broj_telefona = o["broj_telefona"];
    this.biografija = o["biografija"];
  	this.username = o["username"];
    this.password = o["password"];
  	this.urlSlike = o["urlSlike"];
    this.naziv = o["naziv"];
    this.token = o["token"];
  }


}