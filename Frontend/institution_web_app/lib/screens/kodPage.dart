
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import '../services/api_services.dart';
import 'loginPage.dart';
import 'registracijaPage.dart';
import 'registracijaPage.dart';
import 'registracijaPage.dart';
class kodPage extends StatefulWidget {
  int kod;
  String body;
  kodPage(int kod,String body)
  {
    this.kod=kod;
    this.body=body;
  }
  _kodPageState createState() => _kodPageState(kod,body);
}

class _kodPageState extends State<kodPage> {
  @override


  final GlobalKey <FormState> _formKey1 = GlobalKey<FormState>();

  int kod;
  int pomk;
  String body;
  _kodPageState(int kod,String body)
  {
    this.kod=kod;
    this.body=body;
 
  }


  api_services servis = new api_services();
  TextEditingController _kodController = TextEditingController();
  double sirina;
  Widget build(BuildContext context) {
    sirina=MediaQuery.of(context).size.width;
    return Scaffold(

      body:  Container(
        alignment:Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            _buildSlika('images/logo_aplikacija.jpg'),
            SizedBox(
              height: 15,
            ),
            _buildText("Moj Grad", 20+sirina/250,1),
            SizedBox(
              height: 15,
            ),
            Container(
              padding:EdgeInsets.all(10),
              child: _buildText("Unesite kod koji vam je poslat na email:", 18+sirina/250,1,),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: sirina/(sirina/400),
              alignment: Alignment.center,
              child: Form(
                key: _formKey1,
                child: TextFormField(
                  controller: _kodController,
                  style: gf.GoogleFonts.ubuntu(),
                  decoration: InputDecoration(
                    hintText: "Unesite kod:",
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

                    if(!RegExp("^[0-9]{1,}").hasMatch(value))
                    {
                      return "Niste lepo uneli kod!";
                    }
                    return null;
                  },
                  onSaved: (String value){
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      textColor: Colors.white,
                      color: Color.fromRGBO(42, 184, 115, 1),
                      child: _buildText("Potvrdi",16+sirina/250,0),
                      onPressed: (){
                        setState(() {
                          pomk=int.parse(_kodController.text);
                        });

                        if(kod==pomk)
                        {
                          servis.fetchlogujesedalje(body);
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                        }else
                        {
                          _showDialogAdmin("Niste lepo uneli kod."," Pokusajte ponovo.");
                        }
                      }
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    textColor: Colors.white,
                    color: Color.fromRGBO(42, 184, 115, 1),
                    child:_buildText("Odustani",16+sirina/250,0),
                    onPressed: (){
                      RegistrationPageState.registracija=false;
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RegistrationPage()));
                    },
                  )
                ],
              ),
            ),

          ],

        ),

      )

    );



  }
  Widget _buildText(String str,double size,int broj )
  {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child:Text(str,style:gf.GoogleFonts.ubuntu(color:broj==1?Color.fromRGBO(42, 184, 115, 1):Colors.white,fontSize: size,fontWeight: FontWeight.bold),)
    );

  }
  Widget _buildSlika(String str)
  {
    return Container(

      child: Image.asset(
          str, height: 250.0,
          width: 200.0),
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

}
