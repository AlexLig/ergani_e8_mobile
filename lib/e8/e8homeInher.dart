import 'package:ergani_e8/contacts/employee.dart';
import 'package:ergani_e8/contacts/employer.dart';
import 'package:ergani_e8/e8formCreate.dart';
import 'package:flutter/material.dart';

class E8homeInherited extends StatefulWidget {
  final Employer employer;
  final Employee employee;
  final Widget child;
  E8homeInherited({
    Key key,
    this.child,
    @required this.employer,
    @required this.employee,
  }) : super(key: key);

  @override
  E8homeInheritedState createState() => E8homeInheritedState();

  static E8homeInheritedState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_E8homeInherited) as _E8homeInherited)
        .e8homeStateData;
  }
}

class E8homeInheritedState extends State<E8homeInherited> {
  int _currentIndex = 0;
  Employer _employer;
  Employee _employee;
  List<Widget> _children = [];

  Employer get empoyer => _employer;
  Employee get empoyee => _employee;

  @override
  void initState() {
    _employer = widget.employer;
    _employee = widget.employee;
    _children = [
      E8form(
        employer: _employer,
        employee: _employee,
      )
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
    return _E8homeInherited(
      e8homeStateData: this,
      child: widget.child,
    );
  }
}

class _E8homeInherited extends InheritedWidget {
  final E8homeInheritedState e8homeStateData;
  _E8homeInherited({Key key, this.e8homeStateData, Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(_E8homeInherited old) {
    return true;
  }
}
