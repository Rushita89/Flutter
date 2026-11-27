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

  double totalSpent = 0.0;

  String selectedCategory = 'All';

  bool isLoading = true;

  final List<String> categories = [
    'All',
    'Food',
    'Travel',
    'Bills',
    'Shopping',
    'Entertainment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  // LOAD EXPENSES AND TOTAL
  Future<void> loadExpenses() async {
    final expenseList =
    await DatabaseHelper.instance.getExpenses(
      category: selectedCategory,
    );

    final total =
    await DatabaseHelper.instance.getTotalSpent();

    if (!mounted) return;

    setState(() {
      expenses = expenseList;
      totalSpent = total;
      isLoading = false;
    });
  }

  // OPEN ADD SCREEN
  Future<void> openAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpenseScreen(),
      ),
    );

    if (result == true) {
      await loadExpenses();
    }
  }

  // OPEN EDIT SCREEN
  Future<void> editExpense(Expense expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(
          expense: expense,
        ),
      ),
    );

    if (result == true) {
      await loadExpenses();
    }
  }

  // DELETE EXPENSE WITH UNDO
  Future<void> deleteExpense(Expense expense) async {
    await DatabaseHelper.instance.deleteExpense(
      expense.id!,
    );

    await loadExpenses();

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense.title} deleted'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            await DatabaseHelper.instance.insertExpense(
              expense,
            );

            await loadExpenses();
          },
        ),
      ),
    );
  }

  // CATEGORY FILTER
  Future<void> filterExpenses(String category) async {
    setState(() {
      selectedCategory = category;
      isLoading = true;
    });

    await loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // TOTAL SPENT CARD
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  'Total Spent',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '₹${totalSpent.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // CATEGORY FILTER
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                final isSelected =
                    selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (value) {
                      filterExpenses(category);
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // EXPENSE LIST
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : expenses.isEmpty
                ? const Center(
              child: Text(
                'No expenses found',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      Colors.deepPurple.shade100,
                      child: const Icon(
                        Icons.currency_rupee,
                        color: Colors.deepPurple,
                      ),
                    ),

                    title: Text(
                      expense.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      '${expense.category} • ${expense.date}',
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteExpense(expense);
                          },
                        ),
                      ],
                    ),

                    onTap: () {
                      editExpense(expense);
                    },
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
