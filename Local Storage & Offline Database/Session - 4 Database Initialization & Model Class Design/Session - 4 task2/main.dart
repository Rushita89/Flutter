import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'models/expense.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create Expense object
  Expense expense = Expense(
    title: 'Auto fare',
    amount: 85.0,
    category: 'Travel',
    date: '2026-11-02',
    note: 'Travel expense',
  );

  // Convert Expense object into Map
  Map<String, dynamic> expenseMap = expense.toMap();

  // Convert Map back into Expense object
  Expense convertedExpense = Expense.fromMap(expenseMap);

  // Print both results in Debug Console
  print('Original Expense Map: $expenseMap');
  print('Converted Expense Map: ${convertedExpense.toMap()}');

  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpenseTrackerScreen(),
    );
  }
}

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() =>
      _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  Database? database;

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    String folder = await getDatabasesPath();
    String path = '$folder/expense_tracker.db';

    database = await openDatabase(
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

      // Upgrade existing database from version 1 to version 2
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE expenses ADD COLUMN note TEXT',
          );
        }
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: database == null
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 15),
              const Text(
                'Database ready',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                database!.path,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchemaScreen(
                        database: database!,
                      ),
                    ),
                  );
                },
                child: const Text('View Database Schema'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SchemaScreen extends StatefulWidget {
  final Database database;

  const SchemaScreen({
    super.key,
    required this.database,
  });

  @override
  State<SchemaScreen> createState() => _SchemaScreenState();
}

class _SchemaScreenState extends State<SchemaScreen> {
  List<Map<String, dynamic>> tables = [];

  @override
  void initState() {
    super.initState();
    loadSchema();
  }

  Future<void> loadSchema() async {
    List<Map<String, dynamic>> tableList =
    await widget.database.rawQuery('''
      SELECT name FROM sqlite_master
      WHERE type = 'table'
      AND name NOT LIKE 'sqlite_%'
      ORDER BY name
    ''');

    List<Map<String, dynamic>> result = [];

    for (var table in tableList) {
      String tableName = table['name'];

      // Get columns dynamically
      List<Map<String, dynamic>> columns =
      await widget.database.rawQuery(
        'PRAGMA table_info("$tableName")',
      );

      // Get row count
      int rowCount = Sqflite.firstIntValue(
        await widget.database.rawQuery(
          'SELECT COUNT(*) FROM "$tableName"',
        ),
      ) ??
          0;

      result.add({
        'tableName': tableName,
        'columns': columns,
        'rowCount': rowCount,
      });
    }

    if (!mounted) return;

    setState(() {
      tables = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Schema'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: tables.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tables.length,
        itemBuilder: (context, index) {
          final table = tables[index];

          String tableName = table['tableName'];
          List columns = table['columns'];
          int rowCount = table['rowCount'];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 15),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tableName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rows: $rowCount',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Columns:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...columns.map((column) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              column['name'].toString(),
                            ),
                          ),
                          Text(
                            column['type'].toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
