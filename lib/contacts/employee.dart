import 'package:flutter/material.dart';

enum ContactActions { edit, delete }

class Employee extends StatelessWidget {
  String firstName;
  String lastName;
  String vatNumber;

  Employee({
    Key key,
    @required this.firstName,
    @required this.lastName,
    @required this.vatNumber,
    overtimeStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(244, 244, 244, 1.0),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Center(
          child: Text(
            '${this.firstName[0]}${this.lastName[0]}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
              fontSize: 24.0,
            ),
          ),
        ),
      ),
      title: Text('$firstName $lastName'),
      subtitle: Text('ΑΦΜ: $vatNumber'),
      trailing: PopupMenuButton<ContactActions>(
        onSelected: (ContactActions selection) =>
            selection == ContactActions.delete ? _alert(context) : print(selection),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<ContactActions>>[
              PopupMenuItem<ContactActions>(
                value: ContactActions.edit,
                child: Text('Επεξεργασία'),
              ),
              PopupMenuItem<ContactActions>(
                value: ContactActions.delete,
                child: Text('Διαγραφή'),
              )
            ],
      ),
    );
  }

  Future<void> _alert(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Διαγραφή υπαλλήλου;'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'ΑΚΥΡΟ',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'ΔΙΑΓΡΑΦΗ',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          );
        });
  }
}
