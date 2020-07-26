import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mob_app/screens/BottomBar.dart';
import 'package:mob_app/screens/RegistrationPage.dart';
import 'package:mob_app/screens/TextPage.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MyLoginPage extends StatefulWidget
{

  MyLoginPageState createState() => MyLoginPageState();
}

class MyLoginPageState extends State<MyLoginPage>
{
  api_services servis = api_services();
  Korisnik user;
  String token = '';

  bool _isHidden = true;
  TextEditingController _zaboravljeni_username = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pomocna_fun();
    //print(pomocna_fun());
    //getToken();
    /*servis.getUser().then((value){
      if(value != null)
        print('Logovan je korisnik' + value.ime + ' ' + value.prezime);
      else
        print('Nije logovan nijedan korisnik');
    });*/
  }

  void _showZaboraviliSifruDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText2('Nova lozinka'),
            content:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildText2('Unesite vaše korisničko ime da bi Vam poslali novu lozinku na e-mail adresu koja je povezana sa korisničkim imenom'),
                SizedBox(height:10),
                TextFormField(
                  controller: _zaboravljeni_username,
                  style:gf.GoogleFonts.ubuntu(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 2.0),
                    hintText: "Korisničko ime",
                    hintStyle: TextStyle(
                      
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),

                  ),
                  //obscureText: hintText == "Unesi sifru:"  ? true : false,
                ),
            ],),
            actions: <Widget>[
              FlatButton(
                child: buildText2('Odustani'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: buildText2('Pošalji'),
                onPressed: () {
                  servis.zaboravljenaSifra(_zaboravljeni_username.text);
                  _showDialogObavestenje("Uspešno je poslata lozinka", context);
                },
              ),
            ],
          );
        });
  }

  void _showDialogObavestenje(String text, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText2('Obaveštenje'),
            content:
                buildText2(text),
            actions: <Widget>[
              FlatButton(
                child: buildText2('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  
  Widget buildText2(String str) {
    return Text(
      str,
      style: gf.GoogleFonts.ubuntu(),
    );
  }

  pomocna_fun() async{
    SharedPreferences pref = await SharedPreferences.getInstance().then((value){
      print(value.getString('user'));
    });
  }

  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _token = preferences.getString('token');
    Map<String, dynamic> jsonObject =
        json.decode(preferences.getString('user'));
    Korisnik extractedUser = new Korisnik();
    extractedUser = Korisnik.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
    });
  }

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    api_services services = api_services();
    return Scaffold(
      body: Center(
    child: SingleChildScrollView(
        child:Column(
          
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5.0),
              child:Image.asset('images/logo_aplikacija.png',height: 200.0,width: 150.0),
            ),
            buildText("Moj Grad", 25.0),

            //buildText("Pixels", 25.0),
            SizedBox(height: 10.0,),
            buildmix( "Korisničko ime:", 20, _usernameController, 0),
            SizedBox(height: 10.0,),
            buildmix( "Unesi šifru:", 20, _passwordController, 1),
            SizedBox(height: 5.0,),
            buildButtonContainer("Prijava"),
            buildButtonContainerRegistration("Registruj se"),
            Container(
              alignment: Alignment.center,
              child: Column(children: <Widget>[
                Text('Zaboravili ste lozinku?', style: gf.GoogleFonts.ubuntu()),
                SizedBox(height:5),
                GestureDetector(
                  onTap:(){
                    _showZaboraviliSifruDialog();
                  },
                  child: Text('Pritisnite ovde.', style: gf.GoogleFonts.ubuntu(color:Colors.blue))
                )
              ],)
              
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child:Image.asset('images/logo_tima.png',height: 50.0,width: 50.0, ),
            ),
          ],
        ),
      ),
      ),
      
    );
  }

  Widget buildText(String str, double size)
  {
    return Container(
      child:Text(
        str,
        style:gf.GoogleFonts.ubuntu(
          fontSize:size,
        ),

    ),
    );
  }
  Widget buildmix(String text,double size,TextEditingController controller, int user_pass)
  {
    return Container(
      width:MediaQuery.of(context).size.width ,
      alignment: Alignment.center,

      child: Column(
        children: <Widget>[
          //buildText(text, size),
          SizedBox(height: 5.0,),
          buildTextField(text, controller, user_pass)
        ],
      ),
    );
  }
  Widget buildTextField(String hintText, TextEditingController controller, int user_pass){

    return
      Container(
        height: 40,
        width: 250.0,
        child :TextFormField(
          obscureText: user_pass == 0? false : true,
          controller: controller,
          style:gf.GoogleFonts.ubuntu(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 2.0),
			      hintText:hintText,
            hintStyle: TextStyle(
              
              color: Colors.grey,
              fontSize: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            suffixIcon: hintText == "Unesi sifru:" ? IconButton(
              onPressed: _toggleVisibility,
              icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
            ) : null,

          ),
          //obscureText: hintText == "Unesi sifru:"  ? true : false,
        ),
      );
  }
  Widget buildButtonContainer(String str){
    return Container(
      alignment: Alignment.center,
      child:RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        textColor: Colors.white,
        color: Colors.green,
        child:buildText(str,16),
        onPressed:(){

          var bytes = utf8.encode(_passwordController.text);
          var digest = sha1.convert(bytes);

          var body = jsonEncode({
            "username" : _usernameController.text,
            "password" : digest.toString()
          });

          api_services().login(context, body);
        } ,
      ),

      

      
    );

  }

   Widget buildButtonContainerRegistration(String str){
    return Container(
      alignment: Alignment.center,

      child:RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        textColor: Colors.white,
        color: Colors.green,
        child:buildText(str,16),
        onPressed:(){
         Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyRegistrationPage()));  
        } ,
      ),

      

      
    );

  }

}