import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final Employee employee;

  const DeleteDialog({Key key, @required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Διαγραφή υπαλλήλου;'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Align(alignment: Alignment.topLeft,child: EmployeeListTile(employee: employee, isDestination: true,)),
            Text(
              'Ο/Η ${this.employee.lastName} ${this.employee.firstName} θα διαγραφεί από τη συλλογή.',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('ΑΚΥΡΟ'),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context, this.employee),
          child: Text('ΔΙΑΓΡΑΦΗ'),
        ),
      ],
    );
  }
}
