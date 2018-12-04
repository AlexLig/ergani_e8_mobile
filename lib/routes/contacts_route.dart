import 'package:ergani_e8/components/drawer.dart';
import 'package:ergani_e8/components/empty_contacts_indicator.dart';
import 'package:ergani_e8/components/delete_dialog.dart';
import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/routes/e8form.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/routes/create_employee_route.dart';

import 'package:ergani_e8/utils/database_helper.dart';
import 'package:flutter/material.dart';

class ContactsRoute extends StatefulWidget {
  ContactsRoute();
  @override
  ContactsRouteState createState() => ContactsRouteState();
}

class ContactsRouteState extends State<ContactsRoute> {
  BuildContext _scaffoldContext;
  ErganiDatabase _erganiDatabase = ErganiDatabase();
  // List<Employee> _employeeList = <Employee>[];
  List<Employee> _employeeList;
  Employer _employer;

  bool isLoading = false;
  Employee _deletedEmployee;

  @override
  initState() {
    super.initState();
    _updateListView();
  }

  void _updateListView() async {
    final List<Employee> employeeList = await _erganiDatabase.getEmployeeList();
    final Employer employer = await _erganiDatabase.getNewestEmployer();
    setState(() {
      _employeeList = employeeList;
      _employer = employer;
    });
  }

  /// Navigates to the create_employee_route, awaits for Navigator.pop result. If result is Employee means that create/edit was sucessful so display snackbar and update the listView.
  void _handleSubmit(context, [Employee employee]) async {
    final newEmployee = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEmployeeRoute(employee: employee),
      ),
    );
    if (newEmployee is Employee) {
      Scaffold.of(_scaffoldContext)
          .showSnackBar(_successfulCreateSnackbar(_scaffoldContext));
      _updateListView();
    }
  }

  void _handleTap(Employee employee) async {
    final e8FormCompleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => E8form(employee: employee, employer: _employer),
      ),
    );
  }

  void _handleDelete(context, Employee employee) async {
    final employeeToDelete = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => DeleteDialog(employee: employee),
    );
    if (employeeToDelete is Employee) {
      int result = await _deleteEmployee(employeeToDelete);
      if (result != 0) {
        Scaffold.of(context).showSnackBar(_successfulDeleteSnackbar(context));
        _updateListView();
      }
    }
  }

  Future<int> _deleteEmployee(Employee employeeToDelete) async {
    _deletedEmployee = employeeToDelete;
    int result = await _erganiDatabase.deleteEmployee(employeeToDelete);
    return result;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Υπάλληλοι')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleSubmit(context),
        child: Icon(Icons.person_add),
      ),
      // Needed to open a snackbar.
      // This happens because you are using the context of the widget that instantiated Scaffold.
      // Not the context of a child of Scaffold. 
      // You can solve this by simply using a different context :
      body: Builder(
        builder: (context) => _buildBody(context),
      ),
      drawer: ContactsDrawer(employer:_employer), // Pass employer of context
    );
  }

  _buildBody(context) {
    _scaffoldContext = context;
    // _employeeList ?? _updateListView();
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: _employeeList == null
                ? Container()
                : _employeeList.length == 0
                    ? AddContactsIndicator()
                    : _buildEmployeeListView(),
          ),
        ],
      ),
    );
  }

  ListView _buildEmployeeListView() {
    return ListView.builder(
      itemCount: _employeeList.length,
      itemBuilder: (BuildContext context, int i) {
        Employee employee = _employeeList[i];
        return Column(
          children: <Widget>[
            EmployeeListTile(
              employee: employee,
              onDelete: () => _handleDelete(context, employee),
              onEdit: () => _handleSubmit(context, employee),
              onTap: () => _handleTap(employee),
            ),
            i == _employeeList.length - 1
                ? SizedBox(height: 100.0)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      indent: 40.0,
                    ),
                  ),
          ],
        );
      },
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
        label: 'ΑΝΑΙΡΕΣΗ',
        onPressed: () async {
          await _erganiDatabase.createEmployee(_deletedEmployee);
          _updateListView();
          setState(() => _deletedEmployee = null);
        },
      ),
      // TODO: Undo delete.
    );
  }

  SnackBar _successfulCreateSnackbar(context) {
    return SnackBar(
      duration: Duration(seconds: 2),
      content: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text('Ο υπάλληλος αποθηκεύτηκε.'),
      ),
    );
  }
}
