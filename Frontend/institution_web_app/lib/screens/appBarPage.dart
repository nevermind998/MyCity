import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:webApp/screens/profilkorisnika.dart';
import '../models/Korisnik.dart';
import '../services/api_services.dart';
import 'ListOfComments.dart';
import 'loginPage.dart';
import 'profilePage.dart';
import 'searchPage.dart';
import 'homePage.dart';

import 'package:google_fonts/google_fonts.dart' as gf;
class AppBarPage extends StatefulWidget {
  @override
  AppBarPageState createState() => AppBarPageState();
}

class AppBarPageState extends State<AppBarPage> {
  static int trenIndex=0;
  double sirina;
  api_services servis = api_services();
  final key = GlobalKey<FormState>();
  Korisnik user;
  bool _isHidden = true;
  bool pass=false;
  String token='';

  getToken() async {

    String _token = html.window.sessionStorage['token'];
    Map<String, dynamic> jsonObject = json.decode(html.window.sessionStorage['userInfo']);
    Korisnik extractedUser = new Korisnik();
    extractedUser = Korisnik.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
    });
  }
double sirina1;
  initState() {
    if(html.window.sessionStorage.length<1)
    {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
    getToken();
    super.initState();
  }

   List<Widget> _pages=[
     new HomePage(),
     new SearchPage(),
     new ProfilePage(),
     new ListOfComments(),
     new ProfileUserPage()
  ];

  Widget build(BuildContext context) {
    sirina=MediaQuery.of(context).size.width*0.15;
    sirina1=MediaQuery.of(context).size.width;
    return Scaffold(
      body:Stack(
        children: <Widget>[
          Row(
            children: <Widget>[

              Container(
                color: Color.fromRGBO(49, 204, 149,1),
                width: sirina,
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: Column(

                  children: <Widget>[
                    SizedBox(height: 60,),

                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric( vertical: 10 ),
                      alignment: Alignment.topCenter,
                      child :_buildText("Moj Grad",18+(sirina1/250),1,1)),

                    Container(

                      child: GestureDetector(
                        child:  Container(

                          alignment: Alignment.center,

                          child: Column(

                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Container(

                                  child:   user.urlSlike!=null?Container(
                                      child:  ClipOval(
                                        child: Image.network(
                                          api_services.url_za_slike + user.urlSlike,
                                          width:20+(sirina1/20),
                                          height: 20+(sirina1/20),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                  ):Container(
                                      width:20+(sirina1/20),
                                      height: 20+(sirina1/20),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                        color: Colors.white,
                                      ),
                                      child: Icon(Icons.person,color: Color.fromRGBO(
                                          59, 227, 168,1),size: 18+(sirina1/40),)
                                  ),

                              ),
                          SizedBox(
                                  height: 10,
                                ),
                                sirina1>900?Container(
                                  width: sirina/1.2,
                                  alignment: Alignment.center,
                                  child:Text(user.ime,style:
                                  gf.GoogleFonts.ubuntu(color:Colors.white,fontSize: sirina1>1100?14+(sirina1/250):12+(sirina1/250)),),
                                ):Container(),
                                sirina1>900? SizedBox(
                                  height: 10,
                                ):Container(),
                              ]
                          ),
                        ),
                        onTap: (){
                          setState(() {
                            trenIndex=2;

                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      child:  Container(
                       width: sirina,
                        alignment: Alignment.center,
                        height: 50,
                        decoration: trenIndex==0? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(80))
                        ):BoxDecoration(),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Container(
                              padding:sirina<130 ? sirina>110?EdgeInsets.only(left: sirina/2.5):EdgeInsets.only(left: sirina/4):EdgeInsets.all(0),
                              child: Icon(Icons.home,size: 23+(sirina1/250),
                                  color:trenIndex==0? Color.fromRGBO(49, 204, 149,1):Colors.white),
                            ),
                           sirina>130 ?Container(
                              margin:EdgeInsets.only(left: 10),
                              child: Text("Početna",style:
                              gf.GoogleFonts.ubuntu(color:trenIndex==0? Color.fromRGBO(49, 204, 149,1):Colors.white,fontSize: 14+(sirina1/250)),),
                            ):Container(),
                            sirina>165 && trenIndex==0?SizedBox(width: 5,):SizedBox(width: 0,),
                            sirina>165 && trenIndex==0?Icon(Icons.arrow_forward_ios,size: 20+(sirina1/250),
                                color:trenIndex==0? Color.fromRGBO(49, 204, 149,1):Colors.white):SizedBox(width: 0,)
                          ],
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          trenIndex=0;
                         Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AppBarPage()));
                        });
                      },
                    ),

                    GestureDetector(
                      child:  Container(
                        height: 50,
                        alignment: Alignment.center,
                        width: sirina,
                        decoration: trenIndex==1? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(80))
                        ):BoxDecoration(),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Container(
                              padding:sirina<130 ? sirina>110?EdgeInsets.only(left: sirina/2.5):EdgeInsets.only(left: sirina/4):EdgeInsets.all(0),
                              child: Icon(Icons.search,size: 23+(sirina1/250),
                                  color:trenIndex==1? Color.fromRGBO(49, 204, 149,1):Colors.white),
                            ),

                            sirina>130 ? Container(
                              margin:EdgeInsets.only(left: 10),

                              child: Text("Pretraga",style:
                              gf.GoogleFonts.ubuntu(color:trenIndex==1? Color.fromRGBO(49, 204, 149,1):Colors.white,fontSize: 14+(sirina1/250))),
                            ):Container(),
                            sirina>165 &&trenIndex==1?SizedBox(width: 10,):SizedBox(width: 0,),
                            sirina>165 && trenIndex==1?Icon(Icons.arrow_forward_ios,size: 20+(sirina1/250),
                                color:trenIndex==1? Color.fromRGBO(49, 204, 149,1):Colors.white):SizedBox(width: 0,)
                          ],
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          trenIndex=1;
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AppBarPage()));
                        });
                      },
                    ),
                    GestureDetector(
                      child:  Container(
                        height: 50,
                        width: sirina,
                        alignment: Alignment.center,
                        decoration: trenIndex==2? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(80))
                        ):BoxDecoration(),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Container(
                              padding:sirina<130 ? sirina>110?EdgeInsets.only(left: sirina/2.5):EdgeInsets.only(left: sirina/4):EdgeInsets.all(0),
                              child: Icon(Icons.person,size: 23+(sirina1/250),
                                  color:trenIndex==2? Color.fromRGBO(49, 204, 149,1):Colors.white),
                            ),
                            sirina>130?   Container(
                              margin:EdgeInsets.only(left: 10),

                              child: Text("Profil",style:
                              gf.GoogleFonts.ubuntu(color:trenIndex==2? Color.fromRGBO(49, 204, 149,1):Colors.white,fontSize: 14+(sirina1/250))),
                            ):Container(),
                            SizedBox(width: 25,),
                            sirina>165&& trenIndex==2?SizedBox(width: 10,):SizedBox(width: 0,),
                            sirina>165 && trenIndex==2?Icon(Icons.arrow_forward_ios,size: 20+(sirina1/250),
                                color:trenIndex==2? Color.fromRGBO(49, 204, 149,1):Colors.white):SizedBox(width: 0,)
                          ],
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          trenIndex=2;

                        });
                      },
                    ),

                    Expanded(
                      child:Align(
                        alignment:  FractionalOffset.bottomCenter,
                        child: GestureDetector(
                          child:  Container(
                            width: sirina,
                            height: 50,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Wrap(

                              direction: Axis.horizontal,
                              children: <Widget>[
                                Container(
                                  padding:sirina<130 ? sirina>110?EdgeInsets.only(left: sirina/2.5):EdgeInsets.only(left: sirina/4):EdgeInsets.all(0),
                                  child: Icon(Icons.exit_to_app,size: 23+(sirina1/250),
                                      color: Color.fromRGBO(49, 204, 149,1)),
                                ),
                                sirina>130?Container(
                                  margin:EdgeInsets.only(left: 10),

                                  child: _buildText("Odjava",14+(sirina1/250),1,0),
                                ):Container(),

                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              servis.logOut(user.id, context);
                            });
                          },
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width-sirina,
                child: _pages[trenIndex],
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildText(String str,double size,int boja,int bold )
  {
    return Text(str,style:gf.GoogleFonts.ubuntu(color:boja==1?Color.fromRGBO(49, 204, 149, 1):boja==2?Colors.black:Colors.white,fontSize: size,fontWeight:bold==1?FontWeight.bold:FontWeight.normal),);

  }
}