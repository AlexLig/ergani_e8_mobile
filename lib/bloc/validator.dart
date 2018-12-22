import 'dart:async';

import 'package:ergani_e8/utils/input_utils.dart';

var nanErrorMsg = 'Προσθέστε μόνο αριθμούς';
var emailErrorMsg = 'Προσθέστε έγκυρο email';

var emailValidationRule =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class Validator {
  final validateNumeric = StreamTransformer<String, String>.fromHandlers(
    handleData: (val, sink) =>
        hasOnlyInt(val) ? sink.add(val) : sink.addError(nanErrorMsg),
  );

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) => RegExp(emailValidationRule).hasMatch(email)
        ? sink.add(email)
        : sink.addError(emailErrorMsg),
  );
}
