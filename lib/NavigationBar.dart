import 'package:flutter/material.dart';
import 'package:help/mainScrean.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int selectedItem=0;

  void onItemTaped(int index){
    setState(() {
      selectedItem=index;
      HomeState.selected=index;
      HomeState.state.setState((){});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.deepOrange[500],
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.new_releases),
          title: Text('Alarm'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          title: Text('Friends')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add),
          title: Text('Add Friends')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ],
      selectedItemColor: Colors.white,
      currentIndex: selectedItem,
      onTap: onItemTaped,
    );
  }
}
