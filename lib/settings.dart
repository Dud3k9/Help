import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double maxHeight,maxWidth;
  SharedPreferences sharedPreferences;
  String imageUrl =
      'https://www.pngitem.com/pimgs/m/264-2647677_avatar-icon-human-user-avatar-svg-hd-png.png';
  String name = 'name';
  Color buttonColor=Colors.red;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    maxHeight=MediaQuery.of(context).size.height;
    maxWidth=MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
        SizedBox(
            height: maxHeight*0.1,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            maxRadius: maxHeight*0.06,
          ),
          SizedBox(
            height: maxHeight*0.02,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: maxHeight*0.04,
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Container(
              width: maxWidth*0.85,
              height: maxHeight*0.4,
              child: Column(
                children: <Widget>[
                ],
              ),
            ),
          ),

          SizedBox(height: maxHeight*0.03,),

          GestureDetector(
            onTapDown: (e){
              setState(() {
                buttonColor=Colors.redAccent;
              });
            },

            onTapUp: (e){
              setState(() {
                buttonColor=Colors.red;
                sharedPreferences.remove('uid');
                sharedPreferences.setBool('IsLogIn', false);
                Navigator.pushReplacementNamed(context, '/LogIn');
              });
            },

            child: Container(
              padding: EdgeInsets.all(maxHeight*0.015),
              child: Icon(Icons.exit_to_app),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: buttonColor,
                boxShadow: [BoxShadow(color: Colors.black,blurRadius: 3, offset: Offset(1,2))],
              ),
            ),
          ),
          Text('Log out',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),)
        ],
      ),
    );
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Firestore.instance
        .collection('users')
        .document(sharedPreferences.getString('uid'))
        .snapshots()
        .listen((data) {
      setState(() {
        imageUrl = '${data['photo']}';
        name = '${data['name']}';
      });
    });
  }
}
