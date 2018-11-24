import 'package:ergani_e8/contacts/contacts_route.dart';
import 'package:ergani_e8/contacts/employee.dart';
import 'package:ergani_e8/contacts/employer.dart';
import 'package:ergani_e8/create_employee_route.dart';
import 'package:ergani_e8/e8/e8homeInher.dart';

import 'package:ergani_e8/e8/e8screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('ERGANI'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.amber,
        height: 300,
        child: Center(
          child: Column(
            children: <Widget>[
              TestButton(title: 'E8', route: EmployeeForm()),
              TestButton(title: 'Contacts', route: ContactsRoute()),
              TestButton(
                  title: 'inherit',
                  route: E8homeInherited(
                    employer: Employer(vatNumberAFM: "000000000"),
                    employee: Employee(
                        firstName: "Hliana",
                        lastName: "Papageorgiou",
                        vatNumber: "1053838105"),
                    child: E8home(),
                  )),
            ],
          ),
        ),
      ),
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
