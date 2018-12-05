import 'package:flutter/material.dart';

class AddContactsIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.people, size: 100.0, color: Theme.of(context).primaryColorLight,),
          Text(
            'Προσθέστε υπαλλήλους για να συνεχίσετε.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0,),
          ),
        ],
      ),
    );
  }
}
