import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webApp/models/Grad.dart';
import 'package:webApp/models/Kategorije.dart';
import '../models/Institucija.dart';
import 'dart:ui' ;
import 'kodPage.dart';
import 'loginPage.dart';
import '../services/api_services.dart';
import 'package:google_fonts/google_fonts.dart' as gf;



class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  @override
  bool greska_kod_registrovanja=false;
  double visina=40;
  double sirina=250;
  bool zaregistraciju=false;
  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();

List<Kategorija> kategorije=List<Kategorija>();
List<Kategorija> izabrane_kategorije=List<Kategorija>();
Kategorija selectedkat=Kategorija();
Kategorija selectedizakat=Kategorija();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordAgainController = TextEditingController();
  TextEditingController _nazivController = TextEditingController();
  TextEditingController _kontaktController = TextEditingController();
  TextEditingController _biografijaController = TextEditingController();

  static bool registracija=false;




  api_services servis = new api_services();
  List<Grad>gradovi=List<Grad>();
Grad selected=Grad();
  void dajGradove() {
    servis.dajGradove().then((response) {

      Iterable list = json.decode(response.body);
      setState(() {

        gradovi=list.map((model) => Grad.fromObject(model)).toList();
        selected=gradovi[0];

      });
    });
  }
  void dajKategorije() {
    servis.fetchDajKategorije().then((response) {

      Iterable list = json.decode(response.body);
      setState(() {

        kategorije=list.map((model) => Kategorija.fromObject(model)).toList();
        selectedkat=kategorije[0];

      });
    });
  }
  List<DropdownMenuItem<Grad>> buildDropdownMenuItems(List _gradovi) {
    List<DropdownMenuItem<Grad>> items = List();

    for (Grad grad in _gradovi) {
      items.add(
        DropdownMenuItem(
          value: grad,
          child:_buildText(grad.naziv_grada_lat,sirina1<500?12:16+(sirina/250),0),
        ),
      );
    }
    return items;
  }
  List<DropdownMenuItem<Kategorija>> buildDropdownMenuItemsKategorije(List _kategorije) {
    List<DropdownMenuItem<Kategorija>> items = List();

    for (Kategorija kat in _kategorije) {
      items.add(
        DropdownMenuItem(
          value: kat,
          child:_buildText(kat.naziv,sirina1<500?12:16+(sirina/250),0),
        ),
      );
    }
    return items;
  }
  Widget _buildNaziv()
  {
    return  Container(
      width: sirina1/(sirina1/400),
      child: TextFormField(
        controller: _nazivController,
        style: gf.GoogleFonts.ubuntu(),
        decoration: InputDecoration(
            hintText: "Naziv:",
          prefixIcon: Padding(child: Icon(Icons.account_balance, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (String value ){
          if(value.isEmpty)
          {
            return "Nije unet Naziv.";
          }
          if(!RegExp("^[0-9a-zA-Z .ČčĆćŽžŠšĐđ]{1,}").hasMatch(value))
          {
            return "Naziv nije lepo unet.";
          }

          return null;
        },
        onSaved: (String value){

        },
      ),

    );
  }
  Widget _buildKontakt()
  {
    return  Container(
      width:sirina1/(sirina1/400),
      child: TextFormField(
        controller: _kontaktController,
        style: gf.GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          hintText: "Email:",
          prefixIcon: Padding(child: Icon(Icons.phone, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (String value ){
          if(!RegExp("^[0-9a-zA-Z .ČčĆćŽžŠšĐđ]{1,}[@][a-z]{1,10}.com").hasMatch(value))
          {
            return "Uneti format something@something.com.";
          }
          return null;
        },
        onSaved: (String value){

        },

      ),
    );
  }

  Widget _buildBiografija()
  {
    return  Container(
      width: sirina1/(sirina1/400),
      child: TextFormField(
        controller: _biografijaController,
        style: gf.GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          hintText: "O Instituciji:",
          counterText:"Nije obavezno",
          counterStyle: TextStyle(color: Colors.red),
          prefixIcon: Padding(child: Icon(Icons.description, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (String value ){
          return null;
        },
        onSaved: (String value){

        },
      ),
    );
  }
  Widget _buildGrad()
  {
    return         Container(
      width: 250,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromRGBO(42, 184, 115, 1),
        borderRadius:BorderRadius.all(Radius.circular(50))
    ),
      child: DropdownButtonHideUnderline(
        child: new Theme(
          data: Theme.of(context).copyWith(
            canvasColor:Color.fromRGBO(42, 184, 115, 1)
          ),
          child: new DropdownButton(

              items: buildDropdownMenuItems(gradovi),
              value: selected,
              onChanged: (value) {
                setState(() {
                  selected = value;
                });
              }),
        ),
      ),
    );
  }
  Widget _buildKategorije()
  {
    return         Container(
        width: sirina1<400? 350:400,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color.fromRGBO(42, 184, 115, 1),
            borderRadius:BorderRadius.all(Radius.circular(50))
        ),
        child: DropdownButtonHideUnderline(

          child: new Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Color.fromRGBO(42, 184, 115, 1)

            ),
            child: new DropdownButton(
                items: buildDropdownMenuItemsKategorije(kategorije),
                value: selectedkat,
                onChanged: (value) {
                  setState(() {
                    selectedkat = value;
                    int a=1;

                    //  gradovi.removeWhere((element) => element.id==selected.id);
                    for(int i=0;i<izabrane_kategorije.length;i++)
                    {
                      if(izabrane_kategorije[i].id==selectedkat.id)
                      {
                        _showDialogAdmin("Ova kategorija je već izabrana.","Molimo Vas izaberite ponovo." );
                        a=0;
                        break;
                      }
                    }
                    if(a==1)
                    {
                      izabrane_kategorije.add(selectedkat);
                    }

                  });
                  _buildKategorije();
                }),
          ),)
    );
  }


  void _showDialogAdmin(String str1,String str2) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: _buildText(str1,18,1),
          content: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                _buildText(str2,18,1),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child:  _buildText("Zatvori",18,1),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildKorisnickoIme()
  {
    return  Container(
      width: sirina1/(sirina1/400),
      child: TextFormField(
        controller: _usernameController,
          style: gf.GoogleFonts.ubuntu(),
          decoration: InputDecoration(
            hintText: "Korisničko ime:",
            prefixIcon: Padding(child: Icon(Icons.account_circle, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
            hintStyle: gf.GoogleFonts.ubuntu(
              color: Colors.grey,
              fontSize: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        validator: (String value ){
          if(value.isEmpty)
          {
            return "Nije uneto Korisničko ime.";
          }
          if(!RegExp("^[A-Za-z0-9._ ]{1,}").hasMatch(value))
          {
            return "Niste lepo uneli Korisničko ime.";
          }
          return null;
        },
        onSaved: (String value){
        },
      ),
    );
  }



  Widget printkategorije() {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (sirina1-200.0 > 1200) ? 4
              :(sirina1-200.0 > 800?3:sirina1-200.0 > 600?2:1),
          crossAxisSpacing: 5,
          childAspectRatio:2.3,
        ),
        //physics: NeverScrollableScrollPhysics(),
        itemCount: izabrane_kategorije.length,
        itemBuilder: (context, index) {
          return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Text(
                    izabrane_kategorije[index].naziv,style:gf.GoogleFonts.ubuntu(fontSize:16+(sirina/250)),
                  ),
                  IconButton(icon: Icon(Icons.close),
                    onPressed: (){
                      setState(() {
                        if(izabrane_kategorije.length>1)
                        {
                          izabrane_kategorije.removeAt(index);
                          printkategorije();
                        }
                        else{
                          _showDialogAdmin("Morate izmati barem jedanu izabranu kategoriju.","" );
                        }

                      });

                    },
                  )
                ],
              )
          );
        }
    );
  }







  Widget _buildSifra()
  {
    return  Container(
      width: sirina1/(sirina1/400),
      child: TextFormField(

        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword ,
        obscureText: true,
        style: gf.GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          hintText: "Unesite šifru:",
          prefixIcon: Padding(child: Icon(Icons.security, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (String value ){
          if(value.isEmpty)
          {
            return "Nije uneta Šifra.";
          }
          if(value.length<6)
          {
            return "Šifra mora imati više od 6 karaktera.";
          }
          _formKey.currentState.save();
          return null;
        },
        onSaved: (String value){
        },
      ),
    );
  }
  Widget _buildSifraPonovo()
  {
    return  Container(
      width:sirina1/(sirina1/400),
      child: TextFormField(
        controller: _passwordAgainController,
        obscureText: true,
        style: gf.GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          hintText: "Unesite ponovo šifru:",
          prefixIcon: Padding(child: Icon(Icons.security, size:30.0),padding:EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 2.0)),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          hintStyle: gf.GoogleFonts.ubuntu(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (String value ){

          if(value != _passwordController.text)
          {
            return "Šifre se ne poklapaju.";
          }
          else{
            if(value.isEmpty)
            {
              return "Nije uneta Šifra.";
            }
            if(value.length<6)
            {
              return "Šifra mora imati više od 6 karaktera!";
            }
            return null;
          }
        },
        onSaved: (String value){
        },
      ),
    );
  }

  Widget _buildText(String str,double size,int broj )
  {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child:Text(str,style:gf.GoogleFonts.ubuntu(color:broj==1?Color.fromRGBO(42, 184, 115, 1):broj==2?Colors.red:Colors.white,fontSize: size,fontWeight: FontWeight.bold),)
    );

  }
  int kod=0;
  Widget _buildDugmeZaRegistraciju()
  {
    return    Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5.0),
      child:RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          textColor: Colors.white,
          color:Color.fromRGBO(42, 184, 115, 1),
          child:_buildText("Registracija",16+sirina/250,0),
          onPressed:() {

            if(izabrane_kategorije.length==0)
              {
                _showDialogAdmin("Niste odabrali kategorije.", "Molimo Vas izaberite.");
              }
            else{

              if(!_formKey.currentState.validate())
              {
                return null;
              }
              else{
                setState(() {
                  zaregistraciju=true;

                });

                List<int>kategorijee=List<int>();
                for(int i=0;i<izabrane_kategorije.length;i++)
                {
                  setState(() {
                    kategorijee.add(izabrane_kategorije[i].id);
                  });
                }
                var bytes = utf8.encode(_passwordController.text);
                var sif = sha1.convert(bytes);
                var body= jsonEncode(
                    {
                      "korisnik": {
                        "ime": _nazivController.text,
                        "biografija": _biografijaController.text==""?null:_biografijaController.text,
                        "email": _kontaktController.text,
                        "username": _usernameController.text,
                        "password": sif.toString()
                      },
                      "idGradova": [selected.id],
                      "idKategorija":kategorijee
                    }
                );
              
                if(registracija==false)
                  {
                    setState(() {
                      registracija=true;
                    });
                    api_services().registration(body,context);

                  }

              }
            }



          }
      ),
    );
  }


  Widget _buildDugmeZaVracanje()
  {
    return    Container(
      padding: const EdgeInsets.all(5.0),
      alignment: Alignment.center,
      child:RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          textColor: Colors.white,
          color: Color.fromRGBO(42, 184, 115, 1),
          child:_buildText("Prijava",16+sirina/250,0),
          onPressed:() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
      ),
    );
  }

  Widget prikazKategorija() {
    return Container(
      width: 300,

      //alignment: Alignment.center,
      margin: EdgeInsets.only(top:20) ,


      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: izabrane_kategorije.length,
          itemBuilder: (context, index) {
            return GestureDetector(
             child:Container(
               alignment: Alignment.center,
               width: 300,
               child: Text(izabrane_kategorije[index].naziv),
             )
            );
          }),
    );
  }
double sirina1;
  Widget _buildSlika(String str)
  {
    return Container(

      child: Image.asset(
          str, height: 250.0,
          width: 200.0),
    );
  }
  Widget build(BuildContext context) {
    if(gradovi.length==0)
      dajGradove();
    if(kategorije.length==0)
      dajKategorije();
    sirina1=MediaQuery.of(context).size.width;
    return Scaffold(

      body: Scrollbar(

        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                 Container(
                  margin: EdgeInsets.all(25),
                  alignment: Alignment.center,

                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              _buildSlika('images/logo_aplikacija.jpg'),
                              _buildText("Moj Grad", 20+sirina1/250,1),
                              SizedBox(
                                height: 10,
                              ),
                              _buildNaziv(),
                              SizedBox(
                                height: 10,
                              ),
                              _buildKontakt(),
                              SizedBox(
                                height: 10,
                              ),
                              _buildBiografija(),
                              SizedBox(
                                height: 10,
                              ),
                              _buildText("Grad:",17+sirina1/250,1),
                              _buildGrad(),
                              SizedBox(
                                height: 10,
                              ),
                              Container(child:
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: _buildText("*  Oblast delatnosti:", 16+sirina1/250,1),
                                  ),
),
                              _buildKategorije(),
                              SizedBox(
                                height: 10,
                              ),
                              _buildText("Izabrane delatnosti:", 16+sirina1/250,1),

                              izabrane_kategorije.length>0?Container( width: sirina1/1.4,
                                  child: printkategorije()):Container(
                                padding: EdgeInsets.all(10),
                                child: _buildText("Morate imati barem jednu izabranu kategoriju", 14+sirina1/250,2),
                              ),


                              _buildKorisnickoIme(),
                              SizedBox(
                                height: 10,
                              ),
                              _buildSifra(),
                              SizedBox(
                                height: 10,
                              ),
                              _buildSifraPonovo(),

                              _buildDugmeZaRegistraciju(),
                              _buildDugmeZaVracanje(),


                              Container(padding:EdgeInsets.only(top: 10),
                                        child: _buildText("*  Na početnoj strani biće Vam prikazane objave iz odabranih delatnosti.",14+sirina1/250,1)),

                              //   _buildSlika('images/logo_tima.png'),
                            ],
                          ),
                        ),
                      ),

                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

}




