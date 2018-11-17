import 'package:flutter/material.dart';

class EmployeeForm extends StatefulWidget {
  @override
  EmployeeFormState createState() {
    return EmployeeFormState();
  }
}

class EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  // FocusNode employeeFocusNode;
  FocusNode name;
  FocusNode surname;
  FocusNode vatNumber;

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
          ),
          // SURNAME textfield
          TextFormField(
            keyboardType:TextInputType.text,
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
          ),
          // VATNUMBER textfield
          TextFormField(
            keyboardType: TextInputType.number,
            focusNode: vatNumber,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'ΑΦΜ'),
            validator: (value) => validateAfm(value),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Η καταχώρηση ολοκληρώθηκε')));
                }
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
