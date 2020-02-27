import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:help/Background/AnimatedBackground.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:help/Firebase/database.dart';
import 'package:location/location.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  static List<Widget> addWidget = List();
  double height;

  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    return Container(
      child: Padding(
        padding: EdgeInsets.all(height*0.03),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: height*0.07,
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
              height: height*0.13,
            ),
            AlarmButon(this),
            SizedBox(
              height: height*0.05,
            ),
            Column(
              children: addWidget,
            )
          ],
        ),
      ),
    );
  }
}

class AlarmButon extends StatefulWidget {
  State alarmState;

  AlarmButon(State alarmState) {
    this.alarmState = alarmState;
  }

  @override
  _AlarmButonState createState() => _AlarmButonState(alarmState);
}

class _AlarmButonState extends State<AlarmButon> {
  State alarmState;

  _AlarmButonState(State alarmState) {
    this.alarmState = alarmState;
  }

  RadialGradient notClicked = RadialGradient(
      colors: [Colors.red[800], Colors.red[700], Colors.red[500]]);
  RadialGradient clicked = RadialGradient(
      colors: [Colors.red[900], Colors.red[800], Colors.red[600]]);
  RadialGradient gradient = RadialGradient(
      colors: [Colors.red[800], Colors.red[700], Colors.red[500]]);
  double size = 80;
  double sizeClicked = 78;
  double sizeNotClicked = 80;
  Widget button, button1, button2;

  @override
  void initState() {
    button1 = Container(
      padding: EdgeInsets.all(size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 15, offset: Offset(0, 3))
        ],
      ),
      child: Icon(
        Icons.new_releases,
        size: 90,
        color: Colors.grey[400],
      ),
    );

    Tween tween = ColorTween(begin: Colors.red, end: Colors.blue);

    button2 = ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: Duration(seconds: 1),
      builder: (context, animation) {
        return Container(
          padding: EdgeInsets.all(size),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: animation,
            boxShadow: [
              BoxShadow(
                  color: Colors.black, blurRadius: 15, offset: Offset(0, 3))
            ],
          ),
          child: Icon(
            Icons.new_releases,
            size: 90,
            color: Colors.grey[400],
          ),
        );
      },
    );

    button = button1;
    super.initState();
    checkAlarm();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (e) {
          setState(() {
            gradient = clicked;
            size = sizeClicked;
          });
        },
        onTapUp: (e) {
          alarmState.setState(() {
            onClickAlarmButton();
            gradient = notClicked;
            size = sizeNotClicked;
          });
        },
        child: button);
  }

  void onClickAlarmButton() {
    if (_AlarmState.addWidget.isEmpty) {
      _AlarmState.addWidget.add(Text(
        'To turn off the alarm click again',
        style: TextStyle(color: Colors.white60, fontSize: 16),
      ));
      button = button2;

      Database.setAlarm(true);
      sendAlarmMessages();
    } else {
      _AlarmState.addWidget.removeLast();
      button = button1;

      Database.setAlarm(false);
    }
  }

  void checkAlarm() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uid = sharedPreferences.getString('uid');
    Firestore.instance.collection('users').document(uid).get().then((data) {
      if (data['alarm'])
        alarmState.setState(() {
          button = button2;
          if (_AlarmState.addWidget.isEmpty) {
            _AlarmState.addWidget.add(Text(
              'To turn off the alarm click again',
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ));
          }
        });
    });
  }

  void sendMessageTo(String uid,String name) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String serverToken =
        'AAAAZ4FbnAc:APA91bHFFHhNTFj_goxBuK64D67lyawKfKnuhR_wdyhggybowyUXugTkBVpxJmrlxrfID_TsYy424YhQzBaUiqL9t49sZEMHr8NjnMUE2rCVUXikGTTon5jkHpck2AV_npQPK8mZE-1I';

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '$name need your help!',
            'title': 'Help!',
            'sound': 'default',
            'icon': 'myicon'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': '/topics/'+uid,
        },
      ),
    );
  }

  void sendAlarmMessages() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> uids = await sharedPreferences.getStringList('UID');
    String uid =await sharedPreferences.getString('uid');
    Firestore.instance.collection('users').document(uid).get().then((data){
      for (int i = 0; i < uids.length; i++) {
        sendMessageTo(uids[i],data['name']);
      }
    });

  }
}
