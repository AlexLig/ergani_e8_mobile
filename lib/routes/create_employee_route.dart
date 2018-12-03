import 'package:ergani_e8/components/buttons/cancel_max_width.dart';
import 'package:ergani_e8/components/buttons/submit_max_width.dart';
import 'package:ergani_e8/components/time_picker.dart';
import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:ergani_e8/utils/database_helper.dart';
import 'package:ergani_e8/utils/input_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateEmployeeRoute extends StatefulWidget {
  final Employee employee;
  CreateEmployeeRoute({BuildContext context, this.employee});

  @override
  CreateEmployeeRouteState createState() {
    return CreateEmployeeRouteState();
  }
}

class CreateEmployeeRouteState extends State<CreateEmployeeRoute> {
  final _formKey = GlobalKey<FormState>();

  ErganiDatabase _erganiDatabase = ErganiDatabase();
  // FocusNode employeeFocusNode;
  Employee _employee;
  TimeOfDay _workStart, _workFinish;

  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _afmController = TextEditingController();

  var firstNameFocus = FocusNode();
  var lastNameFocus = FocusNode();
  var afmFocus = FocusNode();

  bool _shouldValidateOnChangeFirstName = false;
  bool _shouldValidateOnChangeLastName = false;
  bool _shouldValidateOnChangeAfm = false;
  bool _isWorkFinishTouched = false;

  bool _afmExist = false;
  bool _isValidAfm = false;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;

    _firstNameController.text = _employee?.firstName;
    _lastNameController.text = _employee?.lastName;
    _afmController.text = _employee?.afm;
    _workStart = _employee?.workStart ?? TimeOfDay(hour: 08, minute: 00);
    _workFinish = _employee?.workFinish ?? TimeOfDay(hour: 16, minute: 00);

    _afmController.addListener(checkIfAfmExist);
  }

  void checkIfAfmExist() async {
    // For async validation
    if ((_isValidAfm || int.tryParse(_afmController.text) != null) &&
        int.tryParse(_afmController.text).abs().toString().length == 9 &&
        _employee?.afm != _afmController.text) {
      var employeeList =
          await _erganiDatabase.getEmployeeMapListByAfm(_afmController.text);
      if (employeeList.isNotEmpty) {
        _afmExist = true;
        this._formKey.currentState.validate();
      }
    } else if (_afmController.text.length < 9 && _afmExist) {
      _afmExist = false;
      this._formKey.currentState.validate();
    }
  }

  @override
  void dispose() {
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    afmFocus.dispose();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _afmController.dispose();

    super.dispose();
  }

  Future _submit(context) async {
    if (this._formKey.currentState.validate()) {
      // close keyboard
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      _formKey.currentState.save();

      var afm = _afmController.text;
      var employeeToSubmit = Employee(_firstNameController.text,
          _lastNameController.text, afm, _workStart, _workFinish);

      int result;

      if (_employee == null && !_afmExist) {
        result = await _erganiDatabase.createEmployee(employeeToSubmit);
      } else if (_employee is Employee && !_afmExist) {
        await _erganiDatabase.deleteEmployee(_employee);
        result = await _erganiDatabase.createEmployee(employeeToSubmit);
      }

      if (result != 0)
        Navigator.pop(context, employeeToSubmit);
      else
        Navigator.pop(context);

      _firstNameController.clear();
      _lastNameController.clear();
      _afmController.clear();
    }
    setState(() {
      _shouldValidateOnChangeFirstName = true;
      _shouldValidateOnChangeLastName = true;
      _shouldValidateOnChangeAfm = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${_employee == null ? 'Προσθήκη' : 'Επεξεργασία'} υπαλλήλου'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    _buildNamesListTile(),
                    _buildAfmField(),
                    _buildWorkHours(),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SubmitButtonMaxWidth(onSubmit: () => _submit(context)),
                CancelButtonMaxWidth(),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildNamesListTile() {
    return ListTile(
        title: Row(
      children: <Widget>[
        Expanded(child: _buildFirstName()),
        SizedBox(width: 8.0),
        Expanded(child: _buildLastName()),
      ],
    ));
  }

  _buildFirstName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        if (value.isEmpty)
          setState(() => _shouldValidateOnChangeFirstName = true);
        else
          FocusScope.of(context).requestFocus(lastNameFocus);
      },
      autofocus: true,
      autovalidate: _shouldValidateOnChangeFirstName,
      focusNode: firstNameFocus,
      decoration: InputDecoration(
        labelText: 'Όνομα',
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor)),
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

  _buildLastName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        if (value.isEmpty)
          setState(() => _shouldValidateOnChangeLastName = true);
        else
          FocusScope.of(context).requestFocus(afmFocus);
      },
      focusNode: lastNameFocus,
      decoration: InputDecoration(
        labelText: 'Επίθετο',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.contacts),
      ),
      validator: (value) {
        if (value.isEmpty) return 'Προσθέστε επίθετο';
      },
      autovalidate: _shouldValidateOnChangeLastName,
      controller: _lastNameController,
    );
  }

  _buildAfmField() {
    final length = 9;
    return ListTile(
      title: TextFormField(
        keyboardType: TextInputType.number,
        focusNode: afmFocus,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          //DONE
          labelText: 'ΑΦΜ',
          border: OutlineInputBorder(), //
          prefixIcon: Icon(Icons.work),
        ),
        validator: (afm) {
          if (afm.isEmpty) {
            return 'Προσθέστε ΑΦΜ';
          } else if (afm.length != length) {
            return 'Εισάγετε $length αριθμούς';
          } else if (int.tryParse(afm) == null ||
              getIntLength(int.tryParse(afm)) != length) {
            return 'Ο ΑΦΜ αποτελείται μόνο απο αριθμούς';
          }
          if (_afmExist) {
            return 'Ο ΑΦΜ χρησιμοποιείται ήδη';
          }
          // else
          //   return validateNumericInput(numValue: afm, label: 'ΑΦΜ', length: length);
          _isValidAfm = true;
        },
        autovalidate: _shouldValidateOnChangeAfm,
        maxLength: length,
        onFieldSubmitted: (value) {
          if (isNotValidInt(value, length))
            setState(() => _shouldValidateOnChangeAfm = true); //
        },
        controller: _afmController,
      ),
    );
  }

  _buildWorkHours() {
    return ListTile(
      title: TimePickerButton(
        isReset: false,
        workStart: _workStart,
        workFinish: _workFinish,
        onSelectStartTime: () => _selectWorkStart(context),
        onSelectFinishTime: () => _selectWorkFinish(context),
      ),
    );
  }

  void _selectWorkStart(BuildContext context) async {
    final TimeOfDay startTime = await showTimePicker(
      context: context,
      initialTime: _workStart,
    );

    if (startTime is TimeOfDay)
      setState(() {
        _workStart = startTime;
        if (!_isWorkFinishTouched)
          _workFinish = minutesToTime(timeToMinutes(startTime) + 8 * 60);
      });
  }

  void _selectWorkFinish(BuildContext context) async {
    final TimeOfDay finishTime = await showTimePicker(
      context: context,
      initialTime: _workFinish,
    );

    if (finishTime is TimeOfDay)
      setState(() {
        _isWorkFinishTouched = true;
        _workFinish = finishTime;
      });
  }
}
