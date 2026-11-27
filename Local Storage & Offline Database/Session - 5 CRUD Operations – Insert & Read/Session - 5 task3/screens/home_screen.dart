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

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  // Load expenses from database
  Future<void> loadExpenses({String? category}) async {
    setState(() {
      isLoading = true;
      selectedCategory = category;
    });

    List<Expense> data =
    await DatabaseHelper.instance.getExpenses(
      category: category,
    );

    if (!mounted) return;

    setState(() {
      expenses = data;
      isLoading = false;
    });
  }

  // Open Add Expense screen
  Future<void> openAddScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddScreen(),
      ),
    );

    if (!mounted) return;

    loadExpenses(category: selectedCategory);
  }

  // Filter button
  Widget filterButton(String title, String? category) {
    bool isSelected = selectedCategory == category;

    return ElevatedButton(
      onPressed: () {
        loadExpenses(category: category);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
        isSelected ? Colors.blue : Colors.grey.shade300,
        foregroundColor:
        isSelected ? Colors.white : Colors.black,
      ),
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
      ),

      body: Column(
        children: [
          // Four filter buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                filterButton('All', null),
                filterButton('Food', 'Food'),
                filterButton('Travel', 'Travel'),
                filterButton('Bills', 'Bills'),
              ],
            ),
          ),

          // Expense list
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : expenses.isEmpty
                ? const Center(
              child: Text(
                'No expenses found.',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(expense.title),
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(expense.category),
                        Text(expense.date),
                      ],
                    ),
                    trailing: Text(
                      '₹${expense.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
