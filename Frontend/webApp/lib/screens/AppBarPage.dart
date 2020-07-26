import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webApp/models/Korisnik.dart';
import 'package:webApp/services/api_services.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'PostPage.dart';
import 'UserProfilePage.dart';
import 'homePage.dart';
import 'UserPage.dart';
import 'loginPage.dart';
import 'dart:ui';

import 'pregledKomentari.dart';
class AppBarPage extends StatefulWidget {

  @override
  AppBarPageState createState() => AppBarPageState();
}

class AppBarPageState extends State<AppBarPage> {
  static int trenIndex=0;
  static double sirina=180;
  double visina;

  String token = '';
  Korisnik user;
  api_services servis = api_services();

  getToken() async {
    String _token = html.window.sessionStorage['adminToken'];
    Map<String, dynamic> jsonObject = json.decode(html.window.sessionStorage['adminInfo']);
    Korisnik extractedUser = new Korisnik();
    extractedUser = Korisnik.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
    });
  }

  initState() {
    if(html.window.sessionStorage.length==0)
    {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
    getToken();
    super.initState();


  }

  final List<Widget> _pages=[
    HomePage(),
    UserPage(),
    PostPage(),
    PregledKomentara(),
    ProfileUserPage()
    //CommentPage(),

  ];

  Widget build(BuildContext context) {
    visina=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                color: Colors.lightBlue,
                width: sirina,
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: Column(

                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      //width: 110,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white,width: 5),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      height: 50,
                      alignment: Alignment.center,
                      child:GestureDetector(
                        child: Row(
                          children: <Widget>[
                            user.urlSlike!=null?new Container(
                                width:40,
                                height: 40,
                                child:Image.network(
                                    api_services.url_za_slike+user.urlSlike
                                )
                            ):Icon(Icons.person,size: 30,),
                            Container(
                              margin:EdgeInsets.only(left: 10),
                              child: Text("@"+user.username,style:
                              TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                            ),
                          ],
                        ),
                        onTap: (){
                          setState(() {
                            AppBarPageState.trenIndex=4;
                            html.window.sessionStorage['Idkorisnika']=user.id.toString();
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => AppBarPage()));
                          });
                        },
                      ),

                    ),
                    SizedBox(height: 20,),
                   Container(
                      height: 50,
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.topCenter,
                         child :Text("Moj Grad",
                            style: TextStyle(color: Colors.lightBlue,fontSize: 24),),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                  GestureDetector(
                    child:  Container(
                    height: 50,
                    alignment: Alignment.center,
                       decoration: trenIndex==0? BoxDecoration(
                         color: Colors.white,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(80))
                      ):BoxDecoration(),
                      child: Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Icon(Icons.home,size: 30,
                        color:trenIndex==0?Colors.lightBlue:Colors.white),
                        Container(
                          margin:EdgeInsets.only(left: 10),
                        padding: EdgeInsets.all( 7),
                          child: Text("Početna",style:
                            TextStyle(color:trenIndex==0?Colors.lightBlue:Colors.white),),
                        ),
                        trenIndex==0?SizedBox(width: 10,):SizedBox(width: 0,),
                        trenIndex==0?Icon(Icons.arrow_forward_ios,size: 25,
                            color:trenIndex==0?Colors.lightBlue:Colors.white):SizedBox(width: 0,)
                      ],
                      ),
                      ),
                      onTap: (){
                        setState(() {
                        trenIndex=0;
                        //Navigator.pushNamed(context,"/appbarWeb");
                        });
                      },
                  ),

                    GestureDetector(
                            child:  Container(
                              height: 50,
                              alignment: Alignment.center,

                              decoration: trenIndex==1? BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.horizontal(left: Radius.circular(80))
                              ):BoxDecoration(),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Icon(Icons.supervised_user_circle,size: 30,
                                      color:trenIndex==1?Colors.lightBlue:Colors.white),

                                  Container(
                                    margin:EdgeInsets.only(left: 10),
                                    padding: EdgeInsets.all( 7),
                                    child: Text("Korisnici",style:
                                    TextStyle(color:trenIndex==1?Colors.lightBlue:Colors.white),),
                                  ),
                                  trenIndex==1?SizedBox(width: 10,):SizedBox(width: 0,),
                                  trenIndex==1?Icon(Icons.arrow_forward_ios,size: 25,
                                      color:trenIndex==1?Colors.lightBlue:Colors.white):SizedBox(width: 0,)
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
                        alignment: Alignment.center,
                        decoration: trenIndex==2? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(80))
                        ):BoxDecoration(),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Icon(Icons.art_track,size: 30,
                                color:trenIndex==2?Colors.lightBlue:Colors.white),
                            Container(
                              margin:EdgeInsets.only(left: 10),
                              padding: EdgeInsets.all( 7),
                              child: Text("Objave",style:
                              TextStyle(color:trenIndex==2?Colors.lightBlue:Colors.white),),
                            ),
                            trenIndex==2?SizedBox(width: 10,):SizedBox(width: 0,),
                            trenIndex==2?Icon(Icons.arrow_forward_ios,size: 25,
                                color:trenIndex==2?Colors.lightBlue:Colors.white):SizedBox(width: 0,)
                          ],
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          trenIndex=2;
                          //Navigator.pushNamed(context,"/appbarWeb/postWeb");
                        });
                      },
                    ),


                    Expanded(
                      child:Align(
                        alignment:  FractionalOffset.bottomCenter,
                        child: GestureDetector(
                          child:  Container(
                            height: 50,
                            //width: sirina,

                            alignment: Alignment.center,
                                color: Colors.white,
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Icon(Icons.exit_to_app,size: 30,
                                    color:Colors.lightBlue),
                                Container(
                                  margin:EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.all( 7),
                                  child: Text("Odjava",style:
                                  TextStyle(color:Colors.lightBlue),),
                                ),

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
}