import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webApp/models/Objava.dart';
import 'dart:html' as html;
import '../models/Korisnik.dart';
import '../services/api_services.dart';
import 'appBarPage.dart';
import 'loginPage.dart';
import 'profilePage.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);
  @override
  SearchPageState createState() => new SearchPageState();
}
class SearchPageState extends State<SearchPage> {
  Korisnik korisnik_pretra=null;

  TextEditingController _searchTextController = new TextEditingController();
  List<Korisnik> korisnici = List<Korisnik>();
  api_services servis = new api_services();
  Korisnik user = Korisnik();
  List<Objava> objave;
  static double sirina ;
  static bool flag=true;
int i=0;
  @override
  void initState() {
    super.initState();

    if(html.window.sessionStorage.length<1)
    {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }

    servis.getUserSession().then((value) {
      setState(() {
        user = value;
        korisnik_pretra =null;
      });
    });
    getKorisnici();

  }

  void getKorisnici() {

    servis.fetchKorisnikePretraga(_searchTextController.text).then((response) {
      Iterable list = json.decode(response.body);
      List<Korisnik> _korisnici = List<Korisnik>();
      _korisnici = list.map((model) => Korisnik.fromObject(model)).toList();
      setState(() {
        korisnici = _korisnici;
      });
    });
  }
  Widget prikazKorisnika() {
    return korisnici.length==0?Container(
      width: sirina/2,
      alignment: Alignment.center,
      child:flag==true?CircularProgressIndicator(): _buildText("Ne postoji traženi korisnik.", 15+ (sirina/250), 2, 1),
    ):
    Container(
      width: sirina/1.5,

      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: korisnici.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                  child: Container(


                    margin:EdgeInsets.symmetric(vertical: 10,horizontal: 5) ,

                      decoration: BoxDecoration(
                        color: korisnici[index].uloga=="korisnik" ||
                            korisnici[index].uloga=="admin"
                            ?Color.fromRGBO(49, 204, 149,1):Color.fromRGBO(
                            59, 250, 168,1),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),

                        child: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[

                            Container(

                              padding: EdgeInsets.all(10),

                              //margin:EdgeInsets.symmetric(vertical: 15,horizontal: 15) ,
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                   korisnici[index].urlSlike==null?Container(
                                  width: 50+(sirina/500*7),
                                  height: 50+(sirina/500*7),
                                  margin: EdgeInsets.only(top: 5,right: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                    color: Colors.white
                                  ),
                                  child: Icon(Icons.person,color: Color.fromRGBO(42, 184, 115, 1),size: 30+(sirina/500*5),)
                              ):  ClipOval(
                                     child: Image.network(
                                       api_services.url_za_slike+korisnici[index].urlSlike,

                                       height: 50+(sirina/500*7),
                                       width: 50+(sirina/500*7),
                                       fit: BoxFit.cover,

                                     ),
                                   ),
                                  Container(
                                     width: sirina/3,
                                      child :Column(
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                            child:_buildText("@"+korisnici[index].username,16+(sirina/250),0,1)
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          new Container(
                                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                            child:korisnici[index].uloga!="institucija"?
                                            _buildText(korisnici[index].ime + ' '  + korisnici[index].prezime,
                                               15+ (sirina/250),0,1) :
                                            _buildText(korisnici[index].ime , 15+ (sirina/250),0,1 ),
                                          ),
                                        ],
                                      ),
                                    ),



                                ],
                              ),
                            ),
                          ],
                        ),
                  ),
                    onTap: () {
                      setState(() {
                        html.window.sessionStorage['Idkorisnika']=korisnici[index].id.toString();
                        AppBarPageState.trenIndex=4;
                      });
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              AppBarPage()
                      )
                      );
                    }

            );
          }),
    );
  }
  @override
  Widget build(BuildContext context) {
    sirina=MediaQuery.of(context).size.width;
   return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body:   Scrollbar(
          child: SingleChildScrollView(
              padding: EdgeInsets.only(top:10.0),
              child:buildsarch(),
          ),
        )
   );
  }

  Widget buildsarch()
  {
    return Container(
      width: sirina,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[

          Container(
            width: sirina/1.5,

            alignment: Alignment.center,

                  child: TextFormField(
                    controller: _searchTextController,
                    onChanged: (_searchTextController) {

                      getKorisnici();
                      setState(() {
                        flag=false;
                      });
                    },
                    validator: (String value){
                    },
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pretraga po imenu, prezimenu ili korisničkom imenu:',
                    ),
                  ),

          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: sirina/1.5,
              child: prikazKorisnika()
          ),
        ],
      ),
    );
  }



  Widget _buildText(String str,double size,int boja,int bold )
  {
    return Container(
        child:Text(str,style:gf.GoogleFonts.ubuntu(color:boja==1?Color.fromRGBO(42, 184, 115, 1):boja==2?Colors.black:Colors.white,fontSize: size,fontWeight:bold==1?FontWeight.bold:FontWeight.normal),)
    );

  }

}

