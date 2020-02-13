import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help/Friend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:help/addFriends.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  SharedPreferences sharedPreferences;
  List<bool> isExpended =List();
  List<ExpansionPanel> items=List();

  @override
  void initState() {
    super.initState();
    makeItemList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),

              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text('Your friends:', style: TextStyle(fontSize: 22),),
              ),

              SizedBox(
                height: 10,
              ),


              Expanded(
                child: SingleChildScrollView(
                  child: ExpansionPanelList(
                    expansionCallback: (index,isExpended){
                      setState(() {
                        this.isExpended[index]=!isExpended;
                        makeItemList();
                      });
                    },
                    children: items,
                  ),
                ),
              ),
            ],
          )),
    );
  }


  void makeItemList() async {
    await initSharedPreferences();
    List<String> uid = sharedPreferences.getStringList('UID');
    List<String> name = sharedPreferences.getStringList('name');
    List<String> photo = sharedPreferences.getStringList('photo');
    items=List();
    for (int i = 0; i < uid.length; i++) {
      if(isExpended.length<uid.length)
      this.isExpended.add(false);
      items.add(
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [CircleAvatar(
                    backgroundImage: NetworkImage(photo[i]),
                    maxRadius: 25,
                  ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      name[i],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ]
                  ),
                );
              },
              body: Text('TODO'),
              isExpanded: isExpended[i]
          )
      );
      setState(() {});
    }
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

}
