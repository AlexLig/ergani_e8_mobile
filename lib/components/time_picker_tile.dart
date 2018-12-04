import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class TimePickerTile extends StatelessWidget {
  final TimeOfDay workStart, workFinish;
  final Function onSelectStartTime, onSelectFinishTime;
  final bool isReset;

  TimePickerTile({
    @required this.workStart,
    @required this.workFinish,
    @required this.isReset,
    @required this.onSelectStartTime,
    @required this.onSelectFinishTime,
  })  : assert(workStart != null),
        assert(workFinish != null),
        assert(onSelectStartTime != null),
        assert(onSelectFinishTime != null);

  @override
  Widget build(BuildContext context) {
    return ListTile(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildButton(
            workHour: isReset ? TimeOfDay(hour: 00, minute: 00) : this.workStart,
            onPressed: isReset ? null : onSelectStartTime,
          ),
          Icon(Icons.arrow_forward,
              color: isReset ? Colors.grey[400] : Colors.black),
          _buildButton(
            workHour: isReset ? TimeOfDay(hour: 00, minute: 00) :this.workFinish,
            onPressed: isReset ? null : onSelectFinishTime,
          ),
        ],
      ),
    );
  }

  _buildButton({
    @required TimeOfDay workHour,
    @required Function onPressed,
  }) {
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
              child: Icon(Icons.alarm,
                  color: isReset ? Colors.grey[400] : Colors.grey[600]),
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
