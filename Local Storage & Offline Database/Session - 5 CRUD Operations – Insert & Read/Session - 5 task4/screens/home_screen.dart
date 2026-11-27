import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';

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

  // Load expenses from SQLite database
  Future<void> loadExpenses({String? category}) async {
    setState(() {
      isLoading = true;
      selectedCategory = category;
    });

    try {
      List<Expense> data =
      await DatabaseHelper.instance.getExpenses(
        category: category,
      );

      if (!mounted) return;

      setState(() {
        expenses = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading expenses: $e'),
        ),
      );
    }
  }

  // Open Add Expense screen
  Future<void> openAddScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpenseScreen(),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(title),
    );
  }

  // Expense card
  Widget expenseCard(Expense expense) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            expense.category == 'Food'
                ? Icons.restaurant
                : expense.category == 'Travel'
                ? Icons.directions_bus
                : expense.category == 'Bills'
                ? Icons.receipt
                : Icons.shopping_bag,
            color: Colors.blue,
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.all(8),
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

          const Divider(),

          // Expense list
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : expenses.isEmpty
                ? const Center(
              child: Text(
                'No expenses found!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return expenseCard(expenses[index]);
              },
            ),
          ),
        ],
      ),

      // Add expense button
      floatingActionButton: FloatingActionButton(
        onPressed: openAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
