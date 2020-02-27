import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:help/Background/AnimatedBackground.dart';

import 'login.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> with SingleTickerProviderStateMixin {
  double width, height;
  bool animateStart = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.width;
    Future.delayed(Duration(microseconds: 1), () {
      setState(() {animateStart = true;});
    });
    Future.delayed(Duration(seconds: 4), () {
      startHome();
    });
    return Scaffold(
      body: AnimatedBackground(
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: Duration(seconds: 3),
              left: width * 0.5,
              top: animateStart ? height * 0.5 : -100,
              curve: Curves.elasticOut,
              child: Image(
                image: AssetImage('assets/lHand.png'),
                height: height * 0.25,
              ),
            ),
            AnimatedPositioned(
              duration: Duration(seconds: 3),
              right: width * 0.5,
              top: animateStart ? height * 0.5 : height * 1.3,
              curve: Curves.elasticOut,
              child: Image(
                image: AssetImage('assets/rHand.png'),
                height: height * 0.25,
              ),
            ),
            AnimatedPositioned(
              duration: Duration(seconds: 3),
              right: animateStart ? width * 0.16 : width*-0.4,
              top: height * 0.8,
              curve: Curves.elasticOut,
              child: Image(
                image: AssetImage('assets/help!.png'),
                height: height * 0.25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startHome() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool('IsLogIn') != null &&
        sharedPreferences.getBool('IsLogIn')) {
      Navigator.pushReplacementNamed(context, '/MainScrean');
    } else {
      sharedPreferences.setBool('IsLogIn', false);
      Navigator.pushReplacementNamed(context, '/LogIn');
    }
  }


}





