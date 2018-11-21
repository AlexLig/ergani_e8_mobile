import 'package:flutter/material.dart';

enum ContactActions { edit, delete }

class Employee extends StatelessWidget {
  @override
  Widget build(BuildContext build) {
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
            'ΚΓ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
              fontSize: 24.0,
            ),
          ),
        ),
      ),
      title: Text('Κώστας Γουστουρίδης'),
      subtitle: Text('ΑΦΜ: 123456789'),
      trailing: PopupMenuButton<ContactActions>(
        onSelected: (ContactActions selection) => print(selection),
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
