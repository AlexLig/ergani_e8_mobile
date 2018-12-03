
import 'package:flutter/material.dart';

int getIntLength(int number) => number.abs().toString().length;

validateNumericInput({@required String numValue, @required String label, @required int length}){
    if (numValue.isEmpty) {
    return 'Προσθέστε $label';
  } else if (numValue.length != length) {
    return 'Προσθέστε $length αριθμούς';
  } else if (int.tryParse(numValue) == null ||
            getIntLength(int.tryParse(numValue)) != length) {
    return 'Ο $label αποτελείται μόνο απο αριθμούς';
  }
}

bool isNotValidInt(String value, int length){
  return int.tryParse(value) == null || value.length != length;
}