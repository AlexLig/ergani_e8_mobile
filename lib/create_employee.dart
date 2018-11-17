import 'package:flutter/material.dart';

class EmployeeForm extends StatefulWidget {
  @override
  EmployeeFormState createState() {
    return EmployeeFormState();
  }
}

class _EmployeeData {
  String name = '';
  String surname = '';
  String vatNumber = '';
}

class EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  // FocusNode employeeFocusNode;
  FocusNode name;
  FocusNode surname;
  FocusNode vatNumber;

  var _data = _EmployeeData();

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
    super.dispose();
  }

  submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      print('Printing the employee data.');
      print('Name: ${_data.name}');
      print('Surname: ${_data.surname}');
      print('VatNumber: ${_data.vatNumber}');
      
      return Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Η καταχώρηση ολοκληρώθηκε')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
            decoration: InputDecoration(labelText: 'Όνομα'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Προσθέστε όνομα';
              }
            },
            onSaved: (value) => this._data.name = value.trim(),
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
              onSaved: (value) => this._data.surname = value.trim()),
          // VATNUMBER textfield
          TextFormField(
              keyboardType: TextInputType.number,
              focusNode: vatNumber,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'ΑΦΜ'),
              validator: (value) => validateAfm(value),
              onSaved: (value) => this._data.vatNumber = value.trim()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                  this.submit();
              },
              child: Text('Submit'),
            ),
          ),
        ],
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
  final matches = regex.allMatches(value);
  for (Match match in matches) {
    if (match.start == 0 && match.end == value.length) {
      return true;
    }
  }
  return false;
}
