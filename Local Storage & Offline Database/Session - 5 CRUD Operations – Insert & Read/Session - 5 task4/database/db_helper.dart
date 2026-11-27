import 'package:sqflite/sqflite.dart';
import '../models/expense.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
  DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

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

  // Insert expense into database
  Future<int> insertExpense(Expense e) async {
    final db = await database;

    return await db.insert(
      'expenses',
      e.toMap(),
    );
  }

  // Get expenses with optional category filter
  Future<List<Expense>> getExpenses({String? category}) async {
    final db = await database;

    List<Map<String, dynamic>> maps;

    if (category == null) {
      maps = await db.query(
        'expenses',
        orderBy: 'id DESC',
      );
    } else {
      maps = await db.query(
        'expenses',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'id DESC',
      );
    }

    return List.generate(
      maps.length,
          (index) => Expense.fromMap(maps[index]),
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
