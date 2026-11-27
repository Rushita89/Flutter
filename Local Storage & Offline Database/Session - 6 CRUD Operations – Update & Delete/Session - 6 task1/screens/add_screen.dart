import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/expense.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController amountController =
  TextEditingController();

  String? selectedCategory;
  bool isSaving = false;

  final List<String> categories = [
    'Food',
    'Travel',
    'Bills',
    'Shopping',
    'Entertainment',
    'Other',
  ];

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter expense title';
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter amount';
    }

    double? amount = double.tryParse(value.trim());

    if (amount == null) {
      return 'Please enter a valid number';
    }

    if (amount == 0) {
      return 'Amount must be greater than 0';
    }

    if (amount < 0) {
      return 'Negative amounts are not allowed';
    }

    if (amount > 100000) {
      return 'Amount cannot be greater than ₹1,00,000';
    }

    return null;
  }

  Future<void> saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      Expense expense = Expense(
        title: titleController.text.trim(),
        amount: double.parse(amountController.text.trim()),
        category: selectedCategory!,
        date: DateTime.now().toIso8601String().substring(0, 10),
      );

      await DatabaseHelper.instance.insertExpense(expense);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense added successfully'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving expense: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Expense Title',
                  hintText: 'Enter expense title',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: validateTitle,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: amountController,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter amount',
                  prefixText: '₹ ',
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                validator: validateAmount,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select category';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      'Date: ${DateTime.now().toIso8601String().substring(0, 10)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSaving ? null : saveExpense,
                  child: isSaving
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    'Save Expense',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
