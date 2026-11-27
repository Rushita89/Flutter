import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/expense.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('expense_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL
      )
    ''');

    await db.insert('categories', {'name': 'Food'});
    await db.insert('categories', {'name': 'Travel'});
    await db.insert('categories', {'name': 'Bills'});
    await db.insert('categories', {'name': 'Shopping'});
    await db.insert('categories', {'name': 'Entertainment'});
    await db.insert('categories', {'name': 'Other'});
  }

  Future<void> _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {
    if (oldVersion < 2) {
      final columns = await db.rawQuery(
        'PRAGMA table_info(expenses)',
      );

      final hasNote = columns.any(
            (column) => column['name'] == 'note',
      );

      if (!hasNote) {
        await db.execute(
          'ALTER TABLE expenses ADD COLUMN note TEXT',
        );
      }
    }
  }

  // INSERT EXPENSE
  Future<int> insertExpense(Expense e) async {
    final db = await database;

    return await db.insert(
      'expenses',
      e.toMap(),
    );
  }

  // UPDATE EXPENSE
  Future<int> updateExpense(Expense e) async {
    final db = await database;

    return await db.update(
      'expenses',
      e.toMap(),
      where: 'id = ?',
      whereArgs: [e.id],
    );
  }

  // GET ALL EXPENSES OR FILTER BY CATEGORY
  Future<List<Expense>> getExpenses({
    String? category,
  }) async {
    final db = await database;

    List<Map<String, dynamic>> maps;

    if (category == null || category == 'All') {
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
          (i) => Expense.fromMap(maps[i]),
    );
  }

  // GET TOTAL SPENT
  Future<double> getTotalSpent() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM expenses',
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // DELETE EXPENSE
  Future<int> deleteExpense(int id) async {
    final db = await database;

    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // GET CATEGORIES
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;

    return await db.query(
      'categories',
      orderBy: 'name ASC',
    );
  }

  // CLOSE DATABASE
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
