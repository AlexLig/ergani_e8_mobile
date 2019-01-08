import 'package:ergani_e8/components/info_tile.dart';
import 'package:ergani_e8/employee_form/stream_text_field.dart';
import 'package:ergani_e8/employer_form/employer_bloc.dart';
import 'package:ergani_e8/employer_form/name_field.dart';

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
                    afmField(),
                    buildAmeTile(),
                    smsReceiverField(),
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

  afmField() {
    return StreamBuilder(
      stream: employerBloc.afmStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListTile(
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

  buildAmeTile() {
    return StreamBuilder(
      initialData: [true, '666'],
      stream: employerBloc.ameCombined,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Checkbox(
                  value: snapshot.data[0],
                  onChanged: employerBloc.updateHasAme),
              Text('AME',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: snapshot.data[0] ? Colors.grey[900] : Colors.grey))
            ],
          ),
          title: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              contentPadding: EdgeInsets.only(bottom: 5.0, top: 20.0),
            ),
            style: TextStyle(
                color: snapshot.data[0] ? Colors.grey[900] : Colors.grey[300]),
            enabled: snapshot.data[0],
          ),
        );
      },
    );
  }

  Widget smsReceiverField() {
    return StreamTextField(
      subjectStream: employerBloc.smsReceiverStream,
      subjectSink: employerBloc.updateSmsReceiver,
      labelText: 'Αριθμός αποστολής μηνύματος',
    );
  }

  // smsReceiverField() {
  //   return StreamBuilder(
  //     initialData: '54002',
  //     stream: employerBloc.smsReceiverStream,
  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //       return ListTile(
  //         leading: Padding(
  //           padding: const EdgeInsets.only(right: 8.0),
  //           child: Text(
  //             'Παραλήπτης SMS:',
  //             style: TextStyle(fontSize: 16.0),
  //           ),
  //         ),
  //         title: Row(
  //           children: <Widget>[
  //             Expanded(
  //               child: InkWell(
  //                 onTap: null,
  //                 child: TextField(
  //                   style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
  //                   keyboardType: TextInputType.number,
  //                   textInputAction: TextInputAction.done,
  //                   onChanged: employerBloc.updateSmsReceiver,
  //                   // initialValue: snapshot.data,

  //                   // enabled: _canEditSmsNumber,
  //                   // focusNode: _smsNumberFocus,
  //                   // decoration: InputDecoration(
  //                   // suffixIcon: !_canEditSmsNumber
  //                   //     ? Icon(Icons.edit, color: Colors.grey[900])
  //                   //     : null,
  //                   // ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
