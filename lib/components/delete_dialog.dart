import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String firstName;
  final String lastName;
  final Function onDelete;

  const DeleteDialog({
    @required this.firstName,
    @required this.lastName,
    @required this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Διαγραφή υπαλλήλου;'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Ο/Η $lastName $firstName θα διαγραφεί από τη συλλογή.'),
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
          onPressed: onDelete,
          child: Text(
            'ΔΙΑΓΡΑΦΗ',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }
}
