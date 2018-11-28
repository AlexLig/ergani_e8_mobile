import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/routes/contacts_route.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Employee> employeeList;
  Employer _employer;

  @override
  void initState() {
    super.initState();
    employeeList = <Employee>[
      Employee(
          'Ηλιάννα', 'Παπαγεωργίου', '111111111', TimeOfDay(hour: 15, minute: 30)),
      Employee('Κωστής', 'Παλαμάς', '222222222', TimeOfDay(hour: 14, minute: 20)),
      Employee(
          'Αλέξανδρος', 'Παπαδιαμάντης', '333333333', TimeOfDay(hour: 16, minute: 50)),
      Employee('Ιωάννης', 'Ρίτσος', '444444444', TimeOfDay(hour: 17, minute: 10)),
      Employee('Αδαμάντιος', 'Κοραής', '555555555', TimeOfDay(hour: 19, minute: 10)),
    ];
    _employer = Employer('000022222','KyrBabisAE');
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactsRoute(employeeList: employeeList, employer: _employer,),
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
