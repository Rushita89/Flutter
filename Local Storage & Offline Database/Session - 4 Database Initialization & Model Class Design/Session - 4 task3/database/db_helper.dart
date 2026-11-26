import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  Database? _database;

  // Get database instance
  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _openDatabase();
    return _database!;
  }

  // Open database
  Future<Database> _openDatabase() async {
    String folder = await getDatabasesPath();
    String path = '$folder/expense_tracker.db';

    return await openDatabase(
      path,
      version: 2,

      // Create tables for a fresh database
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            note TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
        ''');
      },

      // Upgrade database from version 1 to version 2
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE expenses ADD COLUMN note TEXT',
          );
        }
      },
    );
  }

  // Reset database
  Future<Database> resetDatabase() async {
    // Get current database
    Database db = await database;

    // Read path before closing database
    String path = db.path;

    // Close database connection
    await db.close();

    // Clear stored database instance
    _database = null;

    // Delete old database
    await deleteDatabase(path);

    // Open a fresh database
    return await database;
  }
}
