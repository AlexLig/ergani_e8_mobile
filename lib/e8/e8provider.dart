import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:flutter/material.dart';

class E8provider extends InheritedWidget {
  final Employer employer;
  final Employee employee;
  final Widget child;

  E8provider({
    Key key,
    this.employer,
    this.employee,
    this.child,
  }) : super(key: key, child: child);
  static E8provider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(E8provider);
  }

  @override
  bool updateShouldNotify(E8provider old) {
    return true;
  }
}
