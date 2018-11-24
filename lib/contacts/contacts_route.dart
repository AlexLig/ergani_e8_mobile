import 'dart:async';
import 'package:ergani_e8/components/empty_contacts_indicator.dart';
import 'package:ergani_e8/components/delete_dialog.dart';
import 'package:ergani_e8/contacts/drawer.dart';
import 'package:ergani_e8/components/edit_dialog.dart';
import 'package:ergani_e8/contacts/employee.dart';
import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/contacts/employer.dart';
import 'package:ergani_e8/create_employee_route.dart';
import 'package:ergani_e8/e8/e8route.dart';
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
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '111111111'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '222222222'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '333333333'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '111111111'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '222222222'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '333333333'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '111111111'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '222222222'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '333333333'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '111111111'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '222222222'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '333333333'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '111111111'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '222222222'),
    Employee(
        firstName: 'Ηλιάννα', lastName: 'Παπαγεωργίου', vatNumber: '333333333'),
  ];

  void _handleDelete({scaffoldContext, Employee employee}) async {
    final employeeToDelete = await showDialog(
      context: scaffoldContext,
      barrierDismissible: true,
      builder: (context) => DeleteDialog(employee: employee),
    );

    if (employeeToDelete is Employee) {
      setState(() {
        employeeList = employeeList
            .where((el) => el.vatNumber != employeeToDelete.vatNumber)
            .toList();
      });
      Scaffold.of(scaffoldContext).showSnackBar(
        _successfulDeleteSnackbar(context),
      );
    }
  }

  void _handleEdit({scaffoldContext, Employee employee}) async {
    final employeeToAdd = await showDialog(
      context: scaffoldContext,
      barrierDismissible: false,
      builder: (context) => EditDialog(employee: employee),
    );

    if (employeeToAdd is Employee) print(employeeToAdd);
  }

  _handleTapEmployee({Employee employee}) async {
    final e8FormCompleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => E8route(
              employee: employee,
              employer: Employer(vatNumberAFM: '123123123'),
            ),
      ),
    );
  }

  SnackBar _successfulDeleteSnackbar(context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.info),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Ο υπάλληλος διαγράφηκε.',
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        textColor: Colors.blue,
        label: 'ΑΝΑΙΡΕΣΗ',
        onPressed: () => print('Trolled.'),
      ),
      // TODO: Undo delete.
    );
  }

  _buildEmployeeList(context) {
    return ListView.builder(
      itemCount: employeeList.length,
      itemBuilder: (BuildContext context, int i) {
        return Column(
          children: <Widget>[
            EmployeeListTile(
              employee: employeeList[i],
              onDelete: () {
                _handleDelete(
                  scaffoldContext: context,
                  employee: employeeList[i],
                );
              },
              onEdit: () {
                _handleSubmitEmployee(
                  context: context,
                  employee: employeeList[i],
                );
              },
              onTap: () => _handleTapEmployee(employee: employeeList[i]),
            ),
            i == employeeList.length - 1
                ? Container(height: 50.0)
                : Container(),
          ],
        );
      },
    );
  }

  _handleSubmitEmployee({context, Employee employee}) async {
    final newEmployee = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EmployeeForm(),
    );

    if (newEmployee is Employee) {
      setState(() => employeeList.add(newEmployee));
      //   Scaffold.of(scaffoldContext).showSnackBar(
      //     SnackBar(
      //       content: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: <Widget>[
      //           Icon(Icons.check_circle),
      //           Text(
      //             'Ο υπάλληλος προστέθηκε.',
      //           ),
      //         ],
      //       ),
      //       backgroundColor: Colors.green,
      //     ),
      //   );
    }
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
            onPressed: () => _handleSubmitEmployee(context: context),
          ),
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
                    : _buildEmployeeList(context),
              ),
            ],
          ),
        );
      }),
      drawer: ContactsDrawer(),
    );
  }
}
