import 'package:flutter/material.dart';
import 'package:help/NavigationBar.dart';
import 'package:help/login.dart';
import 'package:help/settings.dart';
import 'package:help/alarm.dart';
import 'package:help/friends.dart';
import 'package:help/Background/AnimatedBackground.dart';

import 'addFriends.dart';

class MainScrean extends StatefulWidget {
  @override
  _MainScreanState createState() => _MainScreanState();
}

class _MainScreanState extends State<MainScrean> {

@override
  void initState() {
    super.initState();
    HomeState.state=this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(),
      body: AnimatedBackground(
        child: HomeState.children[HomeState.selected],
      ),
    );
  }
}

class HomeState{
  static final List<Widget> children = [
    Alarm(),
    Friends(),
    AddFriends(),
    Settings(),
  ];

  static State state;
  static int selected=0;
}