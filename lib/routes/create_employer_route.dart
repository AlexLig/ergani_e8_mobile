import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:ergani_e8/utils/input_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  var _isReceiverEditable = false;

  var _nameFocus = FocusNode();
  var _afmFocus = FocusNode();
  var _ameFocus = FocusNode();
  var _receiverFocus = FocusNode();

  var _nameController = TextEditingController();
  var _afmController = TextEditingController();
  var _ameController = TextEditingController();
  var _receiverController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _employer = widget.employer;

    _nameController.text = _employer?.name;
    _afmController.text = _employer?.afm;
    _ameController.text = _employer?.ame;
    _receiverController.text = _employer?.receiverNumber ??
        '54001'; //TODO: Add receiver number to Employer

    _hasAme = _employer?.ame ?? false;
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
        _hasAme ? _ameController.text : null, //TODO: can pass null?
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
      appBar: AppBar(
        title: Text('Εταιρικό Προφίλ'),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Colors.white,
        //       Colors.white,
        //       Colors.white,
        //       Theme.of(context).canvasColor,
        //       Theme.of(context).primaryColorLight,
        //     ],
        //     tileMode: TileMode.repeated,
        // ),
        // ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    _buildMainTextFields(),
                    _buildAmeField(),
                    Divider(),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  OutlineButton(
                      child: new Text('Επόμενο'),
                      // TODO: navigate to next screen.
                      onPressed: null,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildMainTextFields() {
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
          validator: (afm) {
            if (afm.isEmpty) {
              return 'Προσθέστε ΑΦΜ';
            } else if (afm.length != 9) {
              return 'Προσθέστε 9 αριθμούς';
            } else if (int.tryParse(afm) == null ||
                getIntLength(int.tryParse(afm)) != 9) {
              return ' Ο ΑΦΜ αποτελείται ΜΟΝΟ απο αριθμούς';
            }
          },
        ),
      ],
    );
  }

  _buildAmeField() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,

      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: _hasAme,
          onChanged: (val) => setState(() {
                _hasAme = val;
                // if(!_hasAme) _ameController.text = '';
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 34.0),
          child: Text('AME', style: TextStyle(fontSize: 16.0)),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              contentPadding: EdgeInsets.only(bottom: 5.0, top: 20.0),
            ),
            style:
                TextStyle(color: _hasAme ? Colors.grey[900] : Colors.grey[300]),
            enabled: _hasAme,
            keyboardType: TextInputType.number,
            textInputAction: _isReceiverEditable
                ? TextInputAction.next
                : TextInputAction.done,
            focusNode: _ameFocus,
            controller: _ameController,
            maxLength: 10,
            validator: (ame) {
              if (ame.isEmpty) {
                return 'Προσθέστε ΑME';
              } else if (ame.length != 10) {
                return 'Προσθέστε 10 αριθμούς';
              } else if (int.tryParse(ame) == null ||
                  getIntLength(int.tryParse(ame)) != 10) {
                return 'Ο ΑME αποτελείται ΜΟΝΟ απο αριθμούς';
              }
            },
          ),
        ),
      ],
    );
  }

  _buildReceiverField(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('Αποστολή SMS στο:'),
        TextFormField(
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _employer?.receiverNumber == '54001'
                  ? _handleEditReceiverNumber(context)
                  : setState(() => _isReceiverEditable = true),
            ),
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          enabled: _isReceiverEditable,
          focusNode: _receiverFocus,
          controller: _receiverController,
          validator: (number){
            if(number.isEmpty) return 'Προσθέστε αριθμό παραλήπτη';
            else return int.tryParse(number) ?? 'Εισάγετε μόνο αριθμούς';
          },
        ),
      ],
    );
  }

  _handleEditReceiverNumber(BuildContext context) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final _shouldEdit = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
            title: Text('Επεξεργασία αριθμού;'),
            content: Column(
              children: [
                Text(
                    'Ο αριθμός 54001 ορίζεται από οδηγία του υπουργείου Εργασίας.'),
                Text('Θέλετε να τον επεξεργαστείτε;'),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('ΑΚΥΡΟ'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('ΑΚΥΡΟ'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );
    if (_shouldEdit) setState(() => _isReceiverEditable = true);
  }
}
