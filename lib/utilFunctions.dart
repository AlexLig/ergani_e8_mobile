

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

// String e8Parser(VatNumbers vats, TimeOfDay start, TimeOfDay finish) {
//   String employerVat = vats.ameEmployer == null
//       ? vats.afmEmployer.trim()
//       : vats.afmEmployer.trim() + vats.ameEmployer.trim();
//   String employeeVat = vats.afmEmployee.trim();
//   String startHour = start.hour.toString() + start.minute.toString();
//   String finishHour = finish.hour.toString() + finish.minute.toString();
//   List<String> e8Data = ['Υ1', employerVat, employeeVat, startHour, finishHour];
//   return e8Data.join(" ");
// }