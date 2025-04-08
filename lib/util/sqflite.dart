import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class SqfliteDB {

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'track_person.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE track_person (id TEXT PRIMARY KEY, name TEXT, lat REAL, lng REAL, address TEXT)'
        );
      },
      version: 2,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await SqfliteDB.database();
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await SqfliteDB.database();
    return db.query(table);
  }

}