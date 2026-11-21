
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../food_data.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Orders',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,

          // TabBar
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Past Orders'),
            ],
          ),
        ),

        // TabBarView
        body: TabBarView(
          children: [
            // FIRST TAB: CURRENT ORDERS
            Consumer<OrderProvider>(
              builder: (context, provider, child) {
                final orderItems = provider.orders.entries.toList();

                return Column(
                  children: [
                    Expanded(
                      child: orderItems.isEmpty
                          ? const Center(
                        child: Text(
                          'Your order is empty',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: orderItems.length,
                        itemBuilder: (context, index) {
                          final entry = orderItems[index];

                          final item = foodItems.firstWhere(
                                (food) => food.name == entry.key,
                          );

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                Colors.orange.shade100,
                                child: Icon(
                                  item.icon,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '₹${item.price} x ${entry.value}',
                              ),
                              trailing: Text(
                                '₹${item.price * entry.value}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // FOOTER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Items',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${provider.totalCount}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹${provider.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // SECOND TAB: PAST ORDERS
            const Center(
              child: Text(
                'No past orders yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
