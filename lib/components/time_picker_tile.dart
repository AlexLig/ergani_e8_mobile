import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class TimePickerTile extends StatelessWidget {
  final TimeOfDay workStart, workFinish;
  final dynamic onSelectStartTime, onSelectFinishTime;
  final bool isReset, outlined;

  TimePickerTile({
    @required this.workStart,
    @required this.workFinish,
    @required this.isReset,
    @required this.onSelectStartTime,
    @required this.onSelectFinishTime,
    @required this.outlined,
  })  : assert(workStart != null),
        assert(workFinish != null);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildButton(
            context,
            workHour:
                isReset ? TimeOfDay(hour: 00, minute: 00) : this.workStart,
            onPressed: isReset ? null : onSelectStartTime,
          ),
          Icon(Icons.arrow_forward,
              color: isReset ? Colors.grey[400] : Colors.black),
          _buildButton(
            context,
            workHour:
                isReset ? TimeOfDay(hour: 00, minute: 00) : this.workFinish,
            onPressed: isReset ? null : onSelectFinishTime,
          ),
        ],
      ),
    );
  }

  _buildButton(
    context, {
    @required Function onPressed,
    @required TimeOfDay workHour,
  }) {
    return _buildUnderlinedButton(
      context,
      onPressed: onPressed,
      workHour: workHour,
    );
  }

  _buildUnderlinedButton(
    context, {
    @required onPressed,
    @required TimeOfDay workHour,
  }) {
    return FlatButton(
      shape: UnderlineInputBorder(
        borderSide: BorderSide(
            color: isReset ? Colors.grey[300] : Theme.of(context).primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              timeToString(workHour ?? TimeOfDay(hour: 00, minute: 00)),
              style: TextStyle(fontSize: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(
                Icons.access_time,
                color: isReset || onPressed == null
                    ? Colors.grey[300]
                    : Theme.of(context).primaryColorDark,
              ),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
