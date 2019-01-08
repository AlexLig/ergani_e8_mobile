import 'dart:async';

import 'package:ergani_e8/static/errors.dart';
import 'package:ergani_e8/utils/input_utils.dart';

typedef bool EqualityTest(int length);

var emailValidationRule =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class ValidatorBloc {
  final validateNumeric = StreamTransformer<String, String>.fromHandlers(
    handleData: (val, sink) =>
        hasOnlyInt(val) ? sink.add(val) : sink.addError(nanErrorMsg),
  );

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) => RegExp(emailValidationRule).hasMatch(email)
        ? sink.add(email)
        : sink.addError(emailErrorMsg),
  );

  final validateIsEmpty = StreamTransformer<String, String>.fromHandlers(
      handleData: (value, sink) => value.length > 0
          ? sink.add(value)
          : sink.addError(emptyFieldErrorMsg));

  final validateLength = (EqualityTest check,
          [String errorMessage = invalidLengthMsg]) =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (value, sink) => check(value.length)
            ? sink.add(value)
            : sink.addError(errorMessage),
      );
}
