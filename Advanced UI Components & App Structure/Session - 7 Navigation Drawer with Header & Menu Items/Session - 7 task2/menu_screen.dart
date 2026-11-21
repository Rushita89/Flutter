import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class MenuScreen extends StatelessWidget {
  final Function(int) onTabSelected;

  const MenuScreen({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(onItemSelected: onTabSelected),
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          'Menu Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
