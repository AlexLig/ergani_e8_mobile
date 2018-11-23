import 'package:flutter/material.dart';

class AddContactsIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            // dense: true,
            title: Text(
              'Προσθέστε υπαλλήλους.',
              textAlign: TextAlign.center,
            ),
            trailing: Icon(Icons.arrow_upward),
          ),
        ),
      ],
    );
  }
}
