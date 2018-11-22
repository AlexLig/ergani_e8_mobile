import 'dart:convert';
import 'package:ergani_e8/contacts/drawer.dart';
import 'package:ergani_e8/contacts/employee.dart';
import 'package:flutter/material.dart';

class ContactsRoute extends StatefulWidget {
  @override
  ContactsRouteState createState() => ContactsRouteState();
}

class EmployeeDummy {
  String firstName;
  String lastName;
  String vatNumber;

  EmployeeDummy(
      {@required this.firstName,
      @required this.lastName,
      @required this.vatNumber});
}

class ContactsRouteState extends State<ContactsRoute> {
  int _counter = 0;
  final double _appBarHeight = 100.0;
  var isLoading = false;
  List employeeList = [
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
    EmployeeDummy(
        firstName: 'Ηλιάννα',
        lastName: 'Παπαγεωργίου',
        vatNumber: 'l33tf4bul0us'),
  ];

  void _incrementCounter() => setState(() => _counter++);
  void _resetCounter() => setState(() => _counter = 0);

  _showSnackBar(context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Not really',
        onPressed: () => print('Trolled.'),
      ),
    ));
  }

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size(MediaQuery.of(context).size.width, _appBarHeight),
            child: AppBar(
              title: Text('Υπάλληλοι'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  tooltip: 'Αναζήτηση',
                  // SnackBar not working here. Need GlobalKey??
                  onPressed: () =>
                      _showSnackBar(context, 'Trying to search? o.O'),
                )
              ],
            ),
          ),
          // Needed to open a snackbar.
          // This happens because you are using the context of the widget that instantiated Scaffold.
          // Not the context of a child of Scaffold.
          // You can solve this by simply using a different context :
          body: Builder(builder: (context) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          // padding: EdgeInsets.all(8.0),
                          itemCount: employeeList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return InkWell(
                              child: Employee(
                                firstName: employeeList[i].firstName,
                                lastName: employeeList[i].lastName,
                                vatNumber: employeeList[i].vatNumber,
                                // overtimeStart: overtimeStart,
                              ),
                              onTap: () => _showSnackBar(
                                  context, 'Την Ηλιάννα ρε λιγούρη;'),
                            );
                          },
                        ),
                ),
              ],
            );
          }),
          floatingActionButton: FloatingActionButton(
            heroTag: 'ftbBot',
            tooltip: 'Increment',
            child: Icon(Icons.person_add),
            onPressed: _incrementCounter,
          ),
          drawer: ContactsDrawer(),
        ),
        Positioned(
          right: 16.0,
          top: _appBarHeight - 5,
          child: FloatingActionButton(
            heroTag: 'ftbTop',
            tooltip: 'Increment',
            child: Icon(Icons.add, color: Colors.blue),
            mini: true,
            backgroundColor: Colors.white,
            onPressed: _incrementCounter,
          ),
        ),
      ],
    );
  }
}
