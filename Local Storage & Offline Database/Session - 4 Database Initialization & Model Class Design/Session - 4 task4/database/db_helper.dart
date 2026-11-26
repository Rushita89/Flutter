import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Private constructor
  DatabaseHelper._privateConstructor();

  // Single shared instance
  static final DatabaseHelper instance =
  DatabaseHelper._privateConstructor();

  // Store database connection
  Database? _database;

  // Database getter
  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    String folder = await getDatabasesPath();
    String path = '$folder/expense_tracker.db';

    return await openDatabase(
      path,
      version: 1,

      // Create tables
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
    );
  }

  // Reset database (kept from previous task)
  Future<Database> resetDatabase() async {
    Database db = await database;

    // Read path before closing
    String path = db.path;

    // Close connection
    await db.close();

    // Clear stored database
    _database = null;

    // Delete old database
    await deleteDatabase(path);

    // Open fresh database
    return await database;
  }
}
