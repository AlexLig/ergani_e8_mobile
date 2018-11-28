import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class EmployeeForm extends StatefulWidget {
  final Employee employee;
  EmployeeForm({BuildContext context, this.employee});

  @override
  EmployeeFormState createState() {
    return EmployeeFormState();
  }
}

// TODO: Don't add if AFM already exists.
class EmployeeFormState extends State<EmployeeForm> {
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
  var _employeeList;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;

    if (_employee != null) {
      _firstNameController.text = _employee.firstName;
      _lastNameController.text = _employee.lastName;
      _vatNumberController.text = _employee.vatNumber;
      // _timeToStartController.text =
      //     '${_employee.hourToStart.hour}${_employee.hourToStart.minute}';
    }
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

// '${s[0].toUpperCase()}${s.substring(1)}'
  submit(context) {
    if (this._formKey.currentState.validate()) {
      //_formKey.currentState.save();
      Employee employeeToSubmit = Employee(
        '${_firstNameController.text[0].toUpperCase()}${_firstNameController.text.substring(1)}',
        '${_lastNameController.text[0].toUpperCase()}${_lastNameController.text.substring(1)}',
        _vatNumberController.text,
        TimeOfDay(
          hour: int.tryParse(_timeToStartController.text.substring(0, 2)) ?? 00,
          minute:
              int.tryParse(_timeToStartController.text.substring(2, 4)) ?? 00,
        ),
      );
// int.tryParse returns null on invalid input. Can use ?? to check if null.
// e.g. int val = int.tryParse(text) ?? defaultValue;

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
                      value.length != 4) {
                    print('hello from validator');
                    return 'Προσθέστε ώρα';
                  }
                },
                onFieldSubmitted: (value) {
                  if (!isValid(value, RegExp(r'^[0-9]+$')) ||
                      value.length != 4) {
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
}
