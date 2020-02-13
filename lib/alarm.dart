import 'package:flutter/material.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              'ALARM',
              style: TextStyle(
                  color: Colors.white, letterSpacing: 3, fontSize: 20),
            ),
            Text(
              'Do you need help?',
              style: TextStyle(
                  color: Colors.white, fontSize: 11, letterSpacing: 2),
            ),
            SizedBox(
              height: 120,
            ),
            AlarmButon()
          ],
        ),
      ),
    );
  }
}

class AlarmButon extends StatefulWidget {
  @override
  _AlarmButonState createState() => _AlarmButonState();
}

class _AlarmButonState extends State<AlarmButon> {
  RadialGradient notClicked = RadialGradient(
      colors: [Colors.red[800], Colors.red[700], Colors.red[500]]);
  RadialGradient clicked = RadialGradient(
      colors: [Colors.red[900], Colors.red[800], Colors.red[600]]);
  RadialGradient gradient = RadialGradient(
      colors: [Colors.red[800], Colors.red[700], Colors.red[500]]);
 double size=80;
 double sizeClicked=78;
 double sizeNotClicked=80;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTapDown: (e) {
        setState(() {
          gradient = clicked;
          size=sizeClicked;
        });
      },

      onTapUp: (e) {
        setState(() {
          gradient = notClicked;
          size=sizeNotClicked;
        });
      },

      child: Container(
        padding: EdgeInsets.all(size),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient,
            boxShadow: [BoxShadow(color: Colors.black,blurRadius: 15, offset: Offset(0,3))],
        ),
        child: Icon(
          Icons.new_releases,
          size: 90,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
