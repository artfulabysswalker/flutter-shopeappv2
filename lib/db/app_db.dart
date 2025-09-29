import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../utils/hash.dart'; // Make sure this points to your hash.dart

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pos_app.db');
    // Insert default user after creating DB
    await insertTestUser();
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

  Future<void> insertTestUser() async {
    final db = await database;

    // Check if test user already exists
    final existing = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: ['admin'],
    );

    if (existing.isEmpty) {
      final hashedPassword = hashPassword('1234');
      await db.insert('users', {
        'full_name': 'Admin',
        'username': 'admin',
        'email': 'admin@test.com',
        'password': hashedPassword,
      });
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

Future<List<Map<String, dynamic>>> getDailySummary() async {
  final db = await AppDatabase.instance.database;
  return await db.rawQuery('''
    SELECT DATE(created_at) as day, SUM(total) as total
    FROM txns
    GROUP BY DATE(created_at)
    ORDER BY DATE(created_at) DESC
  ''');
}
