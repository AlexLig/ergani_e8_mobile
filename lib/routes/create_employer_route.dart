import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class EmployerForm extends StatefulWidget {
  final Employer employer;

  const EmployerForm({BuildContext context, Key key, this.employer})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => EmployerFormState();
}

class EmployerFormState extends State<EmployerForm> {
  final _formKey = GlobalKey<FormState>();

  Employer _employer;

  var _nameFocus = FocusNode();
  var _afmFocus = FocusNode();
  var _ameFocus = FocusNode();

  var _nameController = TextEditingController();
  var _afmController = TextEditingController();
  var _ameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _employer = widget.employer;

    _nameController.text = _employer?.name;
    _afmController.text = _employer?.afm;
    _ameController.text = _employer?.ame;
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _afmFocus.dispose();
    _nameController.dispose();
    _afmController.dispose();
    _ameController.dispose();
    super.dispose();
  }

  submit(context) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      var employerToSubmit = Employer(
        _afmController.text,
        '${_nameController?.text[0].toUpperCase()}${_nameController.text.substring(1)}',
        _ameController.text,
      );
     
      _nameController.clear();
      _afmController.clear();
      _ameController.clear();

      Navigator.pop(context, employerToSubmit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // FIRSTNAME Textfield
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_afmFocus);
              },
              autofocus: true,
              focusNode: _nameFocus,
              decoration: InputDecoration(labelText: 'Όνομα Εργοδότη'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Προσθέστε όνομα';
                }
              },
              controller: _nameController,
            ),

            // AFM textfield
            TextFormField(
              keyboardType: TextInputType.number,
              focusNode: _afmFocus,
              decoration: InputDecoration(labelText: 'ΑΦΜ'),
              validator: (value) => validateAfm(value),
              maxLength: 9,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_ameFocus);
              },
              controller: _afmController,
            ),
            // AME textfield
            TextFormField(
              keyboardType: TextInputType.number,
              focusNode: _ameFocus,
              decoration: InputDecoration(labelText: 'ΑΜΕ'),
              validator: (value) => validateAfm(value),
              maxLength: 10,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_ameFocus);
              },
              controller: _afmController,
            ),
          ],
        ),
      ),
    );
  }
}
