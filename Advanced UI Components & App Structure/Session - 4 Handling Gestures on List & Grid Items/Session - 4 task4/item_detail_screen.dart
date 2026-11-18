
import 'package:flutter/material.dart';
import '../food_item.dart';

class ItemDetailScreen extends StatelessWidget {
  final FoodItem item;

  const ItemDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Large food icon
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(25),
                ),

                child: Icon(
                  item.icon,
                  size: 110,
                  color: Colors.deepOrange,
                ),
              ),

              const SizedBox(height: 25),

              // Food name
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Category
              Text(
                item.category,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 15),

              // Price
              Text(
                '₹${item.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Veg or Non-Veg label
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: item.isVeg
                      ? Colors.green.shade50
                      : Colors.red.shade50,

                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: item.isVeg
                        ? Colors.green
                        : Colors.red,
                  ),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Icon(
                      Icons.circle,
                      size: 12,
                      color: item.isVeg
                          ? Colors.green
                          : Colors.red,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      item.isVeg ? 'Veg' : 'Non-Veg',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: item.isVeg
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
