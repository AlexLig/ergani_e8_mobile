import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/routes/contacts_route.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Employee> employeeList = [
    Employee(
      firstName: 'Ηλιάννα',
      lastName: 'Παπαγεωργίου',
      vatNumber: '111111111',
    ),
    Employee(firstName: 'Κωστής', lastName: 'Παλαμάς', vatNumber: '222222222'),
    Employee(
        firstName: 'Αλέξανδρος',
        lastName: 'Παπαδιαμάντης',
        vatNumber: '333333333'),
    Employee(firstName: 'Ιωάννης', lastName: 'Ρίτσος', vatNumber: '444444444'),
    Employee(
        firstName: 'Αδαμάντιος', lastName: 'Κοραής', vatNumber: '555555555'),
  ];




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactsRoute(employeeList: employeeList),
    );
  }
}

class TestButton extends StatelessWidget {
  final Widget route;
  final String title;

  TestButton({@required this.title, this.route});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(this.title),
      onPressed: _onPressedTemporary(context, this.route),
    );
  }
}

Function _onPressedTemporary(context, Widget widget) => () =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
