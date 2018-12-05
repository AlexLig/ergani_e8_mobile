import 'package:flutter/material.dart';

int getIntLength(int number) => number.abs().toString().length;
bool isInt(String val) => int.tryParse(val) != null;
bool hasOnlyInt(String val) => val.split('').every(isInt);

validateNumericInput(
    {@required String input, @required String label, @required int length}) {
  if (input.isEmpty) {
    return 'Προσθέστε $label';
  } else if (input.length != length) {
    return 'Προσθέστε $length αριθμούς';
  } else if (!hasOnlyInt(input)) {
    return 'Ο $label αποτελείται μόνο απο αριθμούς';
  }
}

bool isNotValidInt(String value, int length) {
  return int.tryParse(value) == null || value.length != length;
}
