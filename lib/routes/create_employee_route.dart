import 'package:ergani_e8/models/employee.dart';
import 'package:flutter/material.dart';

class CreateEmployeeRoute extends StatefulWidget {
  final Employee employee;
  CreateEmployeeRoute({BuildContext context, this.employee});

  @override
  CreateEmployeeRouteState createState() {
    return CreateEmployeeRouteState();
  }
}

// TODO: Don't add if AFM already exists.
class CreateEmployeeRouteState extends State<CreateEmployeeRoute> {
  final _formKey = GlobalKey<FormState>();
  // FocusNode employeeFocusNode;
  FocusNode firstNameFocus;
  FocusNode lastNameFocus;
  FocusNode vatNumberFocus;
  FocusNode timeToStartFocus;

  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _vatNumberController = TextEditingController();
  var _timeToStartController = TextEditingController();

  Employee _employee;
  bool _shouldValidateOnChangeFirstName = false;
  bool _shouldValidateOnChangeLastName = false;
  bool _shouldValidateOnChangeVatNumber = false;
  bool _shouldValidateOnChangeTimeToStart = false;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;

    // if (_employee != null) {
      _firstNameController.text = _employee?.firstName;
      _lastNameController.text = _employee?.lastName;
      _vatNumberController.text = _employee?.vatNumber;
      _timeToStartController.text =
          '${_employee?.hourToStart.hour}:${_employee?.hourToStart.minute}';
    // }
    firstNameFocus = FocusNode();
    lastNameFocus = FocusNode();
    vatNumberFocus = FocusNode();
    timeToStartFocus = FocusNode();

    // firstNameFocus.addListener(() {
    //   if (!firstNameFocus.hasFocus) {
    //     setState(() => _shouldValidateOnChangeFirstName = true);
    //   }
    // });
    // lastNameFocus.addListener(() {
    //   if (!lastNameFocus.hasFocus)
    //     setState(() => _shouldValidateOnChangeLastName = true);
    // });
    // vatNumberFocus.addListener(() {
    //   if (!vatNumberFocus.hasFocus)
    //     setState(() => _shouldValidateOnChangeVatNumber = true);
    // });
  }

  @override
  void dispose() {
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    vatNumberFocus.dispose();
    timeToStartFocus.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _vatNumberController.dispose();
    _timeToStartController.dispose();
    super.dispose();
  }

  void submit(context) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      // int.tryParse returns null on invalid input. Can use ?? to check if null.
      // e.g. int val = int.tryParse(text) ?? defaultValue;
      int hour = int.tryParse(_timeToStartController.text.substring(0, 2));
      int minute = int.tryParse(_timeToStartController.text.substring(2, 4));
      var time = TimeOfDay(hour: hour, minute: minute);
      var firstName =
          '${_firstNameController.text[0].toUpperCase()}${_firstNameController.text.substring(1)}';
      var lastName =
          '${_lastNameController.text[0].toUpperCase()}${_lastNameController.text.substring(1)}';
      var vatNumber = _vatNumberController.text;

      var employeeToSubmit = Employee(firstName, lastName, vatNumber, time);

    // TODO: directly write to the db, show loading in the midtime, then send ok via pop().
      _firstNameController.clear();
      _lastNameController.clear();
      _vatNumberController.clear();
      _timeToStartController.clear();
      Navigator.pop(context, employeeToSubmit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text('${_employee == null ? 'Προσθήκη' : 'Επεξεργασία'} υπαλλήλου'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // FIRSTNAME Textfield
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(lastNameFocus);
                },
                autofocus: true,
                autovalidate: _shouldValidateOnChangeFirstName,
                focusNode: firstNameFocus,
                decoration: InputDecoration(labelText: 'Όνομα'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Προσθέστε όνομα';
                  }
                },
                controller: _firstNameController,
              ),
              // LASTNAME textfield
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  if (value.isEmpty)
                    setState(() => _shouldValidateOnChangeLastName = true);
                  else
                    FocusScope.of(context).requestFocus(vatNumberFocus);
                },
                focusNode: lastNameFocus,
                decoration: InputDecoration(labelText: 'Επίθετο'),
                validator: (value) {
                  if (value.isEmpty) return 'Προσθέστε επίθετο';
                },
                autovalidate: _shouldValidateOnChangeLastName,
                // onEditingComplete: () =>
                controller: _lastNameController,
              ),
              // VATNUMBER textfield
              TextFormField(
                keyboardType: TextInputType.number,
                focusNode: vatNumberFocus,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'ΑΦΜ'),
                validator: (value) => validateAfm(value),
                autovalidate: _shouldValidateOnChangeVatNumber,
                maxLength: 9,
                onFieldSubmitted: (value) {
                  if (!isValid(value, RegExp(r'^[0-9]+$')) || value.length != 9)
                    setState(() => _shouldValidateOnChangeVatNumber = true);
                  else
                    FocusScope.of(context).requestFocus(timeToStartFocus);
                },
                controller: _vatNumberController,
              ),
              // TIMETOSTART
              TextFormField(
                keyboardType: TextInputType.number,
                focusNode: timeToStartFocus,
                controller: _timeToStartController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Λήξη Εργασίας'),
                autovalidate: _shouldValidateOnChangeTimeToStart,
                maxLength: 4,
                validator: (value) {
                  if (!isValid(value, RegExp(r'^[0-9]+$')) ||
                      value.length != 4|| value.isEmpty ) {
                    print('hello from validator');
                    return 'Προσθέστε ώρα';
                  }
                },
                onFieldSubmitted: (value) {
                  if (!isValid(value, RegExp(r'^[0-9]+$')) ||
                      value.length != 4 || value.isEmpty) {
                    setState(() => _shouldValidateOnChangeTimeToStart = true);
                    print('hello from onFieldSubmitted');
                  } else
                    this.submit(context);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text('ΑΚΥΡΟ', style: TextStyle(color: Colors.teal)),
          // color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        Padding(
          padding: EdgeInsets.all(0.0),
          child: RaisedButton(
            color: Colors.teal,
            onPressed: () => this.submit(context),
            child: Text(
              'ΑΠΟΘΗΚΕΥΣΗ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  validateAfm(String afm) {
    if (afm.isEmpty) {
      return 'Προσθέστε ΑΦΜ';
    } else if (!isValid(afm, RegExp(r'^[0-9]+$')) || afm.length != 9) {
      return 'Ο ΑΦΜ αποτελείται απο 9 αριθμούς';
    }
  }
}

bool isValid(String value, RegExp regex) {
  return regex
      .allMatches(value)
      .map((match) => match.start == 0 && match.end == value.length)
      .reduce((sum, nextValue) => sum && nextValue);
}
