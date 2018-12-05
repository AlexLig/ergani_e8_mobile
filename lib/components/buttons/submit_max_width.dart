import 'package:flutter/material.dart';

class SubmitButtonMaxWidth extends StatelessWidget {
  final Function onSubmit;

  SubmitButtonMaxWidth({@required this.onSubmit}) : assert(onSubmit != null);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RaisedButton(
        onPressed: onSubmit,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.save, color: Colors.white, size: 22.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'ΑΠΟΘΗΚΕΥΣΗ',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
