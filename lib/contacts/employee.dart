import 'package:flutter/material.dart';

enum ContactActions { edit, delete }

class EmployeeListTile extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String vatNumber;
  final Function onDelete;
  final Function onEdit;
  final Function onTap;

  EmployeeListTile({
    Key key,
    @required this.firstName,
    @required this.lastName,
    @required this.vatNumber,
    @required this.onDelete,
    @required this.onEdit,
    @required this.onTap,
    overtimeStart,
  }) : super(key: key);

  String _getInitials() {
    return this.lastName[0].toUpperCase() + this.firstName[0].toUpperCase();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: ListTile(
        leading: Container(
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 244, 244, 1.0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${_getInitials()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        title: Text('$lastName $firstName'),
        subtitle: Text('ΑΦΜ: $vatNumber'),
        trailing: PopupMenuButton<ContactActions>(
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
        ),
      ),
    );
  }
}
