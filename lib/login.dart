import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
import 'package:help/Firebase/auth.dart';
import 'Background/AnimatedBackground.dart';
import 'package:help/Firebase/database.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (ctx) => Container(
          child: AnimatedBackground(
            child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Image(image: AssetImage('assets/logo.png'),
                    height: 150,),
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 35, color: Colors.white, letterSpacing: 2),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        auth = await Auth();
                        auth.googleHandleSignIn().then((a) async {
                          Scaffold.of(ctx).showSnackBar(SnackBar(
                            content: Text(
                              '                            Welcome ' +
                                  auth.fUser.displayName,
                            ),
                          ));
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.setBool('IsLogIn', true);
                          sharedPreferences.setString('uid', auth.fUser.uid);
                          Database.setUser(auth.fUser);

                          Location location=Location();


                          bool hasPermission=await location.hasPermission();
                          if(!hasPermission){
                            await location.requestPermission();
                          }

                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pushReplacementNamed(context, '/Start');
                          });
                        });
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    ),
                    SizedBox(
                      height: 10,
                    ),
//                    SignInButton(
//                      Buttons.Facebook,
//                      onPressed: () {},
//                      padding:
//                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
//                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

//  Future<FirebaseUser> googleHandleSignIn() async {
//
//    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
//    developer.log('msg',name: 'msg');
//    final GoogleSignInAuthentication googleAuth =
//    await googleUser.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//
//    final FirebaseUser user =
//        (await auth.signInWithCredential(credential)).user;
//    fUser =  user;
//  }

}
