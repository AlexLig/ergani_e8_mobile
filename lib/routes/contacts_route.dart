import 'package:ergani_e8/components/drawer.dart';
import 'package:ergani_e8/components/empty_contacts_indicator.dart';
import 'package:ergani_e8/components/delete_dialog.dart';
import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/routes/create_employee_route.dart';
import 'package:ergani_e8/routes/e8route.dart';
import 'package:ergani_e8/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContactsRoute extends StatefulWidget {
  ContactsRoute();
  @override
  ContactsRouteState createState() => ContactsRouteState();
}

class ContactsRouteState extends State<ContactsRoute> {
  ErganiDatabase _databaseHelper = ErganiDatabase();
  List<Employee> _employeeList = <Employee>[];
  Employer _employer;

  bool isLoading = false;
  Employee _deletedEmployee;

  @override
  initState() {
    super.initState();
    _updateListView();
  }

  void _updateListView() async {
    // Attempt 1.
    // final List<Employee> employeeList = await database.getEmployeeList();
    // setState(() => _employeeList.setAll(0, employeeList));

    // Attempt 2.
    // final Future<Database> dbFuture =  _databaseHelper.initializeDatabase();
    // dbFuture.then((database){
    //   Future<List<Employee>> employeeListFuture = _databaseHelper.getEmployeeList();
    //   employeeListFuture.then((employeeList) => setState(() => _employeeList = employeeList) );
    // });

    //  Attempt 3.
    // final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    // dbFuture.then((database) {
    //   Future<List<Employee>> employeeListFuture =
    //       _databaseHelper.getEmployeeList();
    //   employeeListFuture.then((employeeList) => setState(
    //       () => _employeeList.add(employeeList[_employeeList.length])));
    // });

    // Attempt 4.
    final List<Employee> employeeList = await _databaseHelper.getEmployeeList();
    setState(() {
      _employeeList = employeeList;
    });
  }

  /// Event Handlers.
  void _handleSubmit([Employee employee]) async {
    final newEmployee = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEmployeeRoute(employee: employee),
      ),
    );

    if (newEmployee is Employee) {
      if (employee != null) _deleteEmployee(employee);
      _addEmployee(newEmployee);
    }
  }

  void _handleTap(Employee employee) async {
    final e8FormCompleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => E8route(employee: employee, employer: _employer),
      ),
    );
  }

  void _handleDelete(context, Employee employee) async {
    final employeeToDelete = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => DeleteDialog(employee: employee),
    );

    if (employeeToDelete is Employee) _deleteEmployee(employeeToDelete);
  }

  /// CRUD operations.
  void _deleteEmployee(Employee employeeToDelete) async {
    _deletedEmployee = employeeToDelete;
    int result = await _databaseHelper.deleteEmployee(employeeToDelete);
    if (result != 0) {
      // Scaffold.of(context).showSnackBar(_successfulDeleteSnackbar(context));
      _updateListView();
    }
  }

  Future _addEmployee(Employee newEmployee) async {
    int result = await _databaseHelper.createEmployee(newEmployee);
    if (result != 0) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Ο υπάλληλος αποθηκεύθηκε.'),
      //   backgroundColor: Colors.green,
      // ));
      _updateListView();
    } else
      debugPrint('Database responded with an Error.');
  }
  /*  Future _editEmployee(Employee employee) async {
    int result = await _databaseHelper.updateEmployee(employee);
    if (result != 0) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Ο υπάλληλος αποθηκεύθηκε.'),
      //   backgroundColor: Colors.green,
      // ));
      _updateListView();
    } else
      debugPrint('Database responded with an Error.');
  } */

  Widget build(BuildContext context) {
    // if (_employeeList == null) {
    //   _employeeList = List<Employee>();
    //   _updateListView();
    // }
    print('_employeeList.length: ${_employeeList.length}');
    print('_employeeList: $_employeeList');
    print('_employeeList type: ${_employeeList is Map}');

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
        ),
        title: Text('Υπάλληλοι'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Αναζήτηση Υπαλλήλου',
            icon: Icon(Icons.search),
            // TODO: implement search
            onPressed: () => null,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleSubmit,
        child: Icon(Icons.person_add),
      ),
      // Needed to open a snackbar.
      // This happens because you are using the context of the widget that instantiated Scaffold.
      // Not the context of a child of Scaffold.
      // You can solve this by simply using a different context :
      body: Builder(
        builder: (context) => _buildBody(),
      ),
      drawer: ContactsDrawer(),
    );
  }

  /// Build helpers.
  _buildBody() {
    return Container(
      // TODO: colors inhereted from theme.
      color: _employeeList.length == 0 ? Colors.amber[200] : Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: _employeeList.length == 0
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
              onEdit: () => _handleSubmit(employee),
              onTap: () => _handleTap(employee),
            ),
            i == _employeeList.length - 1
                ? SizedBox(height: 100.0)
                : Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Divider(
                      indent: 60.0,
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
        textColor: Colors.blue,
        label: 'ΑΝΑΙΡΕΣΗ',
        onPressed: () {
          _addEmployee(_deletedEmployee);
          setState(() => _deletedEmployee = null);
        },
      ),
      // TODO: Undo delete.
    );
  }
}
