import 'package:ergani_e8/employerForm/employer_bloc.dart';
import 'package:flutter/material.dart';

class EmployerBlocProvider extends InheritedWidget {
  final employerBloc = new EmployerBloc();

  EmployerBlocProvider({
    Key key,
    Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static EmployerBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(EmployerBlocProvider)
              as EmployerBlocProvider)
          .employerBloc;
}
