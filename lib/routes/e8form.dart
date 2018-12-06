import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/components/message_bottom_sheet.dart';
import 'package:ergani_e8/components/time_picker_tile.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class E8form extends StatefulWidget {
  final Employee employee;
  final Employer employer;

  E8form({Key key, @required this.employer, @required this.employee})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => E8formState();
}

class E8formState extends State<E8form> {
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

  bool _isLoading = false;
  BuildContext _scaffoldContext;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
    _employer = widget.employer;
    _sliderValue = 0.5;
    _smsNumberController.text = _employer.smsNumber;
    _senderController.text = _employer.name;
  }

  TimeOfDay _roundedTimeOfDayNow() {
    final remainder = TimeOfDay.now().minute.remainder(10);
    return addToTimeOfDay(
      TimeOfDay.now(),
      minute: remainder == 0
          ? 5
          : 10 - remainder < 5
              ? 10 - remainder + 5
              : 10 - remainder, // Add 5 up to 9 mins.
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstBuild && !_isReset) {
      if (_employee.workFinish == null ||
          isLater(TimeOfDay.now(), _employee.workFinish))
        _overtimeStart = _roundedTimeOfDayNow();
      else
        _overtimeStart = _employee.workFinish;

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
      appBar: AppBar(
        title: Text('Έντυπο Ε8'),
      ),
      body: Builder(
        builder: (context) {
          _scaffoldContext = context;
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[_buildCard()],
                  ),
                ),
                Column(
                  children: [
                    // Row(
                    //   children: <Widget>[
                    //     FlatButton(
                    //       child: Text('LOAD'),
                    //       onPressed: () => setState(() => _isLoading = true),
                    //     ),
                    //     FlatButton(
                    //       child: Text('DONT LOAD'),
                    //       onPressed: () => setState(() => _isLoading = false),
                    //     ),
                    //   ],
                    // ),
                    MessageBottomSheet(
                      onSend: () => _handleSend(context),
                      message: _erganiCode,
                      senderController: _senderController,
                      smsNumberController: _smsNumberController,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  _buildCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Card(
        // color: Colors.grey[200],
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          children: [
            EmployeeListTile(employee: _employee),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            SwitchListTile(
              onChanged: (bool newValue) => setState(() => _isReset = newValue),
              value: _isReset,
              dense: true,
              subtitle: Text(
                'Μηδενικές ώρες υπερωρίας',
                style: TextStyle(
                  color: _isReset ? Colors.grey[700] : Colors.grey[400],
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.start,
              ),
              title: Text(
                'Ακύρωση Προηγούμενης Υποβολής',
                style: TextStyle(
                  color: _isReset ? Colors.grey[900] : Colors.grey[400],
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            ListTile(
              title: Text(
                'Ώρες Υπερωρίας',
                style: TextStyle(
                  fontSize: 18.0,
                  color: _isReset ? Colors.grey[400] : Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TimePickerTile(
                workStart: _overtimeStart,
                workFinish: _overtimeFinish,
                onSelectStartTime: () => _selectStartTime(context),
                onSelectFinishTime: () => _selectFinishTime(context),
                isReset: _isReset,
                outlined: true,
              ),
            ),
            _buildActiveSlider()
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
        Scaffold.of(_scaffoldContext).showSnackBar(
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
        Scaffold.of(_scaffoldContext).showSnackBar(
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
                    Text('Η λήξη υπερωρίας δεν μπορεί να είναι'),
                    Text('πριν την έναρξή της.'),
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

  // TODO : set context to always use 24hr. Non intl.
  // TODO: Prevent from choosing overtime later than Time.now()
  _buildActiveSlider() {
    var value = (_sliderValue * 2) % 2;
    var sliderValue = value == 0 ? _sliderValue.round() : _sliderValue;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
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

  void _handleSliderChange(newSliderValue) {
    setState(() {
      _sliderValue = newSliderValue;
      _overtimeFinish =
          addToTimeOfDay(_overtimeStart, minute: (_sliderValue * 60).toInt());
    });
  }

  // TODO: Implement send SMS. Remove Dialog.
  _handleSend(scaffoldContext) async {
    if (_employer != null) {
      SmsSender sender = SmsSender();
      String address = _employer.smsNumber;
      SmsMessage message = SmsMessage(address, _erganiCode);
      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Delivered) {
          _sucessSmsSnackBar(
              scaffoldContext, 'Το μήνυμα παραδόθηκε με επιτυχία');
          setState(() => _isLoading = false);
          print('DELIVERY SUCESS');
        } else if (state == SmsMessageState.Fail) {
          _warningSmsSnackBar(scaffoldContext, 'Αποτυχία αποστολής μηνύματος');
          setState(() => _isLoading = false);
        }
      });
      sender.sendSms(message);
      setState(() => _isLoading = true);
    } else {
      _warningSmsSnackBar(
          scaffoldContext, 'Κάτι δεν πήγε καλά. Ξαναπροσπαθήστε');
      setState(() => _isLoading = false);
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
        duration: Duration(seconds: 2),
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
}
