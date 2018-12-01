import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

enum ContactActions { edit, delete }

class EmployeeListTile extends StatelessWidget {
  final Employee employee;
  final Function onDelete, onEdit, onTap;

  EmployeeListTile({
    Key key,
    @required this.employee,
    this.onDelete,
    this.onEdit,
    this.onTap,
  }) : super(key: key);

  String _getInitials() {
    return this.employee.lastName[0].toUpperCase() + //TODO: FIX method was called on null (this.employee is null)
        this.employee.firstName[0].toUpperCase();
  }

  final RegExp exp = RegExp(r'[^{0-9}]');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: ListTile(
        leading: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 244, 244, 1.0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${_getInitials()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
                fontSize: 30.0,
              ),
            ),
          ),
        ),
        title: Text('${employee.lastName} ${employee.firstName}'),
        isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('ΑΦΜ: ${employee.afm}'),
            Text(
              'Ωράριο: ${timeToString(employee.workStart)} - ${timeToString(employee.workFinish)}',
            ),
          ],
        ),
        trailing: onDelete != null && onEdit != null
            ? PopupMenuButton<ContactActions>(
                onSelected: (ContactActions selection) {
                  switch (selection) {
                    case ContactActions.edit:
                      this.onEdit();
                      break;
                    case ContactActions.delete:
                      this.onDelete();
                      break;
                    default:
                      print(selection);
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<ContactActions>>[
                      PopupMenuItem<ContactActions>(
                        value: ContactActions.edit,
                        child: Text('Επεξεργασία'),
                      ),
                      PopupMenuItem<ContactActions>(
                        value: ContactActions.delete,
                        child: Text('Διαγραφή'),
                      )
                    ],
              )
            : null,
      ),
    );
  }
}
