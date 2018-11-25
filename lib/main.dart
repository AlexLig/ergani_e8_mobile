import 'package:ergani_e8/components/delete_dialog.dart';
import 'package:ergani_e8/e8/e8home.dart';
import 'package:ergani_e8/e8/e8provider.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/routes/contacts_route.dart';
import 'package:ergani_e8/routes/create_employee_route.dart';
import 'package:ergani_e8/routes/e8route.dart';
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


  // _handleEditEmployee({
  //   @required Employee employee,
  //   @required Employee employeeToAdd,
  // }) {
  //   // final index =
  //   //     employeeList.indexWhere((el) => el.vatNumber == employee.vatNumber);
  //   // if (index != -1) {
  //   //   setState(() => employeeList.add(employeeToAdd));
  //   // }
  //   // _handleDeleteEmployee(employee);
  //   _handleDeleteEmployee(employee);
  //   _handleAddEmployee(employeeToAdd);
  // }

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
        body: Scaffold(
          body: Container(
            color: Colors.amber,
            height: 300,
            child: Center(
              child: Column(
                children: <Widget>[
                  TestButton(title: 'E8', route: EmployeeForm()),
                  TestButton(
                    title: 'Contacts',
                    route: ContactsRoute(employeeList: employeeList),
                  ),
                  TestButton(
                    title: 'inherit',
                    route: E8route(
                      employer: Employer(vatNumberAFM: '123123123'),
                      employee: Employee(
                          firstName: "Ηλιανα",
                          lastName: 'Παπαγεωργιου',
                          vatNumber: '105383810'),
                    ),
                  ),
                  TestButton(
                    title: 'inherit2',
                    route: E8provider(
                      employer: Employer(vatNumberAFM: '123123123'),
                      employee: Employee(
                          firstName: "Ηλιανα",
                          lastName: 'Παπαγεωργιου',
                          vatNumber: '105383810'),
                      child: E8home(),
                    ),
                  )
                ],
              ),
            ),
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
