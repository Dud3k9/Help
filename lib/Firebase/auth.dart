import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;

class Auth {

    FirebaseUser fUser;
    GoogleSignIn googleSignIn;
    FirebaseAuth auth;

    Auth(){
      googleSignIn=GoogleSignIn();
      auth=FirebaseAuth.instance;
    }

  //google
   Future<FirebaseUser> googleHandleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await auth.signInWithCredential(credential)).user;
    fUser =  user;
  }


  //facebook

}