import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:flutter/material.dart';

// BUG when exceeding 24 hours
TimeOfDay addToTimeOfDay(TimeOfDay timeOfDay, {int hour = 0, int minute = 0}) =>
    minutesToTime(hoursMinsToMinutes(hour, minute) + timeToMinutes(timeOfDay));

TimeOfDay minutesToTime(int minutes) =>
    TimeOfDay(hour: (minutes ~/ 60) % 24, minute: minutes % 60);

int timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;
int hoursMinsToMinutes(int hours, int minutes) => hours * 60 + minutes;

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

void sendSms({@required message, @required number}) {
  print('$message send to $number');
}
