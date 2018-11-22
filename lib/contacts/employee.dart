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
        onSelected: (ContactActions selection) {
          switch (selection) {
            case ContactActions.edit:
              _handleEdit(context);
              break;
            case ContactActions.delete:
              _handleDelete(context);
              break;
            default:
              print(selection);
          }
        },
        // selection == ContactActions.delete
        //     ? _handleDelete(context)
        //     : print(selection),
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

  Future<void> _handleEdit(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Επεξεργασία Υπαλλήλου'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('This dialog will allow you to edit the employee.'),
                  Text('That\'s nice! '),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ΑΚΥΡΟ'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ΑΠΟΘΗΚΕΥΣΗ'),
              )
            ],
          );
        });
  }

  Future<void> _handleDelete(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Διαγραφή υπαλλήλου;'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Ο υπάλληλος ${this.firstName} ${this.lastName} θα αφαιρεθεί από τη συλλογή.'),
                ],
              ),
            ),
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
