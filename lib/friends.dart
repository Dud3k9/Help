import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  double width;

  @override
  void initState() {
    super.initState();
    makeItemList();
  }

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
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
    List<bool> alarms=await checkAlarm(uid);

    items=List();
    for (int i = 0; i < uid.length; i++) {

      if(isExpended.length<uid.length)
      this.isExpended.add(false);
      items.add(
          ExpansionPanel(
              isExpanded: isExpended[i],
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
                    Column(
                      children: <Widget>[
                        Text(
                          name[i],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: width*0.04,),
                        ),
                        Text(alarms[i] ? '   ALARM!' : '',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18)),
                      ],
                    ),
                  ]
                  ),
                );
              },
              body: FriendBody(uid[i],name[i],photo[i],alarms[i]),

          )
      );
      setState(() {});
    }
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<List<bool>> checkAlarm(List<String> uids) async{
    List<bool> alarms=List();
    for(int i=0;i<uids.length;i++){
      await Firestore.instance.collection('users').document(uids[i]).get().then((data){
        if(data['alarm'])
          alarms.add(true);
        else
          alarms.add(false);
      });
    }
    return alarms;
  }
}



class FriendBody extends StatefulWidget {
  String uid,name,photo;
  bool alarm;

  FriendBody(this.uid,this.name,this.photo,this.alarm){}

  @override
  _FriendBodyState createState() => _FriendBodyState();
}

class _FriendBodyState extends State<FriendBody> {
  Icon icon=Icon(Icons.delete,size: 35,);
  String coordinates,date='loading...';
  @override
  void initState() {
    super.initState();
    if(widget.alarm)
    getLocalization();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.alarm) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Date: '+date,style: TextStyle(fontSize: 16),),
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 20,),
                (coordinates!=null)?
                Row(
                  children: <Widget>[
                    Text('Localization: ',style: TextStyle(fontSize: 16),),
                    IconButton(icon:Icon(Icons.map,size: 36,),onPressed: (){onPresedMap();},),
                  ],
                )
                :Text('No localization',style: TextStyle(fontSize: 16,),),
                Expanded(
                    child: Container(

                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(5),
                      child: IconButton(icon: icon, onPressed: (){onPresedDeleate();},),
                    )
                )
              ],
            ),
          ],
        ),
      );
    }else
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Text('No alarm',style: TextStyle(fontSize: 16),),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(5),
                  child: IconButton(icon: icon, onPressed: (){onPresedDeleate();},),
            )
            )
          ],

        ),
      );
  }

  onPresedMap(){
      List<String> loc = coordinates.split(' ');

      if (Platform.isAndroid) {
        final AndroidIntent intent = new AndroidIntent(
            action: 'action_view',
            data: Uri.encodeFull(
                "https://www.google.com/maps/search/?api=1&query=${loc[0]},${loc[1]}"),
            package: 'com.google.android.apps.maps');
        intent.launch();
      }
  }

  onPresedDeleate() async{
    if(icon.icon==Icons.delete){
      setState(() {
        icon = Icon(Icons.clear, size: 35, color: Colors.red,);
      });
      Future.delayed(Duration(seconds: 1,), () {
        setState(() {
          icon = Icon(Icons.add, size: 35, color: Colors.green,);
        });
      });
    }else{
      setState(() {
        icon = Icon(Icons.delete, size: 35,);
      });
    }


    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    if (!sharedPreferences.getStringList('UID').contains(widget.uid)) {

      List uidList = sharedPreferences.getStringList('UID');
      List nameList = sharedPreferences.getStringList('name');
      List photoList = sharedPreferences.getStringList('photo');
      uidList.add(widget.uid);
      nameList.add(widget.name);
      photoList.add(widget.photo);
      sharedPreferences.setStringList('UID', uidList);
      sharedPreferences.setStringList('name', nameList);
      sharedPreferences.setStringList('photo', photoList);
    } else {
      int index = sharedPreferences.getStringList('UID').indexOf(widget.uid);
      sharedPreferences.getStringList('UID').removeAt(index);
      sharedPreferences.getStringList('name').removeAt(index);
      sharedPreferences.getStringList('photo').removeAt(index);

    }
  }

  getLocalization()async{
    Firestore.instance.collection('users').document(widget.uid)
        .collection('alarmsInfo').getDocuments().then((documents)async{
      int last=await documents.documents.length-1;
      date=await documents.documents[last].data['date'];
      coordinates=await documents.documents[last].data['localization'];
      setState(() {});
    });
  }

}

