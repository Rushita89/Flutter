import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_provider.dart';
import 'food_data.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Listen to OrderProvider
    final provider = context.watch<OrderProvider>();

    // Get order entries
    final orderList = provider.orders.entries.toList();

    // Calculate subtotal
    double subtotal = 0;

    for (var entry in orderList) {
      final item = foodItems.firstWhere(
            (food) => food.name == entry.key,
      );

      subtotal += item.price * entry.value;
    }

    // Calculate GST
    double gst = subtotal * 0.05;

    // Calculate total
    double total = subtotal + gst;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Summary',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),

      body: orderList.isEmpty

      // Empty order
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey,
            ),

            SizedBox(height: 15),

            Text(
              'Nothing ordered yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )

      // Display order details
          : Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Your Order',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // Order rows
            Expanded(
              child: ListView.builder(
                itemCount: orderList.length,

                itemBuilder: (context, index) {
                  final entry = orderList[index];

                  final item = foodItems.firstWhere(
                        (food) => food.name == entry.key,
                  );

                  final quantity = entry.value;

                  final itemTotal =
                      item.price * quantity;

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),

                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFFFE0B2),
                        child: Icon(
                          Icons.fastfood,
                          color: Colors.deepOrange,
                        ),
                      ),

                      title: Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        '₹${item.price.toStringAsFixed(2)} × $quantity',
                      ),

                      trailing: Text(
                        '₹${itemTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 1),

            // Subtotal
            priceRow(
              'Subtotal',
              subtotal,
            ),

            const SizedBox(height: 10),

            // GST
            priceRow(
              'GST (5%)',
              gst,
            ),

            const Divider(thickness: 1),

            // Grand total
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Grand Total',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  '₹${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable price row
  Widget priceRow(String title, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),

        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}