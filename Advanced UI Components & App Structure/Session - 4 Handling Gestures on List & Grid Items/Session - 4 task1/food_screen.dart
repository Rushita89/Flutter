import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'food_item.dart';
import 'food_data.dart';
import 'order_provider.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  // Show bottom sheet on long press
  void showFoodOptions(BuildContext context, FoodItem item) {

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),

      builder: (bottomSheetContext) {

        return Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              // Food name
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

                  // Access Provider
                  final provider =
                  context.read<OrderProvider>();

                  // Add food item
                  provider.add(item);

                  // Get quantity
                  int quantity =
                  provider.getQuantity(item.name);

                  // Close bottom sheet
                  Navigator.pop(bottomSheetContext);

                  // Show SnackBar
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
                leading: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),

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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),

      body: ListView.builder(

        padding: const EdgeInsets.all(12),

        itemCount: foodItems.length,

        itemBuilder: (context, index) {

          FoodItem item = foodItems[index];

          return GestureDetector(

            // Long press event
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

                    // Food icon
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

                    // Food details
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
                            '₹${item.price.toStringAsFixed(0)}',
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