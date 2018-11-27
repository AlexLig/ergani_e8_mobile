import 'package:ergani_e8/models/employee.dart';
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

  @override
  void initState() {
    super.initState();
    employeeList = <Employee>[
      Employee(
          'Ηλιάννα', 'Παπαγεωργίου', '111111111', hoursMinsToTime(15, 30)),
      Employee('Κωστής', 'Παλαμάς', '222222222', hoursMinsToTime(14, 20)),
      Employee(
          'Αλέξανδρος', 'Παπαδιαμάντης', '333333333', hoursMinsToTime(16, 50)),
      Employee('Ιωάννης', 'Ρίτσος', '444444444', hoursMinsToTime(17, 10)),
      Employee('Αδαμάντιος', 'Κοραής', '555555555', hoursMinsToTime(19, 10)),
    ];
  }

  

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
