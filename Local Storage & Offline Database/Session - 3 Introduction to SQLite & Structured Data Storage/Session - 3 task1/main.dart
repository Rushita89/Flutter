import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpenseTrackerScreen(),
    ),
  );
}

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() =>
      _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState
    extends State<ExpenseTrackerScreen> {

  Database? database;

  String databaseStatus = 'Opening database...';
  String databasePath = '';

  @override
  void initState() {
    super.initState();

    openExpenseDatabase();
  }

  // Open database and create expenses table
  Future<void> openExpenseDatabase() async {
    try {
      // Get database folder
      String folder = await getDatabasesPath();

      // Create database file path
      String path = '$folder/expense_tracker.db';

      // Open database
      database = await openDatabase(
        path,
        version: 1,

        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS expenses (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              amount REAL NOT NULL,
              category TEXT NOT NULL,
              date TEXT NOT NULL
            )
          ''');
        },
      );

      // Update screen
      if (!mounted) return;

      setState(() {
        databaseStatus = 'Database ready';
        databasePath = database!.path;
      });

    } catch (e) {
      if (!mounted) return;

      setState(() {
        databaseStatus = 'Database error: $e';
      });
    }
  }

  @override
  void dispose() {
    database?.close();
    super.dispose();
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
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.storage,
                size: 70,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              Text(
                databaseStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Database Path:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              SelectableText(
                databasePath.isEmpty
                    ? 'Loading database path...'
                    : databasePath,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
