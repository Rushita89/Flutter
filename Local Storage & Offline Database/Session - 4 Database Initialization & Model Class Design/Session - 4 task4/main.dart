import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database/db_helper.dart';
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

  // Convert Expense into Map
  Map<String, dynamic> expenseMap = expense.toMap();

  // Convert Map back into Expense
  Expense convertedExpense = Expense.fromMap(expenseMap);

  // Print results
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

class _ExpenseTrackerScreenState
    extends State<ExpenseTrackerScreen> {
  Database? database;

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  // Initialize database using DatabaseHelper
  Future<void> initializeDatabase() async {
    database = await DatabaseHelper.instance.database;

    if (!mounted) return;

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
                      builder: (context) =>
                      const SchemaScreen(),
                    ),
                  );
                },
                child: const Text(
                  'View Database Schema',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Schema Screen
class SchemaScreen extends StatefulWidget {
  const SchemaScreen({super.key});

  @override
  State<SchemaScreen> createState() => _SchemaScreenState();
}

class _SchemaScreenState extends State<SchemaScreen> {
  List<Map<String, dynamic>> tables = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSchema();
  }

  // Load database schema
  Future<void> loadSchema() async {
    setState(() {
      isLoading = true;
    });

    Database db = await DatabaseHelper.instance.database;

    // Get table names
    List<Map<String, dynamic>> tableList =
    await db.rawQuery('''
      SELECT name FROM sqlite_master
      WHERE type = 'table'
      AND name NOT LIKE 'sqlite_%'
      ORDER BY name
    ''');

    List<Map<String, dynamic>> result = [];

    for (var table in tableList) {
      String tableName = table['name'];

      // Get table columns
      List<Map<String, dynamic>> columns =
      await db.rawQuery(
        'PRAGMA table_info("$tableName")',
      );

      // Get row count
      int rowCount = Sqflite.firstIntValue(
        await db.rawQuery(
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
      isLoading = false;
    });
  }

  // Reset database
  Future<void> resetDatabase() async {
    setState(() {
      isLoading = true;
    });

    try {
      await DatabaseHelper.instance.resetDatabase();

      await loadSchema();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database reset successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Schema'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: isLoading ? null : resetDatabase,
            tooltip: 'Reset database',
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : tables.isEmpty
          ? const Center(
        child: Text('No tables found'),
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
            margin: const EdgeInsets.only(
              bottom: 15,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
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
                      padding:
                      const EdgeInsets.symmetric(
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
