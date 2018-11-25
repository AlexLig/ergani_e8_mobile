import 'package:ergani_e8/models/employee.dart';
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
  FocusNode nameFocus;
  FocusNode surnameFocus;
  FocusNode vatNumberFocus;

  var _nameController = TextEditingController();
  var _surnameController = TextEditingController();
  var _vatNumberController = TextEditingController();

  Employee _employee;

  var _employeeList;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;

    if (_employee != null) {
      _nameController.text = _employee.firstName;
      _surnameController.text = _employee.lastName;
      _vatNumberController.text = _employee.vatNumber;
    }
    nameFocus = FocusNode();
    surnameFocus = FocusNode();
    vatNumberFocus = FocusNode();
  }

  @override
  void dispose() {
    nameFocus.dispose();
    surnameFocus.dispose();
    vatNumberFocus.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _vatNumberController.dispose();
    super.dispose();
  }

  submit(context) {
    if (this._formKey.currentState.validate()) {
      //_formKey.currentState.save();
      Employee employeeToSubmit = Employee(
          firstName: _nameController.text,
          lastName: _surnameController.text,
          vatNumber: _vatNumberController.text);

      _nameController.clear();
      _surnameController.clear();
      _vatNumberController.clear();

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
              // NAME Textfield
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(surnameFocus);
                },
                autofocus: true,
                focusNode: nameFocus,
                decoration: InputDecoration(labelText: 'Όνομα'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Προσθέστε όνομα';
                  }
                },
                controller: _nameController,
              ),
              // SURNAME textfield
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(vatNumberFocus);
                },
                focusNode: surnameFocus,
                decoration: InputDecoration(labelText: 'Επίθετο'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Προσθέστε επίθετο';
                  }
                },
                controller: _surnameController,
              ),
              // VATNUMBER textfield
              TextFormField(
                keyboardType: TextInputType.number,
                focusNode: vatNumberFocus,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'ΑΦΜ'),
                validator: (value) => validateAfm(value),
                controller: _vatNumberController,
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
