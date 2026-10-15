import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../widgets/food_item_card.dart';

class HomeScreen extends StatelessWidget {
  final List<FoodItem> foodItems;
  final int cartCount;
  final Function(FoodItem) onAdd;

  const HomeScreen({
    super.key,
    required this.foodItems,
    required this.cartCount,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuickBite',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('$cartCount'),
              isLabelVisible: cartCount > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Discover Delicious Food!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4E342E),
            ),
          ),
          const SizedBox(height: 6),
          const Text('Fresh food, delivered to your door.'),
          const SizedBox(height: 16),

          for (final item in foodItems)
            FoodItemCard(
              item: item,
              onAdd: () {
                onAdd(item);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name} added to cart!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              icon: const Icon(Icons.shopping_cart),
              label: Text('View Cart ($cartCount)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
