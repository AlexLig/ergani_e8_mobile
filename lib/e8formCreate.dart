import 'package:ergani_e8/contacts/employee.dart';
import 'package:ergani_e8/contacts/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:ergani_e8/vatNumbers.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class E8form extends StatefulWidget {
  final Employer employer;
  final Employee employee;
  E8form({Key key, @required this.employer, this.employee}) : super(key: key);

  @override
  E8formState createState() => E8formState();
}

class E8formState extends State<E8form> {
  Employer _employer;
  Employee _employee;
  double _sliderValue;
  TimeOfDay _overtimeStart;
  TimeOfDay _overtimeFinish;
  Widget _ameTextChild;

  @override
  void initState() {
    _sliderValue = 0.5;
    _employer = widget.employer;
    _employee = widget.employee;
    _overtimeStart = _employee.hourToStart == null
        ? TimeOfDay(hour: 16, minute: 00)
        : _employee.hourToStart;
    _overtimeFinish =
        addToTimeOfDay(_overtimeStart, minute: (_sliderValue * 60).toInt());
    _ameTextChild = _employer.vatNumberAME == null
        ? Container()
        : Text('ΑΜΕ: ${_employer.vatNumberAME}');

    super.initState();
  }

  Widget _buildEmployee(BuildContext context) => ListTile(
        title: Text('${_employee.lastName} ${_employee.firstName}'),
        subtitle: Text('ΑΦΜ: ${_employee.vatNumber}'),
      );
  Widget _buildEmployer(BuildContext context) => ListTile(
        title: Text(_employer.name),
        subtitle: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text('ΑΦΜ: ${_employer.vatNumberAFM}'),
            ),
            _ameTextChild
          ],
        ),
      );

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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message), onPressed: () => print('hi')),
      appBar: AppBar(
        title: Text('Νέα υποβολή'),
      ),
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
