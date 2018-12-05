import 'package:ergani_e8/components/buttons/cancel_max_width.dart';
import 'package:ergani_e8/components/buttons/submit_max_width.dart';
import 'package:ergani_e8/components/info_tile.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utils/database_helper.dart';
import 'package:ergani_e8/utils/input_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateNewEmployer extends StatefulWidget {
  final Employer employer;

  const CreateNewEmployer({BuildContext context, Key key, this.employer})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => UpdateEmployerState();
}

class UpdateEmployerState extends State<CreateNewEmployer> {
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
    if (_employer != null) {
      _nameController.text = _employer.name;
      _afmController.text = _employer.afm;
      _ameController.text = _employer.ame ?? '';
      _smsNumberController.text = _employer.smsNumber ?? '54001';
      _hasAme = _ameController.text.isNotEmpty ? true : false;
    } else {
      _hasAme = false;
      _smsNumberController.text = '54001';
    }

    _canEditSmsNumber = _smsNumberController.text != '54001';
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
        result = await _erganiDatabase.createEmployer(employerToSubmit);
        if (result != 0)
          result = await _erganiDatabase.deleteEmployer(_employer);
      }

      if (result != 0) {
        Navigator.pop(context, employerToSubmit);
      } else
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Σφάλμα αποθήκευσης'),
        ));

      _nameController.clear();
      _afmController.clear();
      _ameController.clear();
      _smsNumberController.clear();

      // Navigator.pop(context, employerToSubmit);
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
                    // SizedBox(height: 20.0,),
                    _buildAmeTile(),
                    _buildSmsNumberField(context),
                    /* !_canEditSmsNumber ? null : */ _buildInfoTile(),
                  ].where((val) => val != null).toList(),
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
    final length = 9;
    return ListTile(
      title: TextFormField(
        keyboardType: TextInputType.number,
        focusNode: _afmFocus,
        textInputAction: _hasAme ? TextInputAction.next : TextInputAction.done,
        decoration: InputDecoration(
          labelText: 'ΑΦΜ',
          // border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.work),
        ),
        validator: (afm) =>
            validateNumericInput(input: afm, length: length, label: 'ΑΦΜ'),
        autovalidate: _shouldValidateOnChangeAfm,
        maxLength: length,
        onFieldSubmitted: (value) {
          if (isNotValidInt(value, length))
            setState(() => _shouldValidateOnChangeAfm = true);
          else if (_hasAme) FocusScope.of(context).requestFocus(_ameFocus);
        },
        controller: _afmController,
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
              onChanged: (val) {
                setState(() => _hasAme = val);
                if (!_hasAme) _ameController.clear();
              },
            ),
            Text('AME',
                style: TextStyle(
                    fontSize: 16.0,
                    color: _hasAme ? Colors.grey[900] : Colors.grey))
          ],
        ),
        title: _buildAmeField());
  }

  _buildAmeField() {
    final length = 10;
    return TextFormField(
      keyboardType: TextInputType.number, //
      validator: (ame) {
        if (_hasAme)
          return validateNumericInput(input: ame, length: length, label: 'ΑΜΕ');
      },
      autovalidate: _shouldValidateOnChangeAme, //
      onFieldSubmitted: (value) {
        if (isNotValidInt(value, length))
          setState(() => _shouldValidateOnChangeAme = true);
        else if (_canEditSmsNumber)
          FocusScope.of(context).requestFocus(_smsNumberFocus);
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
      maxLength: length,
    );
  }

  _buildSmsNumberField(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text(
          'Παραλήπτης SMS:',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      title: Stack(
        alignment: Alignment(1.1, 1.0),
        children: [
          Row(
            children: <Widget>[
              SizedBox(width: 90.0),
              Expanded(
                child: TextFormField(
                  style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  enabled: _canEditSmsNumber,
                  focusNode: _smsNumberFocus,
                  controller: _smsNumberController,
                  validator: (number) {
                    if (number.isEmpty)
                      return 'Προσθέστε αριθμό παραλήπτη';
                    else if (!hasOnlyInt(number))
                      return 'Εισάγετε μόνο αριθμούς';
                  },
                ),
              ),
            ],
          ),
          !_canEditSmsNumber
              ? IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey[900]),
                  onPressed: () => _handleEditSmsNumber(context)
                  // onPressed: () => _employer?.smsNumber == '54001'
                  //     ? _handleEditSmsNumber(context)
                  //     : setState(() => _isReceiverEditable = true),
                  )
              : null,
        ].where((val) => val != null).toList(),
      ),
    );
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

  _buildInfoTile() {
    return InfoTile(
      text:
          'Για την υποβολή Ε8 με SMS, η αποστολή μηνύματος γίνεται στον αριθμό 54001.',
    );
  }
}
