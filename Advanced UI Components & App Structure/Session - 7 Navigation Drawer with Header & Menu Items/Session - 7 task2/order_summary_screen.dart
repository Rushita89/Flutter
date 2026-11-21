import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class OrderSummaryScreen extends StatelessWidget {
  final Function(int) onTabSelected;

  const OrderSummaryScreen({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(onItemSelected: onTabSelected),
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          'My Orders Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
