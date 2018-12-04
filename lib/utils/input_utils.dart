import 'package:flutter/material.dart';

int getIntLength(int number) => number.abs().toString().length;
bool isNotNullInt(String val) => int.tryParse(val) != null;

validateNumericInput(
    {@required String numValue, @required String label, @required int length}) {
  if (numValue.isEmpty) {
    return 'Προσθέστε $label';
  } else if (numValue.length != length) {
    return 'Προσθέστε $length αριθμούς';
  } else if (!numValue.split('').every(isNotNullInt)) {
    return 'Ο $label αποτελείται μόνο απο αριθμούς';
  }
}

bool isNotValidInt(String value, int length) {
  return int.tryParse(value) == null || value.length != length;
}
