import 'package:flutter/material.dart';
import 'package:mob_app/models/Korisnik.dart';
import 'package:mob_app/models/Objava.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:mob_app/screens/ListOfResenihComments.dart';
import 'package:mob_app/services/api_services.dart';

class PopupWidget{

  api_services servis = api_services();

  Widget buildText(String str){
    return Text(
      str,
      style:gf.GoogleFonts.ubuntu(),
    );
  }

  Widget buildWhiteText(String str){
    return Text(
      str,
      style:gf.GoogleFonts.ubuntu(color: Colors.white),
    );
  }

   Widget simplePopup(Objava objava, BuildContext context, Korisnik user){
     return PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: buildText("Obrisi objavu"),
          ),
          PopupMenuItem(
            value: 2,
            child: buildText("Oznaci kao resen problem"),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            _showDialog(objava.id, context);
          } else if (value == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ListOfResenihComments(objava.id, user.id)
                    /*prikazMape(latitude, longitude)*/));
          }
        },
      );
    }

  Widget simplePopup2(Objava objava, BuildContext context) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: buildText("Obrisi objavu"),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            _showDialog(objava.id, context);
          }
        },
      );

    void _showDialog(int idObjave, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: buildText('Obrisi objavu'),
            content: buildText('Da li ste sigurni da zelite da obrisete ovu objavu'),
            actions: <Widget>[
              FlatButton(
                child: buildText('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: buildText('Delete'),
                onPressed: () {
                  servis.deletePost(idObjave);
                  print(idObjave);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

}