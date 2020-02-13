import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:help/Firebase/database.dart';
import 'package:help/Friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFriends extends StatefulWidget {
  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {

  String userName;

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
                child: Text('Find your friends:',style: TextStyle(fontSize: 22),),
              ),
              TextField(
                style: TextStyle(color: Colors.white70),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(30)),
                  hintText: 'Name',
                ),
                onChanged: (text) {
                  onTextChanged(text);
                },
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(

                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('users')
                        .where('name', isEqualTo: userName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading...');
                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => addItem(snapshot.data.documents[index]),
                      );
                    },
                  ))
            ],
          )),
    );
  }

  onTextChanged(String name) async {
    setState(() {
      userName = name;
    });
  }

  Widget addItem(DocumentSnapshot document) {
    return AddFriendItem(document['name'],document['photo'],document.documentID);
  }
}
