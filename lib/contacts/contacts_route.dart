import 'dart:async';
import 'package:ergani_e8/components/empty_contacts_indicator.dart';
import 'package:ergani_e8/components/delete_dialog.dart';
import 'package:ergani_e8/contacts/drawer.dart';
import 'package:ergani_e8/components/edit_dialog.dart';
import 'package:ergani_e8/contacts/employee.dart';
import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/create_employee_route.dart';
import 'package:flutter/material.dart';

class ContactsRoute extends StatefulWidget {
  @override
  ContactsRouteState createState() => ContactsRouteState();
}

class ContactsRouteState extends State<ContactsRoute> {
  final double _appBarHeight = 100.0;
  var isLoading = false;
  List<Employee> employeeList = [
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '111111111'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '222222222'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '333333333'),
  ];

  void _handleDelete({
    scaffoldContext,
    String firstName,
    String lastName,
    String vatNumber,
  }) {
    showDialog(
        context: scaffoldContext,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DeleteDialog(
            firstName: firstName,
            lastName: lastName,
            onDelete: () {
              setState(() {
                employeeList = employeeList
                    .where((el) => el.vatNumber != vatNumber)
                    .toList();
              });
              Scaffold.of(scaffoldContext).showSnackBar(
                SnackBar(
                  content: Text('Ο/Η $lastName $firstName διαγράφηκε.'),
                  backgroundColor: Colors.green,
                  // TODO: Undo delete.
                ),
              );
              Navigator.of(context).pop();
            },
          );
        });
  }

  Future<void> _handleEdit(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return EditDialog(
            onSave: () => Navigator.of(context).pop(),
          );
        });
  }

  _showSnackBar(context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.green,
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Not really',
        onPressed: () => print('Trolled.'),
      ),
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
        ),
        title: Text('Υπάλληλοι'),
        actions: <Widget>[
          IconButton(
              tooltip: 'Προσθήκη Υπαλλήλου',
              icon: Icon(Icons.person_add, color: Colors.white),
              // SnackBar not working here. Need GlobalKey??
              onPressed: () => _handleSubmitEmployee(context)),
        ],
      ),

      // Needed to open a snackbar.
      // This happens because you are using the context of the widget that instantiated Scaffold.
      // Not the context of a child of Scaffold.
      // You can solve this by simply using a different context :
      body: Builder(builder: (context) {
        return Container(
          color: employeeList.length == 0 ? Colors.grey[200] : Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: employeeList.length == 0
                    ? AddContactsIndicator()
                    : ListView.builder(
                        itemCount: employeeList.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Column(
                            children: <Widget>[
                              EmployeeListTile(
                                firstName: employeeList[i].firstName,
                                lastName: employeeList[i].lastName,
                                vatNumber: employeeList[i].vatNumber,
                                onDelete: () {
                                  _handleDelete(
                                    scaffoldContext: context,
                                    firstName: employeeList[i].firstName,
                                    lastName: employeeList[i].lastName,
                                    vatNumber: employeeList[i].vatNumber,
                                  );
                                },
                                onEdit: () => _handleEdit(context),
                                onTap: () => print(''),
                                // overtimeStart: overtimeStart,
                              ),
                              i == employeeList.length - 1
                                  ? Container(height: 32.0)
                                  : Container(),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
      drawer: ContactsDrawer(),
    );
  }

  _handleSubmitEmployee(context) async {
    final newEmployee = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeForm(),
      ),
    );
    if (newEmployee is Employee) setState(() => employeeList.add(newEmployee));
  }
}
