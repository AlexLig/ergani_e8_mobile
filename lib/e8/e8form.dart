import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/components/employer_list_tile.dart';
import 'package:ergani_e8/components/send_dialog.dart';
import 'package:ergani_e8/components/time_picker.dart';
import 'package:ergani_e8/e8/e8provider.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class E8form extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => E8formState();
}

class E8formState extends State<E8form> {
  double _sliderValue;
  TimeOfDay _overtimeStart;
  TimeOfDay _overtimeFinish;
  Employer _employer = Employer('123456789', 'ΚυρΜπαμπηςΑΕ', '0123456789');
  Employee _employee;
  String _erganiCode;
  bool _isFirstBuild = true;
  bool _isReset = false;
  TextEditingController _receiverController = TextEditingController();
  TextEditingController _senderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sliderValue = 0.5;
    _receiverController.text = '54001';
    _senderController.text = '${_employer.name}';
  }

  // TODO: Implement send SMS. Remove Dialog.
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

  // TODO: fix  pop snackbar if u choose time b4 time.now
  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _overtimeStart,
    );
    if (picked != null && picked != _overtimeStart) {
      if (isLater(TimeOfDay.now(), picked)) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.warning),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Η δήλωση υπερωρίας '),
                    Text('πρέπει να γίνεται ΠΡΙΝ την έναρξη της!'),
                  ],
                ),
              ],
            ),
          ),
        );
      } else
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
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.warning),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Η ώρα λήξης πρέπει να είναι'),
                    Text('μετά την ώρα έναρξης'),
                  ],
                ),
              ],
            ),
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
    // _employer = E8provider.of(context).employer;
    _employee = E8provider.of(context).employee;

    if (_isFirstBuild && !_isReset) {
      // _overtimeStart = _employee.workFinish ?? TimeOfDay(hour: 16, minute: 00);
      _overtimeStart = TimeOfDay.now();
      _overtimeFinish =
          addToTimeOfDay(_overtimeStart, minute: (_sliderValue * 60).toInt());

      _isFirstBuild = false;
    }
    _erganiCode = e8Parser(
      employer: _employer,
      employee: _employee,
      start: _isReset ? TimeOfDay(hour: 00, minute: 00) : _overtimeStart,
      finish: _isReset ? TimeOfDay(hour: 00, minute: 00) : _overtimeFinish,
    );

    return Scaffold(
      body: Builder(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Card(
                margin: EdgeInsets.only(top: 80.0, left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    EmployeeListTile(employee: _employee),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(),
                    ),
                    SwitchListTile(
                      onChanged: (bool newValue) =>
                          setState(() => _isReset = newValue),
                      value: _isReset,
                      // secondary: const Icon(Icons.cancel),
                      title: Text(
                        'Ακύρωση προηγούμενης υποβολής',
                        style: TextStyle(
                          color: _isReset ? Colors.grey[900] : Colors.grey[400],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                            bottom: 50.0,
                            top: 20.0,
                          ),
                          child: TimePickerButton(
                            workStart: _overtimeStart,
                            workFinish: _overtimeFinish,
                            onSelectStartTime: () => _selectStartTime(context),
                            onSelectFinishTime: () =>
                                _selectFinishTime(context),
                            isReset: _isReset,
                          ),
                        ),
                        _buildActiveSlider()
                      ],
                    )
                  ],
                ),
              ),
              _buildMessageBottomSheet(),
            ].where(isNotNull).toList(),
          );
        },
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  // TODO : set context to always use 24hr. Non intl.
  // TODO: Prevent from choosing overtime later than Time.now()
  _buildActiveSlider() {
    var value = (_sliderValue * 2) % 2;
    var sliderValue = value == 0 ? _sliderValue.round() : _sliderValue;

    return Column(
      children: <Widget>[
        Text(
          'Ώρες Υπερωρίας',
          style: TextStyle(
            fontSize: 18.0,
            // color: _isReset ? Colors.blueGrey[100] : Colors.grey[900],
            color: _isReset ? Colors.grey[400] : Colors.grey[900],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Slider(
            divisions: 5,
            min: 0.5,
            max: 3.0,
            label: _sliderValue == 1 || _sliderValue == 1.5
                ? '$sliderValue ώρα'
                : '$sliderValue ώρες',
            value: _sliderValue,
            onChanged: _isReset ? null : (value) => _handleSliderChange(value),
            // inactiveColor: Colors.grey[200],
          ),
        )
      ],
    );
  }

  _buildMessageBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PhysicalModel(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                enabled: false,
                controller: _senderController,
                decoration: InputDecoration(prefixText: 'ΑΠΟ      '),
              ),
              TextField(
                enabled: false,
                controller: _receiverController,
                decoration: InputDecoration(prefixText: 'ΠΡΟΣ    '),
              ),
              ListTile(
                title: Text(_erganiCode),
                leading: Icon(Icons.message),
              ),
              RaisedButton(
                onPressed: () => null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'ΑΠΟΣΤΟΛΗ',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 10.0),
                    Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
