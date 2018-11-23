import 'package:ergani_e8/contacts/employee.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final Employee employee;

  const DeleteDialog({Key key, this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Διαγραφή υπαλλήλου;'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Ο/Η ${this.employee.lastName} ${this.employee.firstName} θα διαγραφεί από τη συλλογή.',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'ΑΚΥΡΟ',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context, this.employee),
          child: Text(
            'ΔΙΑΓΡΑΦΗ',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }
}
