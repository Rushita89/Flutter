import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'food_item.dart';
import 'food_data.dart';
import 'order_provider.dart';
import 'order_summary_screen.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  // Show bottom sheet
  void showFoodOptions(BuildContext context, FoodItem item) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Add to order
              ListTile(
                leading: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.green,
                ),
                title: const Text('Add to order'),

                onTap: () {
                  final provider =
                  context.read<OrderProvider>();

                  provider.add(item);

                  int quantity =
                  provider.getQuantity(item.name);

                  Navigator.pop(bottomSheetContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${item.name} added (x$quantity)',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),

              // Cancel
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
        title: const Text(
          'Food Menu',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const OrderSummaryScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: foodItems.length,

        itemBuilder: (context, index) {
          FoodItem item = foodItems[index];

          return GestureDetector(
            onLongPress: () {
              showFoodOptions(context, item);
            },

            child: Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 15),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFFFFE0B2),
                      child: Icon(
                        Icons.fastfood,
                        color: Colors.deepOrange,
                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '₹${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'Long press to add to order',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.touch_app,
                      color: Colors.deepOrange,
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