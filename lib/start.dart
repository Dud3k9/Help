import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:help/Background/AnimatedBackground.dart';

import 'login.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {


  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1),(){//TODO set longer time
    startHome();
    });
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: Text('TODO ANIMATION',style: TextStyle(fontSize: 50),),),
      ),

    );
  }



  void startHome() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool('IsLogIn')!=null&&sharedPreferences.getBool('IsLogIn')) {
      Navigator.pushReplacementNamed(context, '/MainScrean');
    }else {
      sharedPreferences.setBool('IsLogIn', false);
      Navigator.pushReplacementNamed(context, '/LogIn');
    }
  }

}
