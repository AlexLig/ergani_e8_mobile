import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class TimePickerTile extends StatelessWidget {
  final TimeOfDay workStart, workFinish;
  final Function onSelectStartTime, onSelectFinishTime;
  final bool isReset, outlined;

  TimePickerTile({
    @required this.workStart,
    @required this.workFinish,
    @required this.isReset,
    @required this.onSelectStartTime,
    @required this.onSelectFinishTime,
    @required this.outlined,
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
            context,
            workHour:
                isReset ? TimeOfDay(hour: 00, minute: 00) : this.workStart,
            onPressed: isReset ? null : onSelectStartTime,
            outlined: outlined,
          ),
          Icon(Icons.arrow_forward,
              color: isReset ? Colors.grey[400] : Colors.black),
          _buildButton(
            context,
            workHour:
                isReset ? TimeOfDay(hour: 00, minute: 00) : this.workFinish,
            onPressed: isReset ? null : onSelectFinishTime,
            outlined: outlined,
          ),
        ],
      ),
    );
  }

  _buildButton(
    context, {
    @required Function onPressed,
    @required TimeOfDay workHour,
    bool outlined,
  }) {
    return outlined
        ? _buildUnderlinedButton(
            context,
            onPressed: onPressed,
            content: _buildButtonContent(context, workHour: workHour),
          )
        : _buildUnderlinedButton(
            context,
            onPressed: onPressed,
            content: _buildButtonContent(context, workHour: workHour),
          );
  }

  _buildButtonContent(context, {@required TimeOfDay workHour}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          timeToString(workHour ?? TimeOfDay(hour: 00, minute: 00)),
          style: TextStyle(fontSize: 16.0),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          // child: Icon(CupertinoIcons.time,
          child: Icon(Icons.access_time,
              // color: isReset ? Colors.grey[300] : Colors.grey[700]),
              color: isReset
                  ? Colors.grey[300]
                  : Theme.of(context).primaryColorDark),
        ),
      ],
    );
  }

  _buildRoundedButton(context, {@required onPressed, @required content}) {
    return OutlineButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9.0),
        child: content,
      ),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
      onPressed: onPressed,
      // color: Colors.grey[200],
      highlightedBorderColor: Theme.of(context).accentColor,
    );
  }

  _buildUnderlinedButton(context, {@required onPressed, @required content}) {
    return FlatButton(
      shape: UnderlineInputBorder(
        borderSide: BorderSide(
            color: isReset
                // ? Theme.of(context).primaryColorLight
                ? Colors.grey[300]
                : Theme.of(context).primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: content,
      ),
      onPressed: onPressed,
    );
  }
}
