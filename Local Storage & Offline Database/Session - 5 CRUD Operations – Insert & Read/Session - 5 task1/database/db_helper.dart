
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';

class DatabaseHelper {
  // Private constructor
  DatabaseHelper._privateConstructor();

  // Single shared instance
  static final DatabaseHelper instance =
  DatabaseHelper._privateConstructor();

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

  // Get all expenses in descending ID order
  Future<List<Expense>> getExpenses() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
    await db.query(
      'expenses',
      orderBy: 'id DESC',
    );

    return List.generate(
      maps.length,
          (index) => Expense.fromMap(maps[index]),
    );
  }

  // Insert new expense
  Future<int> insertExpense(Expense expense) async {
    final db = await database;

    return await db.insert(
      'expenses',
      expense.toMap(),
    );
  }

  // Reset database
  Future<Database> resetDatabase() async {
    Database db = await database;

    String path = db.path;

    await db.close();

    _database = null;

    await deleteDatabase(path);

    return await database;
  }
}
