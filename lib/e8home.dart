import 'package:ergani_e8/contacts/employee.dart';
import 'package:ergani_e8/contacts/employer.dart';
import 'package:ergani_e8/vatNumbers.dart';
import 'package:flutter/material.dart';
import 'package:ergani_e8/e8formCreate.dart';
import 'package:ergani_e8/e8formCancel.dart';

class E8home extends StatefulWidget {
  final Employer employer;
  final Employee employee;
  E8home({
    Key key,
    @required this.employer,
    @required this.employee,
  }) : super(key: key);

  @override
  E8homeState createState() => E8homeState();
}

class E8homeState extends State<E8home> {
  int _currentIndex = 0;
  Employer _employer;
  Employee _employee;
  List<Widget> _children = [];

  @override
  void initState() {
    _employer= widget.employer;
    _employee= widget.employee;
    // _commonFinishHour = widget.commonFinishHour == null
    //     ? TimeOfDay(hour: 16, minute: 00)
    //     : widget.commonFinishHour;
    // _vatNumbers = VatNumbers(
    //     afmEmployee: _afmEmployee,
    //     ameEmployer: _ameEmployer,
    //     afmEmployer: _afmEmployer);
    _children = [
      E8form(employer: _employer,employee: _employee,),
      // E8formCancel(vatNumbers: _vatNumbers, commonFinishHour: _commonFinishHour)
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
