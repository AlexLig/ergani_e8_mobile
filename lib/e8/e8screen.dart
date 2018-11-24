import 'package:ergani_e8/e8formCancel.dart';
import 'package:ergani_e8/e8formCreate.dart';
import 'package:flutter/material.dart';
import 'package:ergani_e8/e8/e8homeInher.dart';

class E8home extends StatefulWidget {
  E8home({
    Key key,
  }) : super(key: key);

  @override
  E8homeState createState() => E8homeState();
}

class E8homeState extends State<E8home> {
  int _currentIndex = 0;
  List<Widget> _children = [];

  @override
  void initState() {
    _children = [
      E8form(
        employer: E8homeInherited.of(context).empoyer,
        employee: E8homeInherited.of(context).empoyee,
      ),
      E8form(
        employer: E8homeInherited.of(context).empoyer,
        employee: E8homeInherited.of(context).empoyee,
      ),
    ];
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
