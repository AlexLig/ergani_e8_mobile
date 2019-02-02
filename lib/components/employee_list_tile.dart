import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

enum ContactActions { Edit, Delete }

class EmployeeListTile extends StatelessWidget {
  final Employee employee;
  final Function onDelete, onEdit, onTap;
  final bool isDestination;

  EmployeeListTile({
    Key key,
    @required this.employee,
    this.onDelete,
    this.onEdit,
    this.onTap,
    this.isDestination,
  }) : super(key: key);

  String _getInitials() =>
      _normalize(employee.lastName[0]) + _normalize(employee.firstName[0]);

  String _normalize(String char) {
    final Map<String, String> pairs = {
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
              height: isDestination ? 40.0 : 60.0,
              width: isDestination ? 40.0 : 60.0,
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
                    fontSize: isDestination ? 20.0 : 30.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Align(
          alignment: Alignment.topLeft,
          child: Hero(
              tag: 'herotext${employee.id}',
              child: Material(
                  color: Colors.transparent,
                  child: Text(
                    '${employee.lastName} ${employee.firstName}',
                    style: TextStyle(fontSize: 16),
                  ))),
        ),
        isThreeLine: !isDestination,
        subtitle: !isDestination
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('ΑΦΜ: ${employee.afm}'),
                  Text(
                    'Ωράριο: ${timeToString(employee.workStart)} - ${timeToString(employee.workFinish)}',
                  ),
                ],
              )
            : null,
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
