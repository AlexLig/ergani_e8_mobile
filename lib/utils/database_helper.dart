import 'package:ergani_e8/models/employee.dart';
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

  /// Create operation. Post an Employee in the database.
  Future<int> createEmployee(Employee employee) async {
    Database db = await this.db;
    Map<String, dynamic> map = employee.toMap();

    var result = await db.transaction((txn) async {
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
  }

  /*  /// Update opration. Modifiy an Employee in the database.
  Future<int> updateEmployee(Employee employee) async {
    Database db = await this.db;
    Map<String, dynamic> map = employee.toMap();

    var result = await db.rawUpdate('''
      UPDATE $employeeTable
      SET $colFirstName = ${map['first_name']},
          $colLastName = ${map['last_name']},
          $colAfm = ${map['afm']},
          $colWorkStart = ${map['work_start']},
          $colWorkFinish = ${map['work_finish']},
      WHERE $colId = ${map['id']}
    ''');
    print('Updated $result');
    return result;
  } */

  /// Create operation. Post an Employee in the database.
  Future<int> updateEmployee(Employee employee) async {
    Database db = await this.db;
    var result = await db.transaction((txn) async {
      await deleteEmployee(employee);
      await createEmployee(employee);
    });

    return result;
  }

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

//TODO: validations b4 writing into db. 1) upper limit for work time 2) afm lenght
}
