import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'record.dart';

class DbHelper {
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'simple_weather.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            city TEXT NOT NULL,
            label TEXT NOT NULL,
            region TEXT NOT NULL,
            note TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertRecord(Record record) async {
    final db = await database;
    return db.insert('records', record.toMap());
  }

  Future<List<Record>> getAllRecords() async {
    final db = await database;
    final maps = await db.query('records', orderBy: 'id DESC');
    return maps.map((m) => Record.fromMap(m)).toList();
  }

  Future<int> updateRecord(Record record) async {
    final db = await database;
    return db.update(
      'records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return db.delete(
      'records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
