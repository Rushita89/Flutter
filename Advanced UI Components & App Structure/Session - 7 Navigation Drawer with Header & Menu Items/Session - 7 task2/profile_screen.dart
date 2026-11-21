import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  final Function(int) onTabSelected;

  const ProfileScreen({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(onItemSelected: onTabSelected),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
