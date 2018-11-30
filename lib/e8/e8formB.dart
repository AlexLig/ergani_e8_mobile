import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/components/employer_list_tile.dart';
import 'package:ergani_e8/components/send_dialog.dart';
import 'package:ergani_e8/components/time_picker.dart';
import 'package:ergani_e8/e8/e8provider.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class E8formB extends StatefulWidget {
  final bool isReset;

  E8formB({@required this.isReset});
  @override
  State<StatefulWidget> createState() => E8formBState();
}

class E8formBState extends State<E8formB> {
  double _sliderValue;
  TimeOfDay _overtimeStart;
  TimeOfDay _overtimeFinish;
  Employer _employer = Employer('123456789', 'ΚυρΜπαμπηςΑΕ');
  Employee _employee;
  String _erganiCode;
  bool _isFirstBuild = true;
  bool _isReset;

  @override
  void initState() {
    super.initState();
    _sliderValue = 0.5;
    _isReset = widget.isReset;
    if (_isReset) {
      _overtimeStart = TimeOfDay(hour: 00, minute: 00);
      _overtimeFinish = TimeOfDay(hour: 00, minute: 00);
    }
  }

  _handleSend(
      {scaffoldContext, String message, @required String number}) async {
    final shouldSend = await showDialog(
      context: scaffoldContext,
      barrierDismissible: true,
      builder: (context) => SendDialog(
            isReset: _isReset,
            erganiCode: message,
            number: number,
          ),
    );
    if (shouldSend == true) sendSms(message: message, number: number);
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
            content: Text('Η ώρα λήξης πρέπει να είναι αργότερα της έναρξης.'),
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

  _buildActiveSlider() {
    var value = (_sliderValue * 2) % 2;
    var sliderValue = value == 0 ? _sliderValue.round() : _sliderValue;

    return Column(
      children: <Widget>[
        Text(
          'Ώρες υπερεργασίας',
          style: TextStyle(fontSize: 18.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TimePickerButton(
              onPressed: () => _selectStartTime(context),
              workHour: _overtimeStart,
            ),
            Icon(Icons.arrow_forward),
            TimePickerButton(
              onPressed: () => _selectFinishTime(context),
              workHour: _overtimeFinish,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Slider(
            divisions: 5,
            min: 0.5,
            max: 3.0,
            // label: '$_sliderValue  ώρες',
            label: _sliderValue == 1 || _sliderValue == 1.5
                ? '$sliderValue ώρα'
                : '$sliderValue ώρες',
            value: _sliderValue,
            onChanged: (newSliderValue) {
              _handleSliderChange(newSliderValue);
            },
          ),
        )
      ],
    );
  }

  _buildInactiveSlider() {
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
              child: Text(_overtimeStart.format(context)),
              onPressed: () {},
            ),
            Icon(Icons.arrow_forward),
            FlatButton(
              child: Text(_overtimeFinish.format(context)),
              onPressed: () {},
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Slider(
            divisions: 5,
            min: 0.5,
            max: 3.0,
            label: null,
            value: _sliderValue,
            onChanged: (val) {},
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // _employer = E8provider.of(context).employer;
    _employee = E8provider.of(context).employee;

    if (_isFirstBuild && !_isReset) {
      _overtimeStart = _employee.workStart == null
          ? TimeOfDay(hour: 16, minute: 00)
          : _employee.workStart;
      _overtimeFinish =
          addToTimeOfDay(_overtimeStart, minute: (_sliderValue * 60).toInt());

      _isFirstBuild = false;
    }
    _erganiCode = e8Parser(
        employer: _employer,
        employee: _employee,
        start: _overtimeStart,
        finish: _overtimeFinish);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isReset ? Colors.orange : Colors.blue,
        child: Icon(Icons.textsms),
        onPressed: () => _handleSend(
            scaffoldContext: context, message: _erganiCode, number: "5400"),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            children: <Widget>[
              EmployerListTile(employer: _employer),
              EmployeeListTile(employee: _employee),
              _isReset ? null : _buildActiveSlider(),
              Text(_erganiCode)
            ].where(isNotNull).toList(),
          );
        },
      ),
    );
  }
}
