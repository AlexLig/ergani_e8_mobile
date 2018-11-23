import 'package:flutter/material.dart';

class VatNumbers {
  String afmEmployer;
  String ameEmployer;
  String afmEmployee;

  VatNumbers({
    @required this.afmEmployee,
    @required this.afmEmployer,
    this.ameEmployer,
  }): assert(afmEmployee != null),
      assert(afmEmployer != null);
}