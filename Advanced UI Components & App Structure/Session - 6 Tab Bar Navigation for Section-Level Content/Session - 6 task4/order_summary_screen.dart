
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../food_data.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Orders',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Past Orders'),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // CURRENT ORDERS TAB
            Column(
              children: [
                Expanded(
                  child: provider.orders.isEmpty
                      ? const Center(
                    child: Text(
                      'Your order is empty',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: provider.orders.length,
                    itemBuilder: (context, index) {
                      final entry =
                      provider.orders.entries.elementAt(index);

                      final item = foodItems.firstWhere(
                            (food) => food.name == entry.key,
                      );

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.shade100,
                            child: Icon(
                              item.icon,
                              color: Colors.deepOrange,
                            ),
                          ),
                          title: Text(item.name),
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

                // TOTAL FOOTER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  color: Colors.orange.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ),
              ],
            ),

            // PAST ORDERS TAB
            provider.pastOrders.isEmpty
                ? const Center(
              child: Text('No past orders yet'),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.pastOrders.length,
              itemBuilder: (context, index) {
                final order = provider.pastOrders[index];

                final statusColor =
                order.status == 'Delivered'
                    ? Colors.green
                    : order.status == 'Cancelled'
                    ? Colors.red
                    : Colors.orange;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order number and date
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.orderNo}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              order.dateLabel,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Items: ${order.itemCount}',
                          style: const TextStyle(fontSize: 15),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: ₹${order.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              order.status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
