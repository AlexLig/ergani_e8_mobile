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

  set firstName(String firstName) => this._firstName = firstName.trim();
  set lastName(String lastName) => this._lastName = lastName.trim();
  set afm(String afm) => this._afm = afm;
  set workStart(TimeOfDay workStart) => this._workStart = workStart;
  set workFinish(TimeOfDay workFinish) => this._workFinish = workFinish;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) map['id'] = this._id;
    map['first_name'] = this._firstName;
    map['last_name'] = this._lastName;
    map['afm'] = this._afm;
    map['work_start'] = timeToString(this._workStart);
    map['work_finish'] = timeToString(this._workFinish);
    return map;
  }
}
