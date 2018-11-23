import 'package:ergani_e8/contacts/employee.dart';
import 'package:flutter/material.dart';

class EmployeeForm extends StatefulWidget {
  @override
  EmployeeFormState createState() {
    return EmployeeFormState();
  }
}

class _EmployeeData {
  String firstName = '';
  String lastName = '';
  String vatNumber = '';
}

class EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  // FocusNode employeeFocusNode;
  FocusNode name;
  FocusNode surname;
  FocusNode vatNumber;

  var _data = _EmployeeData();
  // var _data = Employee(
  //   firstName: '',
  //   lastName: '',
  //   vatNumber: '',
  // );

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final vatNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();

    name = FocusNode();
    surname = FocusNode();
    vatNumber = FocusNode();
  }

  @override
  void dispose() {
    name.dispose();
    surname.dispose();
    vatNumber.dispose();
    nameController.dispose();
    surnameController.dispose();
    vatNumberController.dispose();
    super.dispose();
  }

  submit(context) {
    if (this._formKey.currentState.validate()) {
      //_formKey.currentState.save();

      _data.firstName = nameController.text;
      _data.lastName = surnameController.text;
      _data.vatNumber = vatNumberController.text;

      nameController.clear();
      surnameController.clear();
      vatNumberController.clear();

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
    return Scaffold(
      appBar: AppBar(),
      body: Container(
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
                  FocusScope.of(context).requestFocus(surname);
                },
                autofocus: true,
                focusNode: name,
                decoration: InputDecoration(labelText: 'Όνομα'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Προσθέστε όνομα';
                  }
                },
                controller: nameController,
              ),
              // SURNAME textfield
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(vatNumber);
                },
                focusNode: surname,
                decoration: InputDecoration(labelText: 'Επίθετο'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Προσθέστε επίθετο';
                  }
                },
                controller: surnameController,
              ),
              // VATNUMBER textfield
              TextFormField(
                keyboardType: TextInputType.number,
                focusNode: vatNumber,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'ΑΦΜ'),
                validator: (value) => validateAfm(value),
                controller: vatNumberController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
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
              ),
            ],
          ),
        ),
      ),
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
