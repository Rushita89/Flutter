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

  final TextEditingController noteController =
  TextEditingController();

  final List<String> categories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];

  String selectedCategory = 'Food';

  DateTime selectedDate = DateTime.now();

  bool isSaving = false;

  // Validate amount
  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
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

  // Select date
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Save expense
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
        category: selectedCategory,
        date: selectedDate.toIso8601String().split('T')[0],
        note: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
      );

      await DatabaseHelper.instance.insertExpense(expense);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense saved successfully'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving expense: $e'),
        ),
      );

      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Expense Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter expense title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Amount
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
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                validator: validateAmount,
              ),

              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // Date
              InkWell(
                onTap: pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
              ),

              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSaving ? null : saveExpense,
                  child: isSaving
                      ? const CircularProgressIndicator()
                      : const Text(
                    'Save Expense',
                    style: TextStyle(fontSize: 16),
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
