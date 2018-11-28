import 'package:ergani_e8/components/time_picker.dart';
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
  Employee _employee;
  TimeOfDay _workStart, _workFinish;
  FocusNode firstNameFocus, lastNameFocus, vatNumberFocus;

  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _vatNumberController = TextEditingController();

  bool _shouldValidateOnChangeFirstName = false;
  bool _shouldValidateOnChangeLastName = false;
  bool _shouldValidateOnChangeVatNumber = false;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;

    _firstNameController.text = _employee?.firstName;
    _lastNameController.text = _employee?.lastName;
    _vatNumberController.text = _employee?.vatNumber;
    _workStart = _employee?.workStart ?? TimeOfDay(hour: 08, minute: 00);
    _workFinish = _employee?.workFinish ?? TimeOfDay(hour: 16, minute: 00);

    firstNameFocus = FocusNode();
    lastNameFocus = FocusNode();
    vatNumberFocus = FocusNode();

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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _vatNumberController.dispose();
    super.dispose();
  }

  void submit(context) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      var firstName = _firstNameController.text[0].toUpperCase() +
              _firstNameController.text.substring(1) ??
          '';
      // '${_firstNameController.text[0].toUpperCase()}${_firstNameController.text.substring(1)}';
      var lastName = _lastNameController.text[0].toUpperCase() +
              _lastNameController.text.substring(1) ??
          '';
      // '${_lastNameController.text[0].toUpperCase()}${_lastNameController.text.substring(1)}';
      var vatNumber = _vatNumberController.text;

      var employeeToSubmit =
          Employee(firstName, lastName, vatNumber, _workStart, _workFinish);

      // TODO: directly write to the db, show loading in the midtime, then send ok via pop().
      _firstNameController.clear();
      _lastNameController.clear();
      _vatNumberController.clear();
      Navigator.pop(context, employeeToSubmit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${_employee == null ? 'Προσθήκη' : 'Επεξεργασία'} υπαλλήλου'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // FIRSTNAME Textfield
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: _buildFirstName(context),
                  )),

                  // LASTNAME textfield
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: _buildLastName(context),
                  )),
                ],
              ),
              // VATNUMBER textfield
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _buildVatNumber(context),
              ),
              // TIMETOSTART
              _buildWorkHours(context),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: RaisedButton(
                        onPressed: () => this.submit(context),
                        child: Text(
                          'ΑΠΟΘΗΚΕΥΣΗ',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: FlatButton(
                        shape: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).buttonColor),
                        ),
                        child: Text(
                          'ΑΚΥΡΟ',
                          style:
                              TextStyle(color: Theme.of(context).buttonColor),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildFirstName(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(lastNameFocus);
      },
      autofocus: true,
      autovalidate: _shouldValidateOnChangeFirstName,
      focusNode: firstNameFocus,
      decoration: InputDecoration(
        labelText: 'Όνομα',
        border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor)),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Προσθέστε όνομα';
        }
      },
      controller: _firstNameController,
    );
  }

  TextFormField _buildLastName(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        if (value.isEmpty)
          setState(() => _shouldValidateOnChangeLastName = true);
        else
          FocusScope.of(context).requestFocus(vatNumberFocus);
      },
      focusNode: lastNameFocus,
      decoration: InputDecoration(
        labelText: 'Επίθετο',
        border: OutlineInputBorder(),
        // prefixIcon: Icon(Icons.perm_contact_calendar)
        // prefixIcon: Icon(Icons.recent_actors)
        prefixIcon: Icon(Icons.contacts),
      ),
      validator: (value) {
        if (value.isEmpty) return 'Προσθέστε επίθετο';
      },
      autovalidate: _shouldValidateOnChangeLastName,
      // onEditingComplete: () =>
      controller: _lastNameController,
    );
  }

  TextFormField _buildVatNumber(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      focusNode: vatNumberFocus,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'ΑΦΜ',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.work),
      ),
      validator: (value) => validateAfm(value),
      autovalidate: _shouldValidateOnChangeVatNumber,
      maxLength: 9,
      onFieldSubmitted: (value) {
        if (!isValid(value, RegExp(r'^[0-9]+$')) || value.length != 9)
          setState(() => _shouldValidateOnChangeVatNumber = true);
        // else
        // FocusScope.of(context).requestFocus();
      },
      controller: _vatNumberController,
    );
  }

  _buildWorkHours(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TimePickerButton(
          workHour: _workStart,
          onPressed: () => _selectWorkStart(context),
        ),
        Icon(Icons.arrow_forward),
        TimePickerButton(
          workHour: _workFinish,
          onPressed: () => _selectWorkFinish(context),
        ),
      ],
    );
  }

  void _selectWorkStart(BuildContext context) async {
    final TimeOfDay startTime = await showTimePicker(
      context: context,
      initialTime: _workStart,
    );

    if (startTime is TimeOfDay) setState(() => _workStart = startTime);
  }

  void _selectWorkFinish(BuildContext context) async {
    final TimeOfDay finishTime = await showTimePicker(
      context: context,
      initialTime: _workFinish,
    );

    if (finishTime is TimeOfDay) setState(() => _workFinish = finishTime);
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
