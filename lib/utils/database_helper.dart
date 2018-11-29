import 'package:ergani_e8/models/employee.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton db helper.
  static Database _database; // Singleton database.

  String employeeTable = 'employee_table';
  String colId = 'id';
  String colFirstName = 'first_name';
  String colLastName = 'last_name';
  String colAfm = 'afm';
  String colWorkStart = 'work_start';
  String colWorkFinish = 'work_finish';

  DatabaseHelper._createInstance(); // Named constrcutor to create instance.

  factory DatabaseHelper() {
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance(); // On app launches.

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
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $employeeTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colFirstName TEXT, 
        $colLastName TEXT, 
        $colAfm TEXT, 
        $colWorkStart TEXT, 
        $colWorkFinish TEXT)
    ''');
  }

  // Read
  Future<List<Map<String, dynamic>>> getEmployeeMapList() async {
    Database db = await this.database;

    var result = await db.query(employeeTable, orderBy: '$colFirstName ASC');
    return result;
  }

  // Create
  Future<int> createEmployee(Employee employee) async {
    Database db = await this.database;
    var result = db.insert(employeeTable, employee.toMap());
    return result;
  }

  // Update
  Future<int> updateEmployee(Employee employee) async {
    Database db = await this.database;
    var result = await db.update(employeeTable, employee.toMap(),
        where: '$colId = ?', whereArgs: [employee.id]);
    return result;
  }

  // Delete
  Future<int> deleteEmployee(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $employeeTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> list = await db.rawQuery('SELECT COUNT (*) from $employeeTable');
    return Sqflite.firstIntValue(list);
  }
}
