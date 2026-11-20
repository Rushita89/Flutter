
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../food_data.dart';
import '../providers/order_provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void showFoodOptions(BuildContext context, FoodItem item) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.orange,
                ),
                title: const Text('Add to order'),

                onTap: () {
                  context.read<OrderProvider>().add(item);

                  Navigator.pop(bottomSheetContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${item.name} added to order '
                            '(x${context.read<OrderProvider>().getQuantity(item)})',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Menu'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: foodItems.length,

        itemBuilder: (context, index) {
          final item = foodItems[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),

            child: InkWell(
              borderRadius: BorderRadius.circular(12),

              onLongPress: () {
                showFoodOptions(context, item);
              },

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.orange.shade100,
                      child: Icon(
                        item.icon,
                        size: 30,
                        color: Colors.orange,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            item.category,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '₹${item.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      item.isVeg
                          ? Icons.circle
                          : Icons.circle,
                      color: item.isVeg ? Colors.green : Colors.red,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
