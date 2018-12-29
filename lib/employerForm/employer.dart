import 'package:ergani_e8/components/buttons/cancel_max_width.dart';
import 'package:ergani_e8/components/buttons/submit_max_width.dart';
import 'package:ergani_e8/components/info_tile.dart';
import 'package:ergani_e8/employerForm/employer_bloc.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utils/database_helper.dart';
import 'package:ergani_e8/utils/input_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployerForm extends StatelessWidget {
  final employerBloc = EmployerBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    nameField(),
                    afmField(),
                    // _buildAmeTile(),
                    smsReceiverField(context),
                    infoTile(),
                  ].where((val) => val != null).toList(),
                ),
              ),
              // SubmitButtonMaxWidth(onSubmit: () => submit(context)),
            ],
          ),
        ),
      ),
    );
  }

  nameField() {
    return StreamBuilder(
      stream: employerBloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        ListTile(
          title: TextField(
            onChanged: employerBloc.updateName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Όνομα Εργοδότη',
                prefixIcon: Icon(Icons.person),
                errorText: snapshot.error),
          ),
        );
      },
    );
  }

  afmField() {
    return StreamBuilder(
      stream: employerBloc.afmStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        ListTile(
          title: TextField(
            onChanged: employerBloc.updateAfm,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'ΑΦΜ',
                prefixIcon: Icon(Icons.work),
                errorText: snapshot.error),
          ),
        );
      },
    );
  }

  // _buildAmeTile() {

  //   return ListTile(
  //       leading: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Checkbox(
  //             value: _hasAme,
  //             onChanged: (val) {
  //               setState(() => _hasAme = val);
  //               if (!_hasAme) _ameController.clear();
  //             },
  //           ),
  //           Text('AME',
  //               style: TextStyle(
  //                   fontSize: 16.0,
  //                   color: _hasAme ? Colors.grey[900] : Colors.grey))
  //         ],
  //       ),
  //       title: _buildAmeField());
  // }

  // _buildAmeField() {
  //   final length = 10;
  //   return TextFormField(
  //     keyboardType: TextInputType.number, //
  //     validator: (ame) {
  //       if (_hasAme)
  //         return validateNumericInput(input: ame, length: length, label: 'ΑΜΕ');
  //     },
  //     autovalidate: _shouldValidateOnChangeAme, //
  //     onFieldSubmitted: (value) {
  //       if (isNotValidInt(value, length))
  //         setState(() => _shouldValidateOnChangeAme = true);
  //       else if (_canEditSmsNumber)
  //         FocusScope.of(context).requestFocus(_smsNumberFocus);
  //     },
  //     decoration: InputDecoration(
  //       hasFloatingPlaceholder: false,
  //       contentPadding: EdgeInsets.only(bottom: 5.0, top: 20.0),
  //     ),
  //     style: TextStyle(color: _hasAme ? Colors.grey[900] : Colors.grey[300]),
  //     enabled: _hasAme,
  //     textInputAction:
  //         _canEditSmsNumber ? TextInputAction.next : TextInputAction.done,
  //     focusNode: _ameFocus,
  //     controller: _ameController,
  //     maxLength: length,
  //   );
  // }

  smsReceiverField(BuildContext context) {
    return StreamBuilder(
      stream: employerBloc.smsReceiverStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              'Παραλήπτης SMS:',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          title: Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: null,
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    // enabled: _canEditSmsNumber,
                    // focusNode: _smsNumberFocus,
                    decoration: InputDecoration(
                        // suffixIcon: !_canEditSmsNumber
                        //     ? Icon(Icons.edit, color: Colors.grey[900])
                        //     : null,
                        ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // _handleEditSmsNumber(BuildContext context) async {
  //   final bool allowEdit = await showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Επεξεργασία αριθμού;'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(
  //                   'Ο αριθμός 54001 ορίζεται από οδηγία του Υπουργείου Εργασίας.'),
  //               Text('\nΘέλετε να τον επεξεργαστείτε;'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('ΑΚΥΡΟ'),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //           FlatButton(
  //             child: Text('ΕΠΕΞΕΡΓΑΣΙΑ'),
  //             onPressed: () => Navigator.pop(context, true),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //   if (allowEdit ?? false) {
  //     setState(() => _canEditSmsNumber = true);
  //     FocusScope.of(context).requestFocus(_smsNumberFocus);
  //   }
  // }

  infoTile() => InfoTile(
        text:
            'Για την υποβολή Ε8 με SMS, η αποστολή μηνύματος γίνεται στον αριθμό 54001.',
      );
}
