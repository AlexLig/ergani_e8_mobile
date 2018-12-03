import 'package:flutter/material.dart';

class AfmFormField extends StatelessWidget {
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final InputBorder border;
  final bool autovalidate;
  final Function validator;
  final Function onFieldSubmited;


  AfmFormField({@required this.focusNode, this.textInputAction, this.border, @required this.autovalidate, @required this.controller, @required this.validator, @required this.onFieldSubmited, });
  @override
  TextFormField build(BuildContext context) {
    return TextFormField(
        keyboardType: TextInputType.number,
        focusNode: focusNode,
        textInputAction: textInputAction,
        decoration: InputDecoration(

          labelText: 'ΑΦΜ',
          border: border, //
          prefixIcon: Icon(Icons.work),
        ),
        // validator: (afm) {
        //   if (afm.isEmpty) {
        //     return 'Προσθέστε ΑΦΜ';
        //   } else if (afm.length != 9) {
        //     return 'Εισάγετε 9 αριθμούς';
        //   } else if (int.tryParse(afm) == null ||
        //       getIntLength(int.tryParse(afm)) != 9) {
        //     return ' Ο ΑΦΜ αποτελείται ΜΟΝΟ απο αριθμούς';
        //   }
        // },
        validator: (value) => validator(value),
        autovalidate: autovalidate,
        maxLength: 9,
        controller: controller,
        onFieldSubmitted: (value) => onFieldSubmited(value),
        );
  }
}
