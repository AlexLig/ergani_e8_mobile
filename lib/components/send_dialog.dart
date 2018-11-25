import 'package:flutter/material.dart';

class SendDialog extends StatelessWidget {
  final String erganiCode;
  final String number;

  final bool isReset;

  const SendDialog(
      {Key key, this.erganiCode, @required this.number, @required this.isReset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Αποστολή μηνύματος;'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Το παρακάτω μήνυμα θα σταλεί στον αριθμό $number.\n',
            ),
            Text(
              '${erganiCode != null ? erganiCode : ''}',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'ΑΚΥΡΟ',
            style: TextStyle(color: isReset ? Colors.orange : Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(0.0),
          child: RaisedButton(
            color: isReset ? Colors.orange : Colors.blue,
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'ΑΠΟΣΤΟΛΗ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
