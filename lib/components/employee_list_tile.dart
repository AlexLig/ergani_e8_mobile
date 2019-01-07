import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

enum ContactActions { Edit, Delete }

String normalize(String char) {
  final pairs = {
    'Ά': 'Α',
    'Έ': 'Ε',
    'Ή': 'Η',
    'Ί': 'Ι',
    'Ό': 'Ο',
    'Ύ': 'Υ',
    'Ώ': 'Ω',
    'Ϊ': 'Ι',
    'ΐ': 'I',
    'Ϋ': 'Υ',
    'ΰ': 'Υ',
  };
  final upper = char.toUpperCase();
  return pairs.containsKey(upper) ? pairs[upper] : upper;
}

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

  String _getInitials() =>
      normalize(employee.lastName[0]) + normalize(employee.firstName[0]);

  final RegExp exp = RegExp(r'[^{0-9}]');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Hero(
          tag: 'heroEmployee${employee.id}',
          child: Material(
            color: Colors.transparent,
            child: Container(
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
                icon: Icon(
                  Icons.more_vert,
                  size: 28.0,
                ),
                tooltip: 'Επιλογές',
                onSelected: (ContactActions selection) {
                  switch (selection) {
                    case ContactActions.Edit:
                      this.onEdit();
                      break;
                    case ContactActions.Delete:
                      this.onDelete();
                      break;
                    default:
                      print(selection);
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<ContactActions>>[
                      PopupMenuItem<ContactActions>(
                        value: ContactActions.Edit,
                        child: Text('Επεξεργασία'),
                      ),
                      PopupMenuItem<ContactActions>(
                        value: ContactActions.Delete,
                        child: Text('Διαγραφή'),
                      )
                    ],
              )
            : null,
      ),
    );
  }
}
