import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help/Firebase/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFriendItem extends StatefulWidget {
  String name, photo, uid;

  AddFriendItem(String name, String photo, uid) {
    this.name = name;
    this.photo = photo;
    this.uid = uid;
  }

  @override
  _AddFriendItemState createState() => _AddFriendItemState(name, photo, uid);
}

class _AddFriendItemState extends State<AddFriendItem> {
  String name, photo, uid;
  Color buttonColor = Colors.white;
  Icon icon;

  _AddFriendItemState(String name, String photo, String uid) {
    this.name = name;
    this.photo = photo;
    this.uid = uid;
  }

  @override
  void initState() {
    icon = Icon(Icons.add);
    super.initState();
    isfriend(uid);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (e) {
        addFriend(uid, name, photo);
        isfriend(uid);
        setState(() {
          buttonColor = Colors.white70;
        });
      },
      onTapUp: (e) {
        setState(() {
          buttonColor = Colors.white;
        });
      },
      child: Card(
        elevation: 5,
        color: buttonColor,
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(photo),
                maxRadius: 25,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 5),
                  child: icon,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addFriend(String uid, String name, String photo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getStringList('UID') == null) {
      sharedPreferences.setStringList('UID', List<String>());
      sharedPreferences.setStringList('name', List<String>());
      sharedPreferences.setStringList('photo', List<String>());
    }
    if (!sharedPreferences.getStringList('UID').contains(uid)) {
      List uidList = sharedPreferences.getStringList('UID');
      List nameList = sharedPreferences.getStringList('name');
      List photoList = sharedPreferences.getStringList('photo');
      uidList.add(uid);
      nameList.add(name);
      photoList.add(photo);
      sharedPreferences.setStringList('UID', uidList);
      sharedPreferences.setStringList('name', nameList);
      sharedPreferences.setStringList('photo', photoList);
    } else {
      int index = sharedPreferences.getStringList('UID').indexOf(uid);
      sharedPreferences.getStringList('UID').removeAt(index);
      sharedPreferences.getStringList('name').removeAt(index);
      sharedPreferences.getStringList('photo').removeAt(index);
    }
  }

  void isfriend(String uid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (sharedPreferences.getStringList('UID') != null) {
        if (sharedPreferences.getStringList('UID').contains(uid)) {
          icon = Icon(
            Icons.check,
            color: Colors.green,
          );
        } else
          icon = Icon(Icons.add);
      } else
        icon = Icon(Icons.add);
    });
  }
}
