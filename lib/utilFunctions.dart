import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:flutter/material.dart';

// BUG when exceeding 24 hours
TimeOfDay addToTimeOfDay(TimeOfDay timeOfDay, {int hour = 0, int minute = 0}) {
  int newMins = (minute + timeOfDay.minute) % 60;
  int addedHours = (minute + timeOfDay.minute) ~/ 60;
  int tempAddedHours = hour + addedHours + timeOfDay.hour;
  int newHours;
  if (tempAddedHours ~/ 24 > 0) {
    newHours = tempAddedHours ~/ 24;
  } else {
    newHours = tempAddedHours;
  }
  return TimeOfDay(hour: newHours, minute: newMins);
}

// checks if timeA is later that timeB
bool isLater(TimeOfDay timeA, TimeOfDay timeB) {
  int hourA = timeA.hour;
  int hourB = timeB.hour;
  int minutesA = timeA.minute;
  int minutesB = timeB.minute;

  return hourA > hourB || (hourA == hourB && minutesA > minutesB);
}

String e8Parser(
    {Employer employer, Employee employee, TimeOfDay start, TimeOfDay finish}) {
  String employerVat = employer.vatNumberAME == null
      ? employer.vatNumberAFM.trim()
      : employer.vatNumberAFM.trim() + employer.vatNumberAME.trim();
  String employeeVat = employee.vatNumber.trim();
  RegExp exp = RegExp(r'[^{0-9}]');
  String overTime = start.toString().replaceAll(exp, '') +
      finish.toString().replaceAll(exp, '');

  List<String> e8Data = ['Υ1', employerVat, employeeVat, overTime];
  return e8Data.join(" ");
}

bool isNotNull(value) => value != null;
