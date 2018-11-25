import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/components/employer_list_tile.dart';
import 'package:ergani_e8/components/sliderTimePicker.dart';
import 'package:ergani_e8/e8/e8provider.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class E8form extends StatelessWidget {
  final bool isReset;

  E8form({@required this.isReset});
  @override
  Widget build(BuildContext context) {
    Employer _employer = E8provider.of(context).employer;
    Employee _employee = E8provider.of(context).employee;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: isReset ? Colors.orange : Colors.blue,
        child: Icon(Icons.textsms),
        onPressed: () => print('hi'),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            children: <Widget>[
              EmployerListTile(employer: _employer),
              EmployeeListTile(employee: _employee),
              // SliderTimePicker(isReset: this.isReset),
              //Text(e8Parser(employer: _employer, employee: _employee ))
            ],
          );
        },
      ),
    );
  }
}
