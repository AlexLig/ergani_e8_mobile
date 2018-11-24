
import 'package:flutter/material.dart';
import 'package:ergani_e8/e8/e8form.dart';

class E8home extends StatefulWidget {
  @override
  E8homeState createState() => E8homeState();
}
class E8homeState extends State<E8home> {
  int _currentIndex = 0;
  List<Widget> _children;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
     _children = [E8form(context),E8form(context)];
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.message),
              title: new Text('Νέα υποβολή'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.delete),
              title: new Text('Ακύρωση προηγούμενης'),
            ),
          ],
        ),
        body: _children[_currentIndex]);
  }
}
