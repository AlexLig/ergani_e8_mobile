import 'dart:async';
import 'package:ergani_e8/utils/validator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ergani_e8/static/errors.dart';

class EmployeeBloc extends Object with ValidatorBloc {
  final _firstNameSubject = BehaviorSubject<String>();
  final _lastNameSubject = BehaviorSubject<String>();
  final _afmSubject = BehaviorSubject<String>();
  final _workStartSubject = BehaviorSubject<TimeOfDay>();
  final _workFinishSubject = BehaviorSubject<TimeOfDay>();

  // First name
  Observable<String> get firstName =>
      _firstNameSubject.stream.transform(validateIsEmpty);
  Function(String) get updateFirstName => _firstNameSubject.sink.add;

  // Last name
  Observable<String> get lastName =>
      _lastNameSubject.stream.transform(validateIsEmpty);
  Function(String) get updateLastName => _lastNameSubject.sink.add;

  // Afm
  Observable<String> get afm => _afmSubject.stream
      .transform(validateNumeric)
      .debounce(Duration(milliseconds: 500))
      .transform(validateLength((length) => length == 9, exactNumberMsg(9)));
  Function(String) get updateAfm => _afmSubject.sink.add;

  // Work start
  Observable<TimeOfDay> get workStart => _workStartSubject.stream;
  Function(TimeOfDay) get updateWorkStart => _workStartSubject.sink.add;

  // Work finish
  Observable<TimeOfDay> get workFinish => _workFinishSubject.stream;
  Function(TimeOfDay) get updateWorkFinish => _workFinishSubject.sink.add;

  dispose() {
    _firstNameSubject.close();
    _lastNameSubject.close();
    _afmSubject.close();
    _workStartSubject.close();
    _workFinishSubject.close();
  }
}
