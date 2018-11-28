import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:flutter/material.dart';

TimeOfDay addToTimeOfDay(TimeOfDay timeOfDay, {int hour = 0, int minute = 0}) =>
    minutesToTime(hoursMinsToMinutes(hour, minute) + timeToMinutes(timeOfDay));

TimeOfDay minutesToTime(int minutes) =>
    TimeOfDay(hour: (minutes ~/ 60) % 24, minute: minutes % 60);

int timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;
int hoursMinsToMinutes(int hours, int minutes) => hours * 60 + minutes;

// checks if timeA is later that timeB
bool isLater(TimeOfDay timeA, TimeOfDay timeB) =>
    timeToMinutes(timeA) > timeToMinutes(timeB);

String timeToString(TimeOfDay timeOfDay){
  return timeOfDay.toString().replaceAll(RegExp(r'[^{0-9}:]'), '');
}

String e8Parser(
    {Employer employer, Employee employee, TimeOfDay start, TimeOfDay finish}) {
  RegExp exp = RegExp(r'[^{0-9}]');
  String overTime = start.toString().replaceAll(exp, '') +
      finish.toString().replaceAll(exp, '');

  List<String> e8Data = [
    'Υ1',
    employer.afm + (employer.ame ?? ''),
    employee.vatNumber,
    overTime
  ];
  return e8Data.join(" ");
}

bool isNotNull(value) => value != null;

void sendSms({@required message, @required number}) {
  print('$message send to $number');
}

validateAfm(String afm) {
  if (afm.isEmpty) {
    return 'Προσθέστε ΑΦΜ';
  } else if (!isValid(afm, RegExp(r'^[0-9]+$')) || afm.length != 9) {
    return 'Ο ΑΦΜ αποτελείται απο 9 αριθμούς';
  }
}

bool isValid(String value, RegExp regex) {
  return regex
      .allMatches(value)
      .map((match) => match.start == 0 && match.end == value.length)
      .reduce((sum, nextValue) => sum && nextValue);
}
