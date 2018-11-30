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

String timeToString(TimeOfDay timeOfDay) {
  return timeOfDay.toString().replaceAll(RegExp(r'[^{0-9}:]'), '');
}



String e8Parser(
    {Employer employer, Employee employee, TimeOfDay start, TimeOfDay finish}) {
  List<String> e8Data = [
    'Υ1',
    employer.afm + (employer.ame ?? ''),
    employee.afm,
    timeToNumericString(start) + timeToNumericString(finish)
  ];
  return e8Data.join(" ");
}

String timeToNumericString(TimeOfDay timeOfDay) {
  return timeOfDay.toString().replaceAll(RegExp(r'[^{0-9}]'), '');
}
TimeOfDay numericStringToTime(String timeString) {
  if (timeString.length > 4) return TimeOfDay(hour: 00, minute: 00);
  int hour = int.tryParse(timeString.substring(0, 2)) ?? 00;
  int minute = int.tryParse(timeString.substring(2)) ?? 00;
  return TimeOfDay(hour: hour, minute: minute);
}

bool isNotNull(value) => value != null;

void sendSms({@required message, @required number}) {
  print('$message send to $number');
}

validateAfm(String afm) => _validateVatNumber(afm, 9);
validateAme(String ame) => _validateVatNumber(ame, 10);
_validateVatNumber(String vatNumber, int length) {
  if (vatNumber.isEmpty) {
    return 'Προσθέστε ${length == 9 ? 'ΑΦΜ' : 'ΑΜΕ'}';
  } else if (isNotNumeric(vatNumber) || vatNumber.length != length) {
    return 'O ${length == 9 ? 'ΑΦΜ' : 'ΑΜΕ'} αποτελείται από $length αριθμούς';
  }
}

bool isNumeric(String value) => _isFullMatch(RegExp(r'[0-9]'), value);
bool isNotNumeric(String value) => _isFullMatch(RegExp(r'[^{0-9}]'), value);
bool _isFullMatch(RegExp regExp, String value) => regExp
    .allMatches(value)
    .map((match) => match.start == 0 && match.end == value.length)
    .reduce((sum, nextValue) => sum && nextValue);

/// Experimenting with currying
// var isNotNumeric = _isFullMatch(RegExp(r'[^{0-9}]'));
// var isNumeric = _isFullMatch(RegExp(r'[0-9]'));

// Function _isFullMatch(RegExp regExp) => (String value) => regExp
//     .allMatches(value)
//     .map((match) => match.start == 0 && match.end == value.length)
//     .reduce((sum, nextValue) => sum && nextValue);
