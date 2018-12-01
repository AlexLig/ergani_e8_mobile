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
  bool _hasAme;

  var _nameFocus = FocusNode();
  var _afmFocus = FocusNode();
  var _ameFocus = FocusNode();

  var _nameController = TextEditingController();
  var _afmController = TextEditingController();
  var _ameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hasAme = false;
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

  void submit(context) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      var employerToSubmit = Employer(
        _afmController.text,
        '${_nameController.text[0].toUpperCase()}${_nameController.text.substring(1)}',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF999999),
              const Color(0xFFFFFFEE),
            ], // whitish to gray
            tileMode: TileMode.clamp,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildMainTextFields(),
                buildAmeRow(),
                OutlineButton(
                    child: new Text('Επόμενο'),
                    // TODO: navigate to next screen.
                    onPressed: null,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildMainTextFields() {
    return Column(
      children: <Widget>[
        // NAME Textfield
        TextFormField(
          decoration: InputDecoration(labelText: 'Όνομα Εργοδότη'),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_afmFocus);
          },
          autofocus: true,
          focusNode: _nameFocus,
          controller: _nameController,
          validator: (value) => value.isEmpty ? 'Προσθέστε όνομα' : null,
        ),

        // AFM textfield
        TextFormField(
          decoration: InputDecoration(labelText: 'ΑΦΜ'),
          keyboardType: TextInputType.number,
          textInputAction:
              _hasAme ? TextInputAction.next : TextInputAction.done,
          focusNode: _afmFocus,
          controller: _afmController,
          onFieldSubmitted: (value) {
            if (_hasAme) FocusScope.of(context).requestFocus(_ameFocus);
          },
          maxLength: 9,
          validator: (value) => validateAfm(value),
        ),
      ],
    );
  }

  Row buildAmeRow() => Row(
        children: <Widget>[
          Switch(
            value: _hasAme,
            onChanged: (bool newValue) {
              setState(() {
                _hasAme = newValue;
              });
            },
          ),
          // AME textfield
          TextFormField(
            decoration: InputDecoration(labelText: 'ΑΜΕ'),
            enabled: _hasAme,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            focusNode: _ameFocus,
            controller: _ameController,
            maxLength: 10,
            validator: (ame) => validateAme(ame),
          ),
        ],
      );
}
