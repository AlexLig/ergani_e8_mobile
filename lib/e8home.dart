import 'package:flutter/material.dart';
import 'package:ergani_e8/e8create.dart';
import 'package:ergani_e8/e8cancel.dart';

class E8home extends StatefulWidget {
  final VatNumbers vatNumbers;
  final TimeOfDay commonFinishHour;
  E8home({Key key, @required this.vatNumbers, this.commonFinishHour})
      : super(key: key);

  @override
  E8HomeState createState() => E8HomeState();
}

class E8HomeState extends State<E8home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    E8form(
      vatNumbers: new VatNumbers(
          afmEmployee: '123456789',
          afmEmployer: '1053838105',
          ameEmployer: '9999777710'),
    ),
    E8formCancel(
      vatNumbers: new VatNumbers(
          afmEmployee: '123456789',
          afmEmployer: '1053838105',
          ameEmployer: '9999777710'),
    )
  ];

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
