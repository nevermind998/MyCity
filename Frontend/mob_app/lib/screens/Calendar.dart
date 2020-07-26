import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart' as gf;

class Calendar extends StatefulWidget{
  @override
    _CalendarState createState() => _CalendarState();

}

class _CalendarState extends State<Calendar>{
  CalendarController _calendarController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalendar', style:gf.GoogleFonts.ubuntu(
          color: Colors.white,
          fontSize: 25
        ))
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              calendarController: _calendarController,
            )
          ],
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context, _calendarController.selectedDay.toString());
                        },
                        child: Icon(Icons.check, size: 30),
                        backgroundColor: Colors.greenAccent[700],
                      ),
    );
  }
  
}