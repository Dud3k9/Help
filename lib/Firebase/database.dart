import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

class Database{


  static setUser(FirebaseUser user){
    Firestore.instance.collection('users').document(user.uid)
        .setData({ 'name': user.displayName,'photo': user.photoUrl });
  }


}