import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class Employee {
  String _firstName, _lastName, _vatNumber;
  TimeOfDay _hourToStart;
  int _id;

  Employee(this._firstName, this._lastName, this._vatNumber,
      [this._hourToStart]);

  Employee.withID(this._id, this._firstName, this._lastName, this._vatNumber,
      this._hourToStart);

  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get vatNumber => this._vatNumber;
  TimeOfDay get hourToStart => this._hourToStart;
  int get id => this._id;

  set firstName(String firstName) {
    if (firstName.length >= 3) this._firstName = firstName.trim();
  }

  set lastName(String lastName) {
    if (lastName.length >= 3) this._lastName = lastName.trim();
  }

// TODO: check if duplicate
  set vatNumber(String vatNumber) {
    if (vatNumber.length == 9) {
      this._vatNumber = vatNumber;
    }
  }

  set hourToStart(TimeOfDay hourToStart) {
    final int upperLimit = 1410; // 23:30
    if (timeToMinutes(hourToStart) < upperLimit) {
      this._hourToStart = hourToStart;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) map['id'] = this._id;
    map['firstName'] = this._firstName;
    map['lastName'] = this._lastName;
    map['vatNumber'] = this._vatNumber;
    map['hourToStart'] = this._hourToStart;

    return map;
  }

  Employee.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._firstName = map['firstName'];
    this._lastName = map['lastName'];
    this._vatNumber = map['vatNumber'];
    this._hourToStart = map['hourToStart'];
  }
}
