import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pos_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT,
        username TEXT UNIQUE,
        email TEXT,
        password TEXT
      );
    ''';

    const itemTable = '''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price INTEGER,
        category TEXT
      );
    ''';

    const txnTable = '''
      CREATE TABLE txns (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        created_at TEXT,
        total INTEGER
      );
    ''';

    const txnItemsTable = '''
      CREATE TABLE txn_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        txn_id INTEGER,
        item_id INTEGER,
        qty INTEGER,
        price INTEGER
      );
    ''';

    await db.execute(userTable);
    await db.execute(itemTable);
    await db.execute(txnTable);
    await db.execute(txnItemsTable);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
