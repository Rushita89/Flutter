
import 'package:flutter/material.dart';

import 'food_item.dart';
import 'food_data.dart';
import 'screens/item_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  bool isGrid = false;

  // Navigate to item details
  void openItemDetails(FoodItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(
          item: item,
        ),
      ),
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

        actions: [

          // Toggle list and grid
          IconButton(
            icon: Icon(
              isGrid ? Icons.list : Icons.grid_view,
              color: Colors.white,
            ),

            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
        ],
      ),

      body: isGrid

      // GRID MODE
          ? GridView.builder(
        padding: const EdgeInsets.all(12),

        itemCount: foodItems.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),

        itemBuilder: (context, index) {
          final item = foodItems[index];

          return Card(
            elevation: 4,

            child: InkWell(
              borderRadius: BorderRadius.circular(12),

              onTap: () {
                openItemDetails(item);
              },

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    Icon(
                      item.icon,
                      size: 55,
                      color: Colors.deepOrange,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      item.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '₹${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )

      // LIST MODE
          : ListView.builder(
        padding: const EdgeInsets.all(12),

        itemCount: foodItems.length,

        itemBuilder: (context, index) {
          final item = foodItems[index];

          return Card(
            elevation: 4,

            margin: const EdgeInsets.only(bottom: 12),

            child: InkWell(
              borderRadius: BorderRadius.circular(12),

              onTap: () {
                openItemDetails(item);
              },

              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 30,
                      backgroundColor:
                      Colors.orange.shade50,

                      child: Icon(
                        item.icon,
                        size: 30,
                        color: Colors.deepOrange,
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
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
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
