import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:help/start.dart';
import 'package:help/mainScrean.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'login.dart';



void main() {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      home: Start(),
      routes: {
        '/Start':(context)=> Start(),
        '/MainScrean': (context) => MainScrean(),
        '/LogIn': (context)=> Login(),
      }
  )
  );
}
