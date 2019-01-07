import 'package:ergani_e8/employee_form/employee_bloc.dart';
import 'package:flutter/material.dart';

class EmployeeProvider extends InheritedWidget {
  final employeeBloc = new EmployeeBloc();

  EmployeeProvider({
    Key key,
    Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static EmployeeBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(EmployeeProvider)
              as EmployeeProvider)
          .employeeBloc;
}
