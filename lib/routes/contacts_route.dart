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

import '../components/showSnackbar.dart';

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
      drawer: ContactsDrawer(employer: _employer), // Pass employer of context
    );
  }

  /// Navigates to the create_employee_route, awaits for Navigator.pop result. If result is Employee, create/edit was sucessful so display snackbar and update the listView.
  void _handleSubmit(context, [Employee employee]) async {
    final newEmployee = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEmployeeRoute(employee: employee),
      ),
    );
    if (newEmployee is Employee) {
      showSnackbar(
        scaffoldContext: _scaffoldContext,
        message: 'Ο υπάλληλος αποθηκεύτηκε.',
        duration: Duration(seconds: 2),
      );
      _updateListView();
    }
  }

  void _updateListView() async {
    final List<Employee> employeeList = await _erganiDatabase.getEmployeeList();
    final Employer employer = await _erganiDatabase.getNewestEmployer();
    setState(() {
      _employeeList = employeeList;
      _employer = employer;
    });
  }

  _buildBody(context) {
    _scaffoldContext = context;
    // _employeeList ?? _updateListView();
    return SafeArea(
      child: Container(
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
              onTap: () => _handleTap(employee),
              onDelete: () => _handleDelete(context, employee),
              onEdit: () => _handleSubmit(context, employee),
              isDestination: false,
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

  void _handleTap(Employee employee) async {
    final e8FormCompleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => E8form(employee: employee, employer: _employer),
      ),
    );
    if (e8FormCompleted == true)
      showSnackbar(
        scaffoldContext: _scaffoldContext,
        type: SnackbarType.Success,
        message: 'Το μήνυμα εστάλη με επιτυχία',
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
        // _successfulDeleteSnackbar(context);
        showSnackbar(
          scaffoldContext: context,
          message: 'Ο υπάλληλος διαγράφηκε.',
          type: SnackbarType.Info,
          action: SnackBarAction(
              label: 'ΑΝΑΙΡΕΣΗ', onPressed: this._undoDeleteEmployee),
        );
        _updateListView();
      }
    }
  }

  Future<int> _deleteEmployee(Employee employeeToDelete) async {
    _deletedEmployee = employeeToDelete;
    int result = await _erganiDatabase.deleteEmployee(employeeToDelete);
    return result;
  }

  void _undoDeleteEmployee() async {
    await _erganiDatabase.createEmployee(_deletedEmployee);
    _updateListView();
    setState(() => _deletedEmployee = null);
  }
}
