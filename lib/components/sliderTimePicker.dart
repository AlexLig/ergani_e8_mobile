import 'package:ergani_e8/e8/e8provider.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class SliderTimePicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SliderTimePickerState();
}

class SliderTimePickerState extends State<SliderTimePicker> {
  double _sliderValue;
  TimeOfDay _overtimeStart;
  TimeOfDay _overtimeFinish;
  Employee _employee;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _sliderValue = 0.5;
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _overtimeStart,
    );
    if (picked != null && picked != _overtimeStart) {
      setState(() {
        _overtimeStart = picked;
        _overtimeFinish = addToTimeOfDay(
          _overtimeStart,
          minute: (_sliderValue * 60).toInt(),
        );
      });
    }
  }

  Future<Null> _selectFinishTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _overtimeFinish,
    );
    if (picked != null && picked != _overtimeFinish) {
      if (!isLater(picked, _overtimeStart)) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Η ώρα λήξης πρέπει να είναι μεγαλύτερη.'),
          ),
        );
      } else
        setState(() => _overtimeFinish = picked);
    }
  }

  void _handleSliderChange(newSliderValue) {
    setState(() {
      _sliderValue = newSliderValue;
      _overtimeFinish =
          addToTimeOfDay(_overtimeStart, minute: (_sliderValue * 60).toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstBuild) {
      _employee = E8provider.of(context).employee;
      _overtimeStart = _employee.workStart == null
          ? TimeOfDay(hour: 16, minute: 00)
          : _employee.workStart;
      _overtimeFinish =
          addToTimeOfDay(_overtimeStart, minute: (_sliderValue * 60).toInt());

      _isFirstBuild = false;
    }

    return Column(
      children: <Widget>[
        Text(
          'Ώρες υπερεργασίας',
          style: TextStyle(fontSize: 18.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              // TODO : set context to alwaysUse24HourFormat
              child: Text(timeToString(_overtimeStart)),
              onPressed: () => _selectStartTime(context),
            ),
            Icon(Icons.arrow_forward),
            FlatButton(
              child: Text(timeToString(_overtimeFinish)),
              onPressed: () => _selectFinishTime(context),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Slider(
            divisions: 5,
            min: 0.5,
            max: 3.0,
            label: '$_sliderValue  ώρες',
            value: _sliderValue,
            onChanged: (newSliderValue) {
              _handleSliderChange(newSliderValue);
            },
          ),
        )
      ],
    );
  }
}
