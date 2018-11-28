import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class TimePickerButton extends StatelessWidget {
  final TimeOfDay workHour;
  final Function onPressed;
  TimePickerButton({@required this.workHour, @required this.onPressed})
      : assert(workHour != null),
        assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              timeToString(workHour ?? TimeOfDay(hour: 00, minute: 00)),
              style: TextStyle(fontSize: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(Icons.alarm, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      borderSide: BorderSide(
        color: Colors.grey[400],
      ),
      onPressed: onPressed,
    );
  }
}
