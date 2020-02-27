
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:help/NavigationBar.dart';
import 'package:help/login.dart';
import 'package:help/settings.dart';
import 'package:help/alarm.dart';
import 'package:help/friends.dart';
import 'package:help/Background/AnimatedBackground.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addFriends.dart';

class MainScrean extends StatefulWidget {
  @override
  _MainScreanState createState() => _MainScreanState();
}

class _MainScreanState extends State<MainScrean>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> animationLeft;
  Animation<Offset> animationRight;
  MyBottomNavigationBar myBottomNavigationBar=MyBottomNavigationBar();
  FirebaseMessaging firebaseMessaging;

  @override
  void initState() {
    super.initState();
    firebaseMesagingConfig();
    HomeState.state = this;

    //Aniamtion
    controller = AnimationController(
      duration: Duration(milliseconds: 0),
      vsync: this,
    );
    animationLeft = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset.zero,
    ).animate(controller);
    animationRight = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(controller);

  }

  @override
  Widget build(BuildContext context) {
    controller.duration = Duration(milliseconds: 300);
    controller.forward(from: 0);
    return Scaffold(
      bottomNavigationBar: myBottomNavigationBar,
      body: AnimatedBackground(
        child: SlideTransition(
            position: HomeState.previous>HomeState.selected?animationLeft:animationRight,
            child: HomeState.children[HomeState.selected]),
      ),
    );
  }

  void firebaseMesagingConfig() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String uid=sharedPreferences.get('uid');

    firebaseMessaging=FirebaseMessaging();
    firebaseMessaging.subscribeToTopic(uid);
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
       dynamic notification =message['notification'];
       print(notification);

        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text(notification['title'].toString(),style: TextStyle(color: Colors.red),),
              content: Text(notification['body'].toString()),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        setState(() {
          myBottomNavigationBar.myBottomNavigationBarState.onItemTaped(1);
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        setState(() {
          myBottomNavigationBar.myBottomNavigationBarState.onItemTaped(1);
        });
      },
    );
  }



}

class HomeState {
  static final List<Widget> children = [
    Alarm(),
    Friends(),
    AddFriends(),
    Settings(),
  ];

  static State state;
  static int previous = 1;
  static int selected = 0;
}
