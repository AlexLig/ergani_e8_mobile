import 'package:flutter/material.dart';

enum ContactActions { edit, delete }

class Employee extends StatelessWidget {
  String firstName;
  String lastName;
  String vatNumber;
  Function onDelete;
  Function onEdit;

  Employee({
    Key key,
    @required this.firstName,
    @required this.lastName,
    @required this.vatNumber,
    @required this.onDelete,
    @required this.onEdit,
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
            '${this.firstName[0].toUpperCase()}${this.lastName[0].toUpperCase()}',
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
              this.onEdit();
              break;
            case ContactActions.delete:
              this.onDelete();
              break;
            default:
              print(selection);
          }
        },
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
}
