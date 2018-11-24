import 'package:ergani_e8/models/employee.dart';
import 'package:flutter/material.dart';

class EditDialog extends StatelessWidget {
  final Employee employee;

  const EditDialog({Key key, @required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.pop(context, this.employee),
          child: Text('ΑΠΟΘΗΚΕΥΣΗ'),
        )
      ],
    );
  }
}
