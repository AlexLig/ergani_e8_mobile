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
  ContactsRoute();
  @override
  ContactsRouteState createState() => ContactsRouteState();
}

class ContactsRouteState extends State<ContactsRoute> {
  // DatabaseHelper _databaseHelper = DataBaseHelper();
  List<Employee> _employeeList;
  int _count = 0;
  Employer _employer;

  final double _appBarHeight = 100.0;
  bool isLoading = false;
  Employee _deletedEmployee;

  @override
  void initState() {
    super.initState();
    // final Database database = await _databaseHelper.initializeDatabase(); or await _databaseHelper.initializeDatabase(); ?

    // final List<Employee> employeeList = await _databaseHelper.getEmployeeList();
    // this._employeeList = employeeList;
    // this._count = employeeList.length;
  }

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

  void _deleteEmployee(Employee employeeToDelete) async {
    _deletedEmployee = employeeToDelete;
    // int result = await databaseHelper.deleteEmployee(employeeToDelete.id);
    // if (result != 0) {
    //   Scaffold.of(context).showSnackBar(_successfulDeleteSnackbar(context));
    //   _updateListView();
    // }
  }

  void _addEmployee(Employee newEmployee) {
    if (newEmployee != null) {
      // int result = await databaseHelper.addEmployee(employeeToDelete.id);
      // if (result != 0) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Ο υπάλληλος αποθηκεύθηκε.'),
      //   backgroundColor: Colors.green,
      // ));
      //   _updateListView();
      // }
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
            tooltip: 'Αναζήτηση Υπαλλήλου',
            icon: Icon(Icons.search),
            // SnackBar not working here. Need GlobalKey??
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
      body: _buildBody(),
      drawer: ContactsDrawer(),
    );
  }

  _buildBody() {
    Builder(
      builder: (context) {
        return Container(
          // TODO: colors inhereted from theme.
          color: _employeeList.length == 0 ? Colors.grey[200] : Colors.white,
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
      },
    );
  }

  ListView _buildEmployeeListView() {
    return ListView.builder(
      itemCount: _count,
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

  void _updateListView() {
    // final Database database = await _databaseHelper.initializeDatabase();
    // final List<Employee> employeeList = await _databaseHelper.getEmployeeList();
    //  setState((){
    //    this._employeeList = employeeList;
    //    this._count = employeeList.length;
    // });
  }
}
