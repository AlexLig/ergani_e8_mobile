import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/components/sliderTimePicker.dart';
import 'package:ergani_e8/e8/e8provider.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:flutter/material.dart';

class E8form extends StatefulWidget {
  // E8form(BuildContext context);
  @override
  E8formState createState() => E8formState();
}

class E8formState extends State<E8form> {
  Widget _ameTextChild;
  Employer _employer;
  Employee _employee;
  @override
  void initState() {
    super.initState();
  }

  Widget _buildEmployee(BuildContext context) => EmployeeListTile(
    employee: _employee,
  );
  //  ListTile(
  //       title: Text('${_employee.lastName} ${_employee.firstName}'),
  //       subtitle: Text('ΑΦΜ: ${_employee.vatNumber}'),
  //     );
  Widget _buildEmployer(BuildContext context) => ListTile(
        title: Text('${_employer.name} '),
        subtitle: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text('ΑΦΜ: ${_employer.vatNumberAFM}'),
            ),
            _ameTextChild
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    _employer = E8provider.of(context).employer;
    _employee = E8provider.of(context).employee;
    _ameTextChild = _employer.vatNumberAME == null
        ? Container()
        : Text('ΑΜΕ: ${_employer.vatNumberAME}');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message), onPressed: () => print('hi')),
      appBar: AppBar(
        title: Text('Νέα υποβολή'),
      ),
      body: Builder(
        builder: (context) => Column(
              children: <Widget>[
                _buildEmployer(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          _buildEmployee(context),
                          Divider(),
                          SliderTimePicker(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
      ),
    );
  }
}
