import 'package:ergani_e8/vatNumbers.dart';
import 'package:flutter/material.dart';
import 'package:ergani_e8/e8formCreate.dart';
import 'package:ergani_e8/e8formCancel.dart';

class E8home extends StatefulWidget {
  final String ameEmployer, afmEmployer, afmEmployee;
  final TimeOfDay commonFinishHour;
  E8home({
    Key key,
    @required this.afmEmployer,
    @required this.afmEmployee,
    this.ameEmployer,
    this.commonFinishHour,
  }) : super(key: key);

  @override
  E8homeState createState() => E8homeState();
}

class E8homeState extends State<E8home> {
  int _currentIndex = 0;
  String _afmEmployer, _ameEmployer, _afmEmployee;
  VatNumbers _vatNumbers;
  TimeOfDay _commonFinishHour;
  List<Widget> _children = [];

  @override
  void initState() {
    _afmEmployer = widget.afmEmployer;
    _ameEmployer = widget.ameEmployer;
    _afmEmployee = widget.afmEmployee;
    _commonFinishHour = widget.commonFinishHour == null
        ? TimeOfDay(hour: 16, minute: 00)
        : widget.commonFinishHour;
    _vatNumbers = VatNumbers(
        afmEmployee: _afmEmployee,
        ameEmployer: _ameEmployer,
        afmEmployer: _afmEmployer);
    _children = [
      E8form(vatNumbers: _vatNumbers, commonFinishHour: _commonFinishHour),
      E8formCancel(vatNumbers: _vatNumbers, commonFinishHour: _commonFinishHour)
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
