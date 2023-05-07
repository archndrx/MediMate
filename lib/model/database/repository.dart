import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  static Database _database;

  //init database
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initializeDb();
    return _database;
  }

  //init table db
  final String _tableName = 'pills';
  Future<Database> _initializeDb() async {
    var db = await openDatabase(
      join(await getDatabasesPath(), 'pills.db'),
      onCreate: (db, version) async {
        await db.execute(
            '''CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, name TEXT, amount TEXT, type TEXT, medicineForm TEXT, time INTEGER, notifyId INTEGER);''');
      },
      version: 1,
    );
    return db;
  }

  //insert something to database
  Future<int> insertData(Map<String, dynamic> data) async {
    Database db = await database;
    try {
      return await db?.insert(_tableName, data);
    } catch (e) {
      return null;
    }
  }

  //get all data from database
  Future<List<Map<String, dynamic>>> getAllData(_tableName) async {
    Database db = await database;
    try {
      return db?.query(_tableName);
    } catch (e) {
      return null;
    }
  }

  //delete data
  Future<int> deleteData(int id) async {
    Database db = await database;
    try {
      return await db?.delete(_tableName, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      return null;
    }
  }
}
