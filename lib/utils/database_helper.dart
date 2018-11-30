import 'package:ergani_e8/models/employee.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton db helper.
  static Database _database; // Singleton database.

  String employeesTable = 'employees_table';
  String colId = 'id';
  String colFirstName = 'first_name';
  String colLastName = 'last_name';
  String colAfm = 'afm';
  String colWorkStart = 'work_start';
  String colWorkFinish = 'work_finish';

  DatabaseHelper._createInstance(); // Named constrcutor to create instance.

  factory DatabaseHelper() {
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance(); // On app launch.

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'ergani.db');

    var erganiDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return erganiDatabase;
  }

  /// On db creation, create the table of employees.
  void _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $employeesTable (
      $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $colFirstName TEXT NOT NULL, 
      $colLastName TEXT NOT NULL, 
      $colAfm TEXT NOT NULL UNIQUE, 
      $colWorkStart TEXT, 
      $colWorkFinish TEXT NOT NULL
    )
    '''); // UNIQUE: throws error if duplicate
  }

  /// Read operation. Returns a List of all Employees in the database.
  Future<List<Employee>> getEmployeeList() async {
    var employeeMapList = await _getEmployeeMapList();

    var list =
        employeeMapList.map((mapObj) => Employee.fromMap(mapObj)).toList();
    print('Formatted list: $list');
    return list;
  }

  /// Retrieve all entries in employeesTable as a List of Maps.
  Future<List<Map<String, dynamic>>> _getEmployeeMapList() async {
    Database db = await this.database;

    var result = await db
        .rawQuery('SELECT * FROM $employeesTable ORDER BY $colLastName ASC');

    print('retrieved $result');
    return result;
  }

  /// Create operation. Post an Employee in the database.
  Future<int> createEmployee(Employee employee) async {
    Database db = await this.database;
    Map<String, dynamic> map = employee.toMap();

    // var result = await db.transaction((txn) async {
    //   int employeeID = await txn.rawInsert(
    //       'INSERT INTO $employeesTable ($colFirstName, $colLastName, $colAfm, $colWorkStart, $colWorkFinish)VALUES(?, ?, ?, ?, ?)',
    //       [
    //         map['firstName'],
    //         map['lastName'],
    //         map['afm'],
    //         map['workStart'],
    //         map['workFinish']
    //       ]);
    //   print('employee ID: $employeeID');
    // });
    var result = await db.rawInsert(
          'INSERT INTO $employeesTable ($colFirstName, $colLastName, $colAfm, $colWorkStart, $colWorkFinish)VALUES(?, ?, ?, ?, ?)',
          [
            map['firstName'],
            map['lastName'],
            map['afm'],
            map['workStart'],
            map['workFinish']
          ]);
      // print('employee ID: $employeeID');

    print('inserted $result');
    return result;
  }

  /// Update opration. Modifiy an Employee in the database.
  Future<int> updateEmployee(Employee employee) async {
    Database db = await this.database;
    Map<String, dynamic> map = employee.toMap();

    var result = await db.rawUpdate('''
      UPDATE $employeesTable
      SET $colFirstName = ${map['firstName']},
          $colLastName = ${map['lastName']},
          $colAfm = ${map['afm']},
          $colWorkStart = ${map['workStart']},
          $colWorkFinish = ${map['workFinish']}
      WHERE $colId = ${map['id']}
    ''');

    print('Updated $result');
    return result;
  }

  /// Delete operation. Delete an Employee from the database.
  Future<int> deleteEmployee(Employee employee) async {
    Database db = await this.database;
    Map<String, dynamic> map = employee.toMap();

    var result = await db.rawDelete('''
      DELETE
      FROM
        $employeesTable
      WHERE
       $colId = ${map['id']}
    ''');

    print('deleted $result');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;

    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) from $employeesTable'));
  }
}
