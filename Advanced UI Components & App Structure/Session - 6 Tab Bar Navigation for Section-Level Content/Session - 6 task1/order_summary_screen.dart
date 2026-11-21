
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
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
            Consumer<OrderProvider>(
              builder: (context, provider, child) {
                final entries = provider.orders.entries.toList();

                return Column(
                  children: [
                    Expanded(
                      child: entries.isEmpty
                          ? const Center(
                        child: Text('Your order is empty'),
                      )
                          : ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];

                          return ListTile(
                            title: Text(entry.key),
                            subtitle: Text(
                              'Quantity: ${entry.value}',
                            ),
                          );
                        },
                      ),
                    ),

                    // PLACE ORDER FOOTER
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Builder(
                          builder: (buttonContext) {
                            return ElevatedButton(
                              onPressed: provider.orders.isEmpty
                                  ? null
                                  : () {
                                provider.placeOrder();

                                DefaultTabController.of(
                                  buttonContext,
                                ).animateTo(1);
                              },
                              child: const Text('Place Order'),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // PAST ORDERS TAB
            Consumer<OrderProvider>(
              builder: (context, provider, child) {
                if (provider.pastOrders.isEmpty) {
                  return const Center(
                    child: Text('No past orders yet'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.pastOrders.length,
                  itemBuilder: (context, index) {
                    final order = provider.pastOrders[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${index + 1}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...order.items.entries.map(
                                  (entry) => Text(
                                '${entry.key} x ${entry.value}',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              order.status,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
