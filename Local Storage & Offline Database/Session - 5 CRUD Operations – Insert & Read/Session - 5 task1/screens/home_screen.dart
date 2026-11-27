import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/expense.dart';
import 'add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Load expenses when screen opens
    loadExpenses();
  }

  // Load expenses from database
  Future<void> loadExpenses() async {
    List<Expense> data =
    await DatabaseHelper.instance.getExpenses();

    if (!mounted) return;

    setState(() {
      expenses = data;
      isLoading = false;
    });
  }

  // Open Add Screen and refresh after returning
  Future<void> openAddScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddScreen(),
      ),
    );

    // Reload expenses after Add Screen closes
    loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : expenses.isEmpty
          ? const Center(
        child: Text(
          'No expenses found.\nAdd your first expense!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: expenses.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final expense = expenses[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(
              bottom: 12,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(
                  Icons.currency_rupee,
                  color: Colors.blue,
                ),
              ),
              title: Text(
                expense.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    expense.category,
                  ),
                  Text(
                    expense.date,
                  ),
                ],
              ),
              trailing: Text(
                '₹${expense.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddScreen,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
