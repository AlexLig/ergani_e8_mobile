import 'dart:async';
import 'package:ergani_e8/contacts/delete_dialog.dart';
import 'package:ergani_e8/contacts/drawer.dart';
import 'package:ergani_e8/contacts/edit_dialog.dart';
import 'package:ergani_e8/contacts/employee.dart';
import 'package:flutter/material.dart';

class ContactsRoute extends StatefulWidget {
  @override
  ContactsRouteState createState() => ContactsRouteState();
}

class Employee {
  String firstName;
  String lastName;
  String vatNumber;

  Employee({
    @required this.firstName,
    @required this.lastName,
    @required this.vatNumber,
  });
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
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '444444444'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '555555555'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '666666666'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '777777777'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '888888888'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '999999999'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '000000000'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '123456789'),
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
              try {
                setState(() {
                  employeeList = employeeList
                      .where((el) => el.vatNumber != vatNumber)
                      .toList();
                });
                Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
                  content: Text('Ο υπάλληλος διαγράφηκε.'),
                  backgroundColor: Colors.green,
                  // TODO: Undo delete.
                ));
              } catch (e) {
                Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
                  content: Text('Σφάλμα διαγραφής υπαλλήλου.'),
                  backgroundColor: Colors.orange,
                ));
                print(e);
              }
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              tooltip: 'Προσθήκη Υπαλλήλου',
              icon: Icon(Icons.person_add, color: Colors.white),
              // SnackBar not working here. Need GlobalKey??
              onPressed: () => _handleEdit(context),
            ),
          ),
        ],
      ),

      // Needed to open a snackbar.
      // This happens because you are using the context of the widget that instantiated Scaffold.
      // Not the context of a child of Scaffold.
      // You can solve this by simply using a different context :
      body: Builder(builder: (context) {

        return Container(
          color: employeeList.length == 0 ? Colors.grey[200] : Colors.white ,
          child: Column(
            children: <Widget>[
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
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
                                onTap: () => _showSnackBar(
                                    context, 'Την Ηλιάννα ρε λιγούρη;'),
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
}
