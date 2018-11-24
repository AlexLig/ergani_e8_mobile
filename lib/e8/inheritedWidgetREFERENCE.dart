import 'package:flutter/material.dart';

class MyInherited extends StatefulWidget {
  Widget child;

  MyInherited({this.child});

  @override
  MyInheritedState createState() => new MyInheritedState();

  static MyInheritedState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited).data;
  }
}

class MyInheritedState extends State<MyInherited> {
  String _myField;
  // only expose a getter to prevent bad usage
  String get myField => _myField;

  void onMyFieldChange(String newValue) {
    setState(() {
      _myField = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _MyInherited(
      data: this,
      child: widget.child,
    );
  }
}

/// Only has MyInheritedState as field.
class _MyInherited extends InheritedWidget {
  final MyInheritedState data;

  _MyInherited({Key key, this.data, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MyInherited old) {
    return true;
  }
}