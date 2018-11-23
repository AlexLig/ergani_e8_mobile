import 'package:flutter/material.dart';
import 'dart:async';

class VatNumbers {
  String afmEmployer;
  String ameEmployer;
  String afmEmployee;

  VatNumbers({
    @required this.afmEmployee,
    @required this.afmEmployer,
    this.ameEmployer,
  });
}

class E8form extends StatefulWidget {
  final VatNumbers vatNumbers;
  final TimeOfDay commonFinishHour;
  E8form({Key key, @required this.vatNumbers, this.commonFinishHour})
      : super(key: key);

  @override
  E8formState createState() => E8formState();
}

class E8formState extends State<E8form> {
  double _sliderValue;
  TimeOfDay _overtimeStart;
  TimeOfDay _overtimeFinish;

  Widget _buildEmployee(BuildContext context) => ListTile(
        title: Text('Κωστας Γουστουριδης'),
        subtitle: Text('ΑΦΜ: ${widget.vatNumbers.afmEmployer}'),
      );
  Widget _buildEmployer(BuildContext context) => ListTile(
        title: Text('AGFA Αθήνα'),
        subtitle: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text('ΑΦΜ: ${widget.vatNumbers.afmEmployer}'),
            ),
            _child
          ],
        ),
      );
  Widget _child;
  Widget _buildOverTimePicker(BuildContext context) {
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
              onPressed: () => _selectStartTime(context),
            ),
            Icon(Icons.arrow_forward),
            FlatButton(
              child: Text(_overtimeFinish.format(context)),
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
      }
      setState(() {
        _overtimeFinish = picked;
      });
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
  void initState() {
    _sliderValue = 0.5;
    _overtimeStart = widget.commonFinishHour == null
        ? TimeOfDay(hour: 16, minute: 00)
        : widget.commonFinishHour;
    _overtimeFinish =
        addToTimeOfDay(_overtimeStart, minute: (_sliderValue * 60).toInt());
    _child = widget.vatNumbers.ameEmployer != null
        ? Text('ΑΜΕ: ${widget.vatNumbers.ameEmployer}')
        : Container();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) => Column(
              children: <Widget>[
                _buildEmployer(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          _buildEmployee(context),
                          Divider(),
                          _buildOverTimePicker(context),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
      ),
    );
  }
}

// BUG when exceeding 24 hours
TimeOfDay addToTimeOfDay(TimeOfDay timeOfDay, {int hour = 0, int minute = 0}) {
  int newMins = (minute + timeOfDay.minute) % 60;
  int addedHours = (minute + timeOfDay.minute) ~/ 60;
  int tempAddedHours = hour + addedHours + timeOfDay.hour;
  int newHours;
  if (tempAddedHours ~/ 24 > 0) {
    newHours = tempAddedHours ~/ 24;
  } else {
    newHours = tempAddedHours;
  }
  return TimeOfDay(hour: newHours, minute: newMins);
}

// checks if timeA is later that timeB
bool isLater(TimeOfDay timeA, TimeOfDay timeB) {
  int hourA = timeA.hour;
  int hourB = timeB.hour;
  int minutesA = timeA.minute;
  int minutesB = timeB.minute;

  return hourA > hourB || (hourA == hourB && minutesA > minutesB);
}
