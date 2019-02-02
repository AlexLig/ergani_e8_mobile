import 'package:ergani_e8/components/employee_list_tile.dart';
import 'package:ergani_e8/components/message_bottom_sheet.dart';
import 'package:ergani_e8/components/time_picker_tile.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

import '../components/showSnackbar.dart';

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

  bool _canSendSms;
  bool _isLoading = false;
  BuildContext _scaffoldContext;

  bool _triggered = false;
  bool _shouldShrink = true;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
    _employer = widget.employer;
    _sliderValue = 0.5;
    _smsNumberController.text = _employer.smsNumber;
    _senderController.text = _employer.name;
    _canSendSms = !isLater(
        TimeOfDay.now(), addToTimeOfDay(_employee.workFinish, hour: 3));
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
          isLater(TimeOfDay.now(), _employee.workFinish) &&
              !isLater(
                TimeOfDay.now(),
                addToTimeOfDay(_employee.workFinish, hour: 3),
              ))
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
      floatingActionButton: FloatingActionButton.extended(
        icon: _isLoading
            ? Container(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(),
              )
            : Icon(Icons.send),
        label: Text("ΑΠΟΣΤΟΛΗ"),
        onPressed: _isLoading || !_canSendSms ? null : _handleSend,
        backgroundColor: _isLoading || !_canSendSms ? Colors.grey[300] : null,
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
                    children: <Widget>[
                      _buildE8Settings(),
                    ],
                  ),
                ),
                // Column(
                //   children: [
                //     // Row(
                //     //   children: <Widget>[
                //     //     FlatButton(
                //     //       child: Text('LOAD'),
                //     //       onPressed: () => setState(() => _isLoading = true),
                //     //     ),
                //     //     FlatButton(
                //     //       child: Text('DONT LOAD'),
                //     //       onPressed: () => setState(() => _isLoading = false),
                //     //     ),
                //     //   ],
                //     // ),
                //     Padding(
                //       padding: const EdgeInsets.only(bottom: 2.0),
                //       child: MessageBottomSheet(
                //         onSend: _canSendSms ? () => _handleSend(context) : null,
                //         message: _erganiCode,
                //         senderController: _senderController,
                //         smsNumberController: _smsNumberController,
                //         isLoading: _isLoading,
                //       ),
                //     ),
                //   ].where((val) => val != null).toList(),
                // ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  _buildE8Settings() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          EmployeeListTile(
            employee: _employee,
            isDestination: _shouldShrink,
            onTap: () => setState(() => _shouldShrink = !_shouldShrink),
          ),
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
          _buildActiveSlider(),
          _canSendSms
              ? ListTile(
                  title: Text(_erganiCode),
                  leading: Icon(Icons.chat),
                )
              : ListTile(
                  leading: Icon(Icons.warning, color: Colors.deepOrange),
                  title: Text(
                    'Η δήλωση υπερωρίας γίνεται μόνο πριν την έναρξή της.',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ),
          Container(
            height: 80,
          )
        ],
      ),
    );
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final sliderValue = (_sliderValue * 60).toInt();
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _overtimeStart,
    );
    if (picked != null && picked != _overtimeStart) {
      if (isLater(TimeOfDay.now(), picked))
        showSnackbar(
          scaffoldContext: _scaffoldContext,
          type: SnackbarType.Warning,
          message: 'Η δήλωση υπερωρίας γίνεται μόνο πριν την έναρξη της.',
        );
      else if (isLater(
        addToTimeOfDay(picked, minute: sliderValue),
        addToTimeOfDay(_employee.workFinish, hour: 3),
      ))
        showSnackbar(
          scaffoldContext: _scaffoldContext,
          type: SnackbarType.Warning,
          message: 'Η νόμιμη διάρκεια υπερωρίας είναι 3 ώρες.',
        );
      else {
        setState(() {
          _overtimeStart = picked;
          _overtimeFinish = addToTimeOfDay(_overtimeStart, minute: sliderValue);
        });
      }
    }
  }

  Future<Null> _selectFinishTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _overtimeFinish,
    );
    if (picked != null && picked != _overtimeFinish) {
      if (!isLater(picked, _overtimeStart))
        showSnackbar(
          scaffoldContext: _scaffoldContext,
          type: SnackbarType.Warning,
          message:
              'Η λήξη της υπερωρίας δεν μπορεί να είναι πριν από την ώρα έναρξης.',
        );
      /*   else if ((timeToMinutes(picked) - timeToMinutes(_overtimeStart)) % 30 !=
          0) {
        showSnackbar(
          scaffoldContext: _scaffoldContext,
          message: 'Η υπερωρία δηλώνεται σε διαστήματα των 30 λεπτών.',
          type: SnackbarType.Warning,
        );
      } */
      else if (isLater(
        picked,
        addToTimeOfDay(_employee.workFinish, hour: 3),
      )) {
        showSnackbar(
          scaffoldContext: _scaffoldContext,
          message: 'Η νόμιμη διάρκεια υπερωρίας είναι 3 ώρες.',
          type: SnackbarType.Warning,
        );
      } else
        setState(() {
          _overtimeFinish = picked;
          _sliderValue = 0.5;
        });
    }
  }

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
            ),
          ),
        )
      ],
    );
  }

  void _handleSliderChange(newSliderValue) {
    var minutes = (newSliderValue * 60).toInt();
    if (isLater(
      addToTimeOfDay(_overtimeStart, minute: minutes),
      addToTimeOfDay(_employee.workFinish, hour: 3),
    )) {
      if (!_triggered)
        showSnackbar(
          scaffoldContext: _scaffoldContext,
          message: 'Η νόμιμη διάρκεια υπερωρίας είναι 3 ώρες.',
          type: SnackbarType.Warning,
        );
      setState(() => _triggered = true);
    } else {
      setState(() {
        _sliderValue = newSliderValue;
        _overtimeFinish = addToTimeOfDay(_overtimeStart, minute: minutes);
      });
    }
  }

// TODO: Still works?
  _handleSend() async {
    if (_employer != null) {
      SmsSender sender = SmsSender();
      String address = _employer.smsNumber;
      SmsMessage message = SmsMessage(address, _erganiCode);
      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sending) {
          setState(() => _isLoading = true);
        } else if (state == SmsMessageState.Sent) {
          setState(() => _isLoading = false);
          Navigator.pop(context, true);
        } else if (state == SmsMessageState.Fail) {
          showSnackbar(
            scaffoldContext: _scaffoldContext,
            type: SnackbarType.Warning,
            message: 'Αποτυχία αποστολής μηνύματος',
          );
          setState(() => _isLoading = false);
        }
      });

      await sender.sendSms(message);
    } else {
      showSnackbar(
        scaffoldContext: _scaffoldContext,
        type: SnackbarType.Warning,
        message: 'Σφάλμα αποστολής. Ελέγξτε τα στοιχεία της εταιρίας.',
      );

      setState(() => _isLoading = false);
    }
  }
}
