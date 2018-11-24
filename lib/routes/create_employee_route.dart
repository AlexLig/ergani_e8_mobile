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

class _EmployeeData {
  String firstName;
  String lastName;
  String vatNumber;
}

// TODO: Don't add if AFM already exists.
class EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  // FocusNode employeeFocusNode;
  FocusNode nameFocus;
  FocusNode surnameFocus;
  FocusNode vatNumberFocus;
  var _data = _EmployeeData();

  // TextEditingController _nameController,
  //     _surnameController,
  //     _vatNumberController;
    var _nameController = TextEditingController();
    var _surnameController = TextEditingController();
    var _vatNumberController = TextEditingController();
      
      

  @override
  void initState() {
    super.initState();
    // _employee = widget.employee;
    // _nameController = TextEditingController();
    // _surnameController = TextEditingController();
    // _vatNumberController = TextEditingController();

    // if (_employee != null) {
    //   _nameController.text = _employee.firstName;
    //   _surnameController.text = _employee.lastName;
    //   _vatNumberController.text = _employee.vatNumber;
    // }
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

      _data.firstName = _nameController.text;
      _data.lastName = _surnameController.text;
      _data.vatNumber = _vatNumberController.text;

      _nameController.clear();
      _surnameController.clear();
      _vatNumberController.clear();

      print('Printing the employee data.');
      print('Name: ${_data.firstName}');
      print('Surname: ${_data.lastName}');
      print('VatNumber: ${_data.vatNumber}');

      Navigator.pop(
        context,
        Employee(
          firstName: _data.firstName,
          lastName: _data.lastName,
          vatNumber: _data.vatNumber,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Προσθήκη υπαλλήλου'),
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
}

validateAfm(String afm) {
  if (afm.isEmpty) {
    return 'Προσθέστε ΑΦΜ';
  } else if (!isValid(afm, RegExp(r'^[0-9]+$')) || afm.length != 9) {
    return 'Ο ΑΦΜ αποτελείται απο 9 αριθμούς';
  }
}

bool isValid(String value, RegExp regex) {
  return regex
      .allMatches(value)
      .map((match) => match.start == 0 && match.end == value.length)
      .reduce((sum, nextValue) => sum && nextValue);
}

// bool logicalAnd(sum, nextValue) => sum && nextValue;
// Function assertMatchEnds(String value) => (match) => match.start == 0 && match.end == value.length;
