import 'package:ergani_e8/components/buttons/cancel_max_width.dart';
import 'package:ergani_e8/components/buttons/submit_max_width.dart';
import 'package:ergani_e8/models/employer.dart';
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
  var _canEditSmsNumber = false;

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
    _receiverController.text =
        _employer?.smsNumber ?? '54001'; //TODO: Add receiver number to Employer

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
      body: Center(
        child: Form(
          key: _formKey,
          child: Stack(
            // alignment: Alignment(-1, -1),
            // fit: StackFit.loose,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListView(
                // shrinkWrap: true,
                children: <Widget>[
                  _buildNameField(),
                  _buildAfmField(),
                  Divider(),
                  _buildAmeField(),
                  _buildSmsNumberField(context),
                ],
              ),
              // SizedBox(height: 150,),
              Positioned(
                // bottom: 0.1,
                              child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SubmitButtonMaxWidth(onSubmit: () => print('hi')),
                      CancelButtonMaxWidth(),
                    ],
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildNameField() {
    return ListTile(
      title: TextFormField(
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
    );
  }

  _buildAfmField() {
    return ListTile(
      title: TextFormField(
        decoration: InputDecoration(labelText: 'ΑΦΜ'),
        keyboardType: TextInputType.number,
        textInputAction: _hasAme ? TextInputAction.next : TextInputAction.done,
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
    );
  }

  _buildAmeField() {
    return ListTile(
        // mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.center,

        // mainAxisAlignment: MainAxisAlignment.center,

        leading: Checkbox(
          value: _hasAme,
          onChanged: (val) => setState(() {
                _hasAme = val;
                // if(!_hasAme) _ameController.text = '';
              }),
        ),
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text('AME', style: TextStyle(fontSize: 16.0)),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hasFloatingPlaceholder: false,
                contentPadding: EdgeInsets.only(bottom: 5.0, top: 20.0),
              ),
              style: TextStyle(
                  color: _hasAme ? Colors.grey[900] : Colors.grey[300]),
              enabled: _hasAme,
              keyboardType: TextInputType.number,
              textInputAction: _canEditSmsNumber
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
        ]));
  }

  _buildSmsNumberField(BuildContext context) {
    return ListTile(
        // mainAxisSize: MainAxisSize.min,
        // children: <Widget>[
        leading: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            'Αποστολή SMS στο:',
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
                      fontSize: 24.0,
                      color: Colors.grey[900],
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    enabled: false,
                    focusNode: _receiverFocus,
                    controller: _receiverController,
                    validator: (number) {
                      if (number.isEmpty)
                        return 'Προσθέστε αριθμό παραλήπτη';
                      else
                        return int.tryParse(number) ?? 'Εισάγετε μόνο αριθμούς';
                    },
                  ),
                ),
              ],
            ),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: _canEditSmsNumber
                    ? null
                    : () => _handleEditSmsNumber(context)
                // onPressed: () => _employer?.smsNumber == '54001'
                //     ? _handleEditSmsNumber(context)
                //     : setState(() => _isReceiverEditable = true),
                ),
          ],
        ));
  }

  _handleEditSmsNumber(BuildContext context) async {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');

    final allowEdit = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Επεξεργασία αριθμού;'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Ο αριθμός 54001 ορίζεται από οδηγία του υπουργείου Εργασίας.'),
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
    if (allowEdit != null) {
      setState(() => _canEditSmsNumber = true);
      FocusScope.of(context).requestFocus(_receiverFocus);
    }
  }
}
