import 'package:ergani_e8/components/buttons/cancel_max_width.dart';
import 'package:ergani_e8/components/buttons/submit_max_width.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utils/database_helper.dart';
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
  ErganiDatabase _erganiDatabase = ErganiDatabase();

  Employer _employer;
  bool _hasAme;
  bool _canEditSmsNumber;

  var _nameFocus = FocusNode();
  var _afmFocus = FocusNode();
  var _ameFocus = FocusNode();
  var _smsNumberFocus = FocusNode();

  var _nameController = TextEditingController();
  var _afmController = TextEditingController();
  var _ameController = TextEditingController();
  var _smsNumberController = TextEditingController();

  bool _shouldValidateOnChangeName = false;
  bool _shouldValidateOnChangeAfm = false;
  bool _shouldValidateOnChangeAme = false;

  @override
  void initState() {
    super.initState();
    
    _employer = widget.employer;

    _nameController.text = _employer?.name;
    _afmController.text = _employer?.afm;
    _ameController.text = _employer?.ame;
    _smsNumberController.text = _employer?.smsNumber ?? '54001';

    _canEditSmsNumber = _smsNumberController.text != '54001';
    _hasAme = _employer?.ame ?? false;
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _afmFocus.dispose();
    _ameFocus.dispose();
    _smsNumberFocus.dispose();

    _nameController.dispose();
    _afmController.dispose();
    _ameController.dispose();
    _smsNumberController.dispose();

    super.dispose();
  }

  void submit(context) async {
    if (this._formKey.currentState.validate()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      _formKey.currentState.save();

      var employerName =
          '${_nameController.text[0].toUpperCase()}${_nameController.text.substring(1)}';

      var employerToSubmit = Employer(
        _afmController.text,
        employerName,
        _smsNumberController.text,
        _ameController.text, //TODO: can pass null?
      );

      int result;

      if (_employer == null)
        result = await _erganiDatabase.createEmployer(employerToSubmit);
      else if (_employer is Employer) {
        await _erganiDatabase.deleteEmployer(_employer);
        result = await _erganiDatabase.createEmployer(employerToSubmit);
      }

      if (result != 0)
        Navigator.pop(context, employerToSubmit);
      else
        Navigator.pop(context);

      _nameController.clear();
      _afmController.clear();
      _ameController.clear();
      _smsNumberController.clear();

      Navigator.pop(context, employerToSubmit);
    }
    setState(() {
      _shouldValidateOnChangeName = true;
      _shouldValidateOnChangeAfm = true;
      _shouldValidateOnChangeAme = true;
      // _shouldValidateOnChangeSmsNumber = true; //TODO: no empty
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Εταιρικό Προφίλ'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    _buildNameField(),
                    _buildAfmField(),
                    _buildAmeTile(),
                    _buildSmsNumberField(context),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  SubmitButtonMaxWidth(onSubmit: () => submit(context)),
                  _employer != null ? CancelButtonMaxWidth() : null,
                ].where((val) => val != null).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildNameField() {
    return ListTile(
      title: TextFormField(
        decoration: InputDecoration(
            labelText: 'Όνομα Εργοδότη', prefixIcon: Icon(Icons.person)),
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        autovalidate: _shouldValidateOnChangeName,
        autofocus: true,
        focusNode: _nameFocus,
        controller: _nameController,
        onFieldSubmitted: (value) {
          if (value.isEmpty)
            setState(() => _shouldValidateOnChangeName = true);
          else
            FocusScope.of(context).requestFocus(_afmFocus);
        },
        validator: (value) => value.isEmpty ? 'Προσθέστε όνομα' : null,
      ),
    );
  }

  _buildAfmField() {
    return ListTile(
      title: TextFormField(
        keyboardType: TextInputType.number,
        focusNode: _afmFocus,
        decoration: InputDecoration(
          labelText: 'ΑΦΜ',
          prefixIcon: Icon(Icons.work),
        ),
        validator: (afm) {
          if (afm.isEmpty) {
            return 'Προσθέστε ΑΦΜ';
          } else if (afm.length != 9) {
            return 'Εισάγετε 9 αριθμούς';
          } else if (int.tryParse(afm) == null ||
              getIntLength(int.tryParse(afm)) != 9) {
            return ' Ο ΑΦΜ αποτελείται ΜΟΝΟ απο αριθμούς';
          }
        },
        autovalidate: _shouldValidateOnChangeAfm,
        maxLength: 9,
        onFieldSubmitted: (value) {
          if (int.tryParse(value) == null || value.length != 9)
            setState(() => _shouldValidateOnChangeAfm = true);
          else if (_hasAme) FocusScope.of(context).requestFocus(_ameFocus);
        },
        controller: _afmController,
        textInputAction: _hasAme ? TextInputAction.next : TextInputAction.done,
      ),
    );
  }

  _buildAmeTile() {
    return ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Checkbox(
              value: _hasAme,
              onChanged: (val) => setState(() {
                    _hasAme = val;
                    // if(!_hasAme) _ameController.text = '';
                  }),
            ),
            Text('AME', style: TextStyle(fontSize: 16.0))
          ],
        ),
        title: _buildAmeField());
  }

  _buildAmeField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (ame) {
        if (_hasAme) {
          if (ame.isEmpty) {
            return 'Προσθέστε ΑME';
          } else if (ame.length != 10) {
            return 'Προσθέστε 10 αριθμούς';
          } else if (int.tryParse(ame) == null ||
              getIntLength(int.tryParse(ame)) != 10) {
            return 'Ο ΑME αποτελείται ΜΟΝΟ απο αριθμούς';
          }
        }
      },
      autovalidate: _shouldValidateOnChangeAme,
      onFieldSubmitted: (value) {
        if (int.tryParse(value) == null || value.length != 9)
          setState(() => _shouldValidateOnChangeAme = true);
        else if (_hasAme) FocusScope.of(context).requestFocus(_ameFocus);
      },
      decoration: InputDecoration(
        hasFloatingPlaceholder: false,
        contentPadding: EdgeInsets.only(bottom: 5.0, top: 20.0),
      ),
      style: TextStyle(color: _hasAme ? Colors.grey[900] : Colors.grey[300]),
      enabled: _hasAme,
      textInputAction:
          _canEditSmsNumber ? TextInputAction.next : TextInputAction.done,
      focusNode: _ameFocus,
      controller: _ameController,
      maxLength: 10,
    );
  }

  _buildSmsNumberField(BuildContext context) {
    return ListTile(
        // mainAxisSize: MainAxisSize.min,
        // children: <Widget>[
        leading: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            'Παραλήπτης SMS:',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        title: Stack(
          alignment: Alignment(0.9, 1.0),
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[900],
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    enabled: _canEditSmsNumber,
                    focusNode: _smsNumberFocus,
                    controller: _smsNumberController,
                    validator: (number) {
                      if (number.isEmpty)
                        return 'Προσθέστε αριθμό παραλήπτη';
                      else if (int.tryParse(number) == null)
                        return 'Εισάγετε μόνο αριθμούς';
                    },
                  ),
                ),
              ],
            ),
            IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColorDark,),
                disabledColor: Theme.of(context).primaryColorLight,
                
                onPressed: _canEditSmsNumber
                    ? null
                    : () => _handleEditSmsNumber(context)
                // onPressed: () => _employer?.smsNumber == '54001'
                //     ? _handleEditSmsNumber(context)
                //     : setState(() => _isReceiverEditable = true),
                ),
          ],
        ),);
  }

  _handleEditSmsNumber(BuildContext context) async {

    final bool allowEdit = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Επεξεργασία αριθμού;'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Ο αριθμός 54001 ορίζεται από οδηγία του Υπουργείου Εργασίας.'),
                Text('\nΘέλετε να τον επεξεργαστείτε;'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ΑΚΥΡΟ'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('ΕΠΕΞΕΡΓΑΣΙΑ'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    if (allowEdit ?? false) {
      setState(() => _canEditSmsNumber = true);
      FocusScope.of(context).requestFocus(_smsNumberFocus);
    }
  }
}
