import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';

class Employee {
  String _firstName, _lastName, _afm;
  TimeOfDay _workStart, _workFinish;
  int _id;

  Employee(this._firstName, this._lastName, this._afm,
      [this._workStart, this._workFinish]);

  ///Named constructor
  Employee.withID(this._id, this._firstName, this._lastName, this._afm,
      this._workStart, this._workFinish);

  ///Named constructor. Returns a new Employee from sqflite Map.
  Employee.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._firstName = map['first_name'];
    this._lastName = map['last_name'];
    this._afm = map['afm'];
    this._workStart = stringToTime(map['work_start']);
    this._workFinish = stringToTime(map['work_finish']);
  }

  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get afm => this._afm;
  TimeOfDay get workStart => this._workStart;
  TimeOfDay get workFinish => this._workFinish;
  int get id => this._id;

  set firstName(String firstName) {
    if (firstName.length >= 3) this._firstName = firstName.trim();
  }

  set lastName(String lastName) {
    if (lastName.length >= 3) this._lastName = lastName.trim();
  }

// TODO: check if duplicate
  set afm(String afm) {
    if (afm.length == 9) {
      this._afm = afm;
    }
  }

  set workStart(TimeOfDay workStart) {
    final int upperLimit = 1410; // 23:30
    if (timeToMinutes(workStart) < upperLimit) {
      this._workStart = workStart;
    }
  }

  set workFinish(TimeOfDay workFinish) {
    final int upperLimit = 1410; // 23:30
    if (timeToMinutes(workFinish) < upperLimit) {
      this._workFinish = workFinish;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) map['id'] = this._id;
    map['firstName'] = this._firstName;
    map['lastName'] = this._lastName;
    map['afm'] = this._afm;
    map['workStart'] = timeToString(this._workStart);
    // '${this._workStart.hour}${this._workStart.minute}'
    // TODO: Replace with proper formatting.
    map['workFinish'] = timeToString(this._workFinish);
    //'${this._workFinish.hour}${this._workFinish.minute}';

    return map;
  }
}
