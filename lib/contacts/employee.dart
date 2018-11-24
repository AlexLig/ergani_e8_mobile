import 'package:flutter/material.dart';

class Employee {
  final String firstName, lastName, vatNumber;
  final TimeOfDay hourToStart;
  const Employee({
    this.hourToStart,
    @required this.firstName,
    @required this.lastName,
    @required this.vatNumber,
  })  : assert(firstName != null),
        assert(lastName != null),
        assert(vatNumber != null);

  get (firstName) => this.firstName;
}
