import 'package:flutter/material.dart';

import '../food_data.dart';
import '../models/past_order.dart';

class OrderProvider extends ChangeNotifier {
  // Current order items
  Map<String, int> orders = {};

  // Past orders list
  List<PastOrder> pastOrders = [];

  // Get total number of items
  int get totalCount {
    return orders.values.fold(
      0,
          (sum, quantity) => sum + quantity,
    );
  }

  // Get quantity of a particular food item
  int getQuantity(FoodItem item) {
    return orders[item.name] ?? 0;
  }

  // Calculate total amount
  double get totalAmount {
    double total = 0;

    for (var entry in orders.entries) {
      final item = foodItems.firstWhere(
            (food) => food.name == entry.key,
      );

      total += item.price * entry.value;
    }

    return total;
  }

  // Add food item
  void add(FoodItem item) {
    orders[item.name] = (orders[item.name] ?? 0) + 1;
    notifyListeners();
  }

  // Remove food item
  void remove(FoodItem item) {
    if (!orders.containsKey(item.name)) return;

    if (orders[item.name]! > 1) {
      orders[item.name] = orders[item.name]! - 1;
    } else {
      orders.remove(item.name);
    }

    notifyListeners();
  }

  // Clear current order
  void clearOrder() {
    orders.clear();
    notifyListeners();
  }

  // Place order and move it to Past Orders
  void placeOrder() {
    if (orders.isEmpty) return;

    pastOrders.insert(
      0,
      PastOrder(
        items: Map<String, int>.from(orders),
        status: 'Preparing',
        orderDate: DateTime.now(),
      ),
    );

    orders.clear();
    notifyListeners();
  }
}
