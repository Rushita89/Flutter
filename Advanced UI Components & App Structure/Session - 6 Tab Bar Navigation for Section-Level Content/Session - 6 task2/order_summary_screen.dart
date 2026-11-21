
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen for live order updates
    final provider = context.watch<OrderProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Current (${provider.totalCount})',
              ),
              Tab(
                text: 'Past Orders (${provider.pastOrders.length})',
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // CURRENT ORDERS
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
                      : ListView(
                    children: provider.orders.entries.map((entry) {
                      return ListTile(
                        title: Text(entry.key),
                        subtitle: Text('Quantity: ${entry.value}'),
                      );
                    }).toList(),
                  ),
                ),

                // PLACE ORDER BUTTON
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
            ),

            // PAST ORDERS
            provider.pastOrders.isEmpty
                ? const Center(
              child: Text('No past orders yet'),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.pastOrders.length,
              itemBuilder: (context, index) {
                final order = provider.pastOrders[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
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
                        const SizedBox(height: 10),

                        ...order.items.entries.map(
                              (entry) => Text(
                            '${entry.key} x ${entry.value}',
                          ),
                        ),

                        const SizedBox(height: 10),

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
            ),
          ],
        ),
      ),
    );
  }
}
