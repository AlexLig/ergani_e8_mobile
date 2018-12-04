import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/components/message_bottom_sheet.dart';
import 'package:ergani_e8/components/time_picker_tile.dart';
import 'package:ergani_e8/e8/e8provider.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:ergani_e8/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class E8form extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => E8formState();
}

class E8formState extends State<E8form> {
  ErganiDatabase _erganiDatabase = ErganiDatabase();
  Employer _employer;
  Employee _employee;

  double _sliderValue;
  TimeOfDay _overtimeStart;
  TimeOfDay _overtimeFinish;
  String _erganiCode;
  bool _isFirstBuild = true;
  bool _isReset = false;
  TextEditingController _smsNumberController = TextEditingController();
  TextEditingController _senderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sliderValue = 0.5;
    _updateEmployer();
    _smsNumberController.text = _employer?.smsNumber;
    _senderController.text = _employer?.name;
  }

  void _updateEmployer() async {
    final Employer employer = await _erganiDatabase.getNewestEmployer();

    setState(() {
      _employer = employer;
    });
  }

  // TODO: Implement send SMS. Remove Dialog.
  _handleSend(scaffoldContext) async {
    if (_employer != null) {
      SmsSender sender = SmsSender();
      String address = _employer.smsNumber;
      SmsMessage message = SmsMessage(address, _erganiCode);
      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          _sendingSmsSnackBar(scaffoldContext, 'Αποστολή μηνύματος...');
        } else if (state == SmsMessageState.Delivered) {
          _sucessSmsSnackBar(
              scaffoldContext, 'Το μήνυμα παραδόθηκε με επιτυχία');
        } else if (state == SmsMessageState.Fail) {
          _warningSmsSnackBar(scaffoldContext, 'Αποτυχία αποστολής μηνύματος');
        }
      });
      sender.sendSms(message);
    } else {
      _warningSmsSnackBar(
          scaffoldContext, 'Κάτι δεν πήγε καλά. Ξαναπροσπαθήστε');
    }
  }

  void _sendingSmsSnackBar(scaffoldContext, String message) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(message),
            ]),
      ),
    );
  }

  void _sucessSmsSnackBar(scaffoldContext, String message) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.check),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(message),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _warningSmsSnackBar(scaffoldContext, String message) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
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
                Text(message),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
                    Text('Η δήλωση υπερωρίας γίνεται μόνο '),
                    Text('πριν την έναρξη της.'),
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
                    Text('Η ώρα λήξης δεν μπορεί να είναι'),
                    Text('πριν την ώρα έναρξης'),
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
          return DecoratedBox(
            decoration: BoxDecoration(
              // color: Theme.of(context).accentColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor,
                  // Theme.of(context).primaryColorDark,
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      _buildCard(),
                    ],
                  ),
                ),
                Column(
                  children: [
                    MessageBottomSheet(
                      handleSend: () => _handleSend(context),
                      message: _erganiCode,
                      senderController: _senderController,
                      smsNumberController: _smsNumberController,
                    ),
                  ],
                ),
              ].where(isNotNull).toList(),
            ),
          );
        },
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  _buildCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 1.0,
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            EmployeeListTile(employee: _employee),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(),
            ),
            SwitchListTile(
              onChanged: (bool newValue) => setState(() => _isReset = newValue),
              value: _isReset,
              // secondary: const Icon(Icons.cancel),
              title: Text(
                'Ακύρωση προηγούμενης υποβολής',
                style: TextStyle(
                  color: _isReset ? Colors.grey[900] : Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TimePickerTile(
              workStart: _overtimeStart,
              workFinish: _overtimeFinish,
              onSelectStartTime: () => _selectStartTime(context),
              onSelectFinishTime: () => _selectFinishTime(context),
              isReset: _isReset,
            ),
            _buildActiveSlider()
          ],
        ),
      ),
    );
  }

  // TODO : set context to always use 24hr. Non intl.
  // TODO: Prevent from choosing overtime later than Time.now()
  _buildActiveSlider() {
    var value = (_sliderValue * 2) % 2;
    var sliderValue = value == 0 ? _sliderValue.round() : _sliderValue;

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            'Ώρες Υπερωρίας',
            style: TextStyle(
              fontSize: 18.0,
              // color: _isReset ? Colors.blueGrey[100] : Colors.grey[900],
              color: _isReset ? Colors.grey[400] : Colors.grey[900],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Slider(
              divisions: 5,
              min: 0.5,
              max: 3.0,
              label: _sliderValue == 1 || _sliderValue == 1.5
                  ? '$sliderValue ώρα'
                  : '$sliderValue ώρες',
              value: _sliderValue,
              onChanged:
                  _isReset ? null : (value) => _handleSliderChange(value),
              // inactiveColor: Colors.grey[200],
            ),
          ),
        )
      ],
    );
  }
}
