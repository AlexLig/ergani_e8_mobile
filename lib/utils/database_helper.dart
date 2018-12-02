import 'package:ergani_e8/models/employee.dart';
import 'package:ergani_e8/models/employer.dart';
import 'package:ergani_e8/utilFunctions.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ErganiDatabase {
  // Singleton db helper.
  static ErganiDatabase _erganiDatabase;
  // Singleton database.
  static Database _db;

  String employeeTable = 'employee';
  String colId = 'id';
  String colFirstName = 'first_name';
  String colLastName = 'last_name';
  String colAfm = 'afm';
  String colWorkStart = 'work_start';
  String colWorkFinish = 'work_finish';

  String employerTable = 'employer';
  String colEmployerId = 'id';
  String colEmployerName = 'name';
  String colEmployerAfm = 'afm';
  String colEmployerAme = 'ame';
  String colSmsReceiver = 'sms_number';

  /// Named constrcutor to create instance.
  ErganiDatabase._internal();

  factory ErganiDatabase() {
    if (_erganiDatabase == null)
      _erganiDatabase = ErganiDatabase._internal(); // On app launch.

    return _erganiDatabase;
  }

  /// Returns database internal instance. If null, initDB first.
  Future<Database> get db async => _db ??= await initDB();

  Future<Database> initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'ergani.db');
    var erganiDB = await openDatabase(path, version: 1, onCreate: _createDb);

    return erganiDB;
  }

  /// On db creation, create the table of employees.
  void _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $employeeTable (
      $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $colFirstName TEXT NOT NULL, 
      $colLastName TEXT NOT NULL, 
      $colAfm TEXT NOT NULL UNIQUE, 
      $colWorkStart TEXT NOT NULL, 
      $colWorkFinish TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE $employeeTable (
      $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $colEmployerName TEXT NOT NULL, 
      $colEmployerAfm TEXT NOT NULL,  
      $colEmployerAme TEXT, 
      $colSmsReceiver TEXT NOT NULL
    )
    ''');
  }

  /// Read operation. Returns a List of all Employees in the database.
  Future<List<Employee>> getEmployeeList() async {
    var employeeMapList = await _getEmployeeMapList();

    var list =
        employeeMapList.map((mapObj) => Employee.fromMap(mapObj)).toList();
    print('Formatted list: $list');
    return list;
  }

  /// Retrieve all entries in employeeTable as a List of Maps.
  Future<List<Map<String, dynamic>>> _getEmployeeMapList() async {
    Database db = await this.db;

    var result = await db
        .rawQuery('SELECT * FROM $employeeTable ORDER BY $colLastName ASC');

    print('retrieved $result');
    return result;
  }

  Future<List<Map<String, dynamic>>> getEmployeeMapListByAfm(String afm) async {
    Database db = await this.db;
    var result =
        db.rawQuery('SELECT * FROM $employeeTable WHERE $colAfm = $afm');
    return result;
  }

  /// Create operation. Post an Employee in the database.
  Future<int> createEmployee(Employee employee) async {
    var result;
    if (_validateEmployee(employee)) {
      Database db = await this.db;
      Map<String, dynamic> map = employee.toMap();

      result = await db.transaction((txn) async {
        int employeeID = await txn.rawInsert(
            'INSERT INTO $employeeTable ($colFirstName, $colLastName, $colAfm, $colWorkStart, $colWorkFinish)VALUES(?, ?, ?, ?, ?)',
            [
              map['first_name'],
              map['last_name'],
              map['afm'],
              map['work_start'],
              map['work_finish']
            ]);
        print('employee ID: $employeeID');
      });
      print('inserted $result');
      return result;
    } else
      return result = 0;
  }

  /// Update opration. Modifiy an Employee in the database.
  // Future<int> updateEmployee(Employee employee) async {
  //   Database db = await this.db;
  //   Map<String, dynamic> map = employee.toMap();
  //   var result = await db.rawInsert(
  //       'INSERT OR REPLACE INTO'
  //       '$employeeTable($colId,$colFirstName, $colLastName, $colAfm, $colWorkStart, $colWorkFinish)'
  //       ' VALUES(?, ?, ?, ?, ?, ?)',
  //       [
  //         map['id'],
  //         map['first_name'],
  //         map['last_name'],
  //         map['afm'],
  //         map['work_start'],
  //         map['work_finish']
  //       ]);

  //   return result;
  // }

  /// Delete operation. Delete an Employee from the database.
  Future<int> deleteEmployee(Employee employee) async {
    Database db = await this.db;
    Map<String, dynamic> map = employee.toMap();

    var result = await db.rawDelete('''
      DELETE
      FROM
        $employeeTable
      WHERE
       $colId = ${map['id']}
    ''');

    print('deleted $result');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;

    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) from $employeeTable'));
  }

  Future close() async => _db.close();

//TODO: validations b4 writing into db. 1) upper limit for work time 2) afm lenght
  bool _validateEmployee(Employee employee) {
    return int.tryParse(employee.afm) != null &&
        int.tryParse(employee.afm).abs().toString().length == 9 &&
        employee.firstName.length < 200 &&
        employee.lastName.length < 200 &&
        employee.workFinish is TimeOfDay &&
        employee.workStart is TimeOfDay &&
        timeToMinutes(employee.workFinish) < 1440 &&
        isLater(employee.workFinish, employee.workStart);
  }

  // Employer Table operations
  /// Read operation. Returns a List of all Employers in the database.
  Future<List<Employer>> getEmployerList() async {
    var employerMapList = await _getEmployerMapList();

    var list =
        employerMapList.map((mapObj) => Employer.fromMap(mapObj)).toList();
    print('Formatted list: $list');
    return list;
  }

  /// Retrieve all entries in employerTable as a List of Maps.
  Future<List<Map<String, dynamic>>> _getEmployerMapList() async {
    Database db = await this.db;

    var result = await db
        .rawQuery('SELECT * FROM $employerTable ORDER BY $colEmployerName ASC');

    print('retrieved $result');
    return result;
  }

  Future<List<Map<String, dynamic>>> getEmployersMapListByAfm(String afm) async {
    Database db = await this.db;
    var result = db
        .rawQuery('SELECT * FROM $employerTable WHERE $colEmployerAfm = $afm');
    return result;
  }

  Future<Employer> getNewestEmployer() async {
    Database db = await this.db;
    var mapList = await db.rawQuery(
        'SELECT * FROM $employerTable ORDER BY $colEmployerId DESC LIMIT 1');
    var list = mapList.map((mapObj) => Employer.fromMap(mapObj)).toList();

    return list.first;
  }

  /// Create operation. Post an Employee in the database.
  Future<int> createEmployer(Employer employer) async {
    var result;
    // if (_validateEmployer(employer)) {
    Database db = await this.db;
    Map<String, dynamic> map = employer.toMap();

    result = await db.transaction((txn) async {
      int employerID = await txn.rawInsert(
          'INSERT INTO $employerTable ($colEmployerName, $colEmployerAfm, $colEmployerAme, $colSmsReceiver)VALUES(?, ?, ?, ?)',
          [map['name'], map['afm'], map['ame'], map['sms_number']]);
      print('employer ID: $employerID');
    });
    print('inserted $result');
    return result;
    // } else
    //   return result = 0;
  }

  /// Delete operation. Delete an Employer from the database.
  Future<int> deleteEmployer(Employer employer) async {
    Database db = await this.db;
    Map<String, dynamic> map = employer.toMap();

    var result = await db.rawDelete('''
      DELETE
      FROM
        $employerTable
      WHERE
       $colEmployerId = ${map['id']}
    ''');

    print('deleted $result');
    return result;
  }

  Future<int> getEmployerCount() async {
    Database db = await this.db;

    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) from $employerTable'));
  }
}
