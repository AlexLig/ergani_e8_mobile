import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();
  double _sliderValue;
  TimeOfDay _overtimeStart;
  TimeOfDay _overtimeFinish;

  Widget _buildEmployee() => ListTile(
        title: Text('Κωστας Γουστουριδης'),
        subtitle: Text('ΑΦΜ: ${widget.vatNumbers.afmEmployer}'),
      );
  Widget _buildEmployer() => ListTile(
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
  Widget _buildOverTimePicker() {
    return Column(
      children: <Widget>[
        Text(
          'Ώρες υπερεργασίας',
          style: TextStyle(fontSize: 18.0),
        ),
        Row(
          children: <Widget>[
            FlatButton(
              // TODO : set context to alwaysUse24HourFormat
              child: Text(_overtimeStart.format(context)),
              onPressed: () => print('My name is Alex whats yours?'),
            ),
            Icon(Icons.arrow_forward),
            FlatButton(
              child: Text(_overtimeFinish.format(context)),
              onPressed: () => print('My name is Kostas. Whats yours?'),
            )
          ],
        ),
        Slider(
          divisions: 6,
          min: 0,
          max: 3,
          label: '$_sliderValue  ώρες',
          value: _sliderValue,
          onChanged: (newValue) {
            setState(() => _sliderValue = newValue);
          },
        )
      ],
    );
  }

  @override
  void initState() {
    _overtimeStart = widget.commonFinishHour == null
        ? TimeOfDay(hour: 16, minute: 00)
        : widget.commonFinishHour;
    _overtimeFinish = addToTimeOfDay(_overtimeStart, minute: 90, hour: 9);
    _child = widget.vatNumbers.ameEmployer != null
        ? Text('ΑΜΕ: ${widget.vatNumbers.ameEmployer}')
        : Container();
    _sliderValue = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          _buildEmployer(),
          Divider(height: 16.0),
          _buildEmployee(),
          _buildOverTimePicker()
        ],
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
