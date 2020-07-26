import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:webApp/models/Korisnik.dart';
import 'package:webApp/models/Objava.dart';
import 'package:webApp/models/Pretraga.dart';
import 'package:webApp/models/Report.dart';
import 'package:webApp/screens/UserProfilePage.dart';
import 'package:webApp/services/api_services.dart';
import 'package:webApp/models/Grad.dart';

import 'AppBarPage.dart';
import 'loginPage.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  UserPageState createState() => UserPageState();
}
class UserPageState extends State<UserPage> {

  bool opadajuci=false;
  bool rastuci=false;

  TextEditingController _searchTextController = new TextEditingController();

  List<Korisnik> korisnici = List<Korisnik>();
  api_services servis = new api_services();

  static Korisnik user = Korisnik();
  static double sirina ;

  Grad selected=Grad();
  List<Grad> gradovi=List<Grad>();

  @override
  List<Pretrazivanje> pretrazi=List<Pretrazivanje>();
  Pretrazivanje selectedp;

  List<Pretrazivanje> pretraziop=List<Pretrazivanje>();
  Pretrazivanje selectedp2;

  List<Pretrazivanje> pretraziTip=List<Pretrazivanje>();
  Pretrazivanje pretraziTipSelected;

  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey <FormState> _formKey1 = GlobalKey<FormState>();


  void initState() {

    if(html.window.sessionStorage.length==0)
    {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }

    getKorisnici();
    servis.getUserSession().then((value) {
      setState(() {
        user = value;
        selected.id=0;
        selected.naziv_grada_lat="Svi gradovi";
        selected.naziv_grada_cir=" ";
        pretrazi.add(new Pretrazivanje(0, "Poena"));
        pretrazi.add(new Pretrazivanje(1, "Prijavljenih objava"));
        pretrazi.add(new Pretrazivanje(2, "Prijavljenih komentara"));
        selectedp=pretrazi[0];
        pretraziop.add(new Pretrazivanje(0, "Rastuće"));
        pretraziop.add(new Pretrazivanje(1, "Opadajuće"));

        pretraziTip.add(new Pretrazivanje(0, "Svi korisnici"));
        pretraziTip.add(new Pretrazivanje(1, "Korisnik"));
        pretraziTip.add(new Pretrazivanje(2, "Institucija"));
        pretraziTip.add(new Pretrazivanje(3, "Administrator"));
        pretraziTipSelected=pretraziTip[0];

        selectedp2=pretraziop[0];
      });
    });
    super.initState();

  }

  void getKorisnici() {
    var body= jsonEncode({
      "filter":""
    });
    servis.getKorisniciZaPrijave(body).then((response) {
      Iterable list = json.decode(response.body);
      List<Korisnik> _korisnici = List<Korisnik>();
      _korisnici = list.map((model) => Korisnik.fromObject(model)).toList();
      setState(() {
        korisnici = _korisnici;
        korisnici.sort((a,b) => a.poeni.compareTo(b.poeni));
      });
    });
  }

  void getKorisniciPrijave() {

    var body= jsonEncode({
      "idGrada":selected.id,
      "filter":_searchTextController.text
    });
    servis.getKorisniciZaPrijave(body).then((response) {
      Iterable list = json.decode(response.body);
      List<Korisnik> _korisnici = List<Korisnik>();
      _korisnici = list.map((model) => Korisnik.fromObject(model)).toList();
      setState(() {

        korisnici = _korisnici;

        if(pretraziTipSelected.id==1)
        {
          korisnici.removeWhere((element) => element.uloga!="korisnik");
        }
        if(pretraziTipSelected.id==2)
        {
          korisnici.removeWhere((element) => element.uloga!="institucija");
        }
        if(pretraziTipSelected.id==3)
        {
          korisnici.removeWhere((element) => element.uloga!="admin");
        }

        korisnici.sort((a,b) => a.poeni.compareTo(b.poeni));

        if(selectedp.id==0)
          {
            if(selectedp2.id==1)
            {
              korisnici.sort((a,b) => b.poeni.compareTo(a.poeni));
            }
            else
            {
              korisnici.sort((a,b) => a.poeni.compareTo(b.poeni));

            }
          }
        if(selectedp.id==1)
        {
          if(selectedp2.id==1)
          {
            korisnici.sort((a,b) => b.brojPrijavljenihObjava.compareTo(a.brojPrijavljenihObjava));
          }
          else
          {
            korisnici.sort((a,b) => a.brojPrijavljenihObjava.compareTo(b.brojPrijavljenihObjava));

          }
        }
        if(selectedp.id==2)
        {
          if(selectedp2.id==1)
          {
            korisnici.sort((a,b) => b.brojPrijavljenihKomentara.compareTo(a.brojPrijavljenihKomentara));
          }
          else
          {
            korisnici.sort((a,b) => a.brojPrijavljenihKomentara.compareTo(b.brojPrijavljenihKomentara));

          }
        }


      });
    });
  }


  Widget prikazKorisnika() {

    return Container(
      //width: 1120.0,
      constraints: BoxConstraints(
        minHeight: 200.0,minWidth: 220.0,
      ),
      margin: EdgeInsets.only(top:20,left: 10,right: 10) ,
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (sirina > 1500) ? 5  : (sirina - 200> 1100? 4 :  (sirina-100>800? 3 : (sirina-100>600?2:1) )  ),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: (sirina > 1500) ? 1.7  : (sirina - 200> 1100? 1.7 :  (sirina-100>800? 1.7 : (sirina-100>600?1.7:2.0) )  ),
          ),
          //physics: NeverScrollableScrollPhysics(),
          itemCount: korisnici.length,
          itemBuilder: (context, index) {
            return Container(
              width: 950,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
              ),
              child:Container(
                width: 250,
                child: new Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[

                      new Container(
                          margin: EdgeInsets.only(top:10.0,left: 10,bottom: 10),
                          child:new Wrap(
                            children: <Widget>[
                             korisnici[index].uloga=="institucija"?
                             Text(korisnici[index].ime )
                                 :Text(korisnici[index].ime + ' '  + korisnici[index].prezime),
                               Text("(@"+korisnici[index].username+")"),
                              korisnici[index].id==user.id?
                                  new Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child:Tooltip(
                                      child: Icon(Icons.verified_user,size: 20,),
                                      message: "Trenutno ulogovan",
                                    )
                                  )
                                  :new Text("")
                            ],
                          )
                        ),

                     new Container(
                          margin: EdgeInsets.only(left: 10),
                          child:new Column(
                            //direction: Axis.horizontal,
                            children: <Widget>[
                              Container(alignment: Alignment.centerLeft,child: new Text("Osvojeni poeni: "+korisnici[index].poeni.toString())),
                              Container(alignment: Alignment.centerLeft,child: new Text("Broj prijavljenih objava: "+korisnici[index].brojPrijavljenihObjava.toString())),
                              Container(alignment: Alignment.centerLeft,child: new Text("Broj prijavljenih komentara: "+korisnici[index].brojPrijavljenihKomentara.toString())),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0,),

                   new Wrap(
                     direction: Axis.horizontal,
                     children: <Widget>[
                       new Container(
                         margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                         child:new RaisedButton(
                             onPressed: (){
                               setState(() {
                                 AppBarPageState.trenIndex=4;
                                 html.window.sessionStorage['Idkorisnika']=korisnici[index].id.toString();
                                 Navigator.push(
                                     context, MaterialPageRoute(builder: (context) => AppBarPage()));
                               });
                             },
                             child:Text("Prikaži profil")
                         ),
                       ),
                       //!superuser?(admin=prikazani?Text:Brisalica):jeste
                       new Container(
                         margin: EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 0.0),
                         child:html.window.sessionStorage["adminUloga"]!="superuser"
                             ? (korisnici[index].uloga=="admin"?Text(""):new RaisedButton(
                             onPressed: (){
                               _showDialogBrisanjeKorisnika(korisnici[index]);
                             },
                             child:Text("Obriši")
                         )
                         )
                             : new RaisedButton(
                             onPressed: (){
                                _showDialogBrisanjeKorisnika(korisnici[index]);

                             },
                             child:Text("Obriši")
                         ),

                       ),
                     ],
                   )
                  ],
                ),
              )
            );
          }
        ),
      );
  }

  @override
  void dajGradove() {
    servis.dajGradove().then((response) {
      Iterable list = json.decode(response.body);
      setState(() {

        gradovi=list.map((model) => Grad.fromObject(model)).toList();
        gradovi.insert(0,selected);

      });
    });
  }
  List<DropdownMenuItem<Grad>> buildDropdownMenuItems(List <Grad> _gradovi) {
    List<DropdownMenuItem<Grad>> items = List();

    for (Grad grad in _gradovi) {
      items.add(
        DropdownMenuItem(
          value: grad,
          child: Text(grad.naziv_grada_lat,style: TextStyle(color: Colors.white,fontSize: 15),)
        ),
      );
    }
    return items;
  }


  List<DropdownMenuItem<Pretrazivanje>> buildDropdownMenuItemsPretrazivanje(List<Pretrazivanje> _pretrazi) {
    List<DropdownMenuItem<Pretrazivanje>> items1 = List();

    for (Pretrazivanje pret in _pretrazi) {
      items1.add(
        DropdownMenuItem(
          value: pret,
          child:Text(pret.ime,style: TextStyle(color: Colors.white,fontSize: 15),),
        ),
      );
    }
    return items1;
  }


  final ScrollController myScrollController=ScrollController();
  @override
  Widget build(BuildContext context) {
    sirina=MediaQuery.of(context).size.width;
    if(gradovi.length==0)
      dajGradove();

    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(

          padding: EdgeInsets.all(10),
          child:Container(
            width: sirina,
            child: Column(
              children: <Widget>[
                Container(
                //  color:Colors.red,
                  width: sirina,
                  child: Wrap(
                    children: <Widget>[
                      Container(
                  //      color:Colors.yellow,
                        width:400,
                        height: 50,
                        padding: EdgeInsets.only(right: 10,left:10),
                        child: TextFormField(
                          controller: _searchTextController,
                          onChanged: (_searchTextController) {
                            getKorisniciPrijave();
                            prikazKorisnika();
                          },
                          validator: (String value){

                          },
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Pretrazi...',
                          ),
                        ),
                      ),
                      Container(

                        child: Container(
                          alignment: Alignment.center,
                          width: 190,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue.shade400,
                              borderRadius:BorderRadius.all(Radius.circular(50))
                          ),
                          child: DropdownButtonHideUnderline(
                            child: new Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Colors.lightBlue.shade400,
                              ),
                              child: new DropdownButton(

                                  items: buildDropdownMenuItems(gradovi),
                                  value: selected,
                                  onChanged: (value) {
                                    setState(() {
                                      selected = value;
                                      getKorisniciPrijave();
                                      prikazKorisnika();
                                    });
                                  }),),
                          ),
                        ),
                      ),

                      Container(
                   //     color:Colors.pink,
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Container(
                                padding:EdgeInsets.only(top: 10,right: 10,left:10),
                                child:_buildText("Sortiraj:",15)
                            ),
                            Container(
                              padding:EdgeInsets.only(right: 10,left:10),
                              width:150,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue.shade400,
                                    borderRadius:BorderRadius.all(Radius.circular(50))
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: new Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: Colors.lightBlue.shade400,
                                    ),
                                    child: new DropdownButton(
                                        items: buildDropdownMenuItemsPretrazivanje(pretraziop),
                                        value: selectedp2,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedp2 = value;
                                            getKorisniciPrijave();
                                            prikazKorisnika();
                                          });

                                        }),),
                                ),
                              ),
                            ),
                            Container(
                                padding:EdgeInsets.only(top: 10,right: 10),
                                child:_buildText("Po broju:",15)
                            ),
                            Container(
                              width:220,
                              padding:EdgeInsets.only(right: 10),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue.shade400,
                                    borderRadius:BorderRadius.all(Radius.circular(50))
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: new Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: Colors.lightBlue.shade400,
                                    ),
                                    child: new DropdownButton(
                                        items: buildDropdownMenuItemsPretrazivanje(pretrazi),
                                        value: selectedp,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedp = value;
                                            getKorisniciPrijave();
                                            prikazKorisnika();
                                          });
                                        }),),
                                ),
                              ),
                            ),
                            Container(
                                padding:EdgeInsets.only(top: 10,right: 10),
                                child:_buildText("Tip :",15)
                            ),
                            Container(
                              padding:EdgeInsets.only(right: 10),
                              width:150,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue.shade400,
                                    borderRadius:BorderRadius.all(Radius.circular(50))
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: new Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: Colors.lightBlue.shade400,
                                    ),
                                    child: new DropdownButton(
                                        items: buildDropdownMenuItemsPretrazivanje(pretraziTip),
                                        value: pretraziTipSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            pretraziTipSelected = value;



                                            getKorisniciPrijave();
                                            prikazKorisnika();
                                          });

                                        }),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                prikazKorisnika(),
              ],
            ),
          )
        )
    );
  }
  Widget _buildText(String str,double size )
  {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child:Text(str,style: TextStyle(fontSize:size),)
    );

  }

  void _showDialogBrisanjeKorisnika(Korisnik a) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Brisanje profila korisnika"),
          content: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Text('Da li ste sigurni da želite da obrišete profil korisnika '),
                Text("@"+a.username,style: TextStyle(fontStyle: FontStyle.italic),),
                Text("?")
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Odustani'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('Potvrdi'),
              onPressed: () {
                if(a.uloga=="admin")
                  {
                    servis.obrisiAdmina(a.id);
                  }
                else
                  {
                    servis.obrisiKorisnika(a.id);
                  }


                setState(() {
                  korisnici.removeWhere((element) => element.id==a.id);
                  prikazKorisnika();
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}
