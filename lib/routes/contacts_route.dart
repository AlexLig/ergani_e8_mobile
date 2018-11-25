import 'package:ergani_e8/components/drawer.dart';
import 'package:ergani_e8/components/empty_contacts_indicator.dart';
import 'package:ergani_e8/components/delete_dialog.dart';
import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/routes/create_employee_route.dart';
import 'package:ergani_e8/routes/e8route.dart';
import 'package:flutter/material.dart';

class ContactsRoute extends StatefulWidget {
  final List<Employee> employeeList;

  ContactsRoute({@required this.employeeList});

  @override
  ContactsRouteState createState() => ContactsRouteState();
}

class ContactsRouteState extends State<ContactsRoute> {
  final double _appBarHeight = 100.0;
  bool isLoading = false;
  List<Employee> employeeList;
  Employee deletedEmployee;

  @override
  void initState() {
    super.initState();
    employeeList = widget.employeeList;
  }

  void _handleEdit({scaffoldContext, Employee employee}) async {
    final newEmployee = await showDialog(
      context: scaffoldContext,
      barrierDismissible: false,
      builder: (context) => EmployeeForm(employee: employee),
    );

    if (newEmployee is Employee) {
      _deleteEmployee(employee);
      _addEmployee(newEmployee);
    }
  }

  void _handleSubmitEmployee({scaffoldContext, Employee employee}) async {
    final newEmployee = await showDialog(
      context: scaffoldContext,
      barrierDismissible: false,
      builder: (context) => EmployeeForm(employee: employee),
    );

    if (newEmployee is Employee) _addEmployee(newEmployee);
  }

  void _handleTapEmployee({Employee employee}) async {
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

  void _handleDelete({scaffoldContext, Employee employee}) async {
    final employeeToDelete = await showDialog(
      context: scaffoldContext,
      barrierDismissible: true,
      builder: (context) => DeleteDialog(employee: employee),
    );

    if (employeeToDelete is Employee) {
      _deleteEmployee(employeeToDelete);
      Scaffold.of(scaffoldContext).showSnackBar(
        _successfulDeleteSnackbar(context),
      );
    }
  }

  void _deleteEmployee(Employee employeeToDelete) {
    setState(() {
      employeeList = employeeList
          .where((el) => el.vatNumber != employeeToDelete.vatNumber)
          .toList();
      deletedEmployee = employeeToDelete;
    });
  }

  void _addEmployee(Employee newEmployee) {
    if (newEmployee != null) setState(() => employeeList.add(newEmployee));
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
            onPressed: () => _handleSubmitEmployee(scaffoldContext: context),
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
                    : ListView.builder(
                        itemCount: employeeList.length,
                        itemBuilder: _buildEmployeeList(context),
                      ),
              ),
            ],
          ),
        );
      }),
      drawer: ContactsDrawer(),
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
            child: Text('Ο υπάλληλος διαγράφηκε.'),
          ),
        ],
      ),
      action: SnackBarAction(
        textColor: Colors.blue,
        label: 'ΑΝΑΙΡΕΣΗ',
        onPressed: () {
          _addEmployee(deletedEmployee);
          setState(() => deletedEmployee = null);
        },
      ),
      // TODO: Undo delete.
    );
  }

  Function _buildEmployeeList(context) {
    return (BuildContext context, int i) {
      Employee employee = employeeList[i];
      return Column(
        children: <Widget>[
          EmployeeListTile(
            employee: employee,
            onDelete: () {
              _handleDelete(
                scaffoldContext: context,
                employee: employee,
              );
            },
            onEdit: () {
              _handleEdit(
                scaffoldContext: context,
                employee: employee,
              );
            },
            onTap: () {
              _handleTapEmployee(
                employee: employee,
              );
            },
          ),
          i == employeeList.length - 1
              ? Container(height: 50.0)
              : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Divider(
                    indent: 60.0,
                  ),
                ),
        ],
      );
    };
  }
}
