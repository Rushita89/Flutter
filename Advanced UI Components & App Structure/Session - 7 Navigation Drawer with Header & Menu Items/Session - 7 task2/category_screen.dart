import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CategoryScreen extends StatelessWidget {
  final Function(int) onTabSelected;

  const CategoryScreen({
    super.key,
    required this.onTabSelected,
  });

  final List<String> categories = const [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Drinks',
    'Desserts',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(onItemSelected: onTabSelected),
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.orange,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          return Card(
            child: Center(
              child: Text(
                categories[index],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
