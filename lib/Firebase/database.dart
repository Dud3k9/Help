import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

class Database{


  static setUser(FirebaseUser user){
    Firestore.instance.collection('users').document(user.uid)
        .setData({ 'name': user.displayName,'photo': user.photoUrl,'alarm' : false});
  }

  static void setAlarm(bool alarm) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String uid=sharedPreferences.getString('uid');
    Firestore.instance.collection('users').document(uid)
      .updateData({'alarm' : alarm});

    Firestore.instance.collection('users').document(uid)
        .collection('alarmsInfo').getDocuments().then((val){
       Firestore.instance.collection('users').document(uid)
          .collection('alarmsInfo').document(val.documents.length.toString())
          .setData({'date': DateTime.now().toString()});
    });

    Location location=Location();
    LocationData currentLocation;
    bool hasPermission=await location.hasPermission();
     await location.requestService();
    if(!hasPermission){
     await location.requestPermission();
    }
    hasPermission=await location.hasPermission();
    if(hasPermission)
      currentLocation= await location.getLocation();
    else
      currentLocation= null;


    Firestore.instance.collection('users').document(uid)
        .collection('alarmsInfo').getDocuments().then((val){
      Firestore.instance.collection('users').document(uid)
          .collection('alarmsInfo').document((val.documents.length).toString())
          .setData({'date': DateTime.now().toString(),
        'localization' : currentLocation.latitude.toString()+' '+currentLocation.longitude.toString()});
    });
  }


}