import 'package:flutter/material.dart';

class EditDialog extends StatelessWidget {
  final Function onSave;

  const EditDialog({
    Key key,
    @required this.onSave,
  }) : super(key: key);

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
          onPressed: onSave,
          child: Text('ΑΠΟΘΗΚΕΥΣΗ'),
        )
      ],
    );
  }
}
