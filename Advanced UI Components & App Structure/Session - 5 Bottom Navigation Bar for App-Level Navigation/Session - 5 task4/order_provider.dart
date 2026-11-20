
import 'package:flutter/material.dart';
import '../food_data.dart';

class OrderProvider extends ChangeNotifier {
  final Map<String, int> orders = {};

  // Get total number of ordered items
  int get totalCount {
    return orders.values.fold(
      0,
          (sum, quantity) => sum + quantity,
    );
  }

  // Get quantity of a particular item
  int getQuantity(FoodItem item) {
    return orders[item.name] ?? 0;
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

  // Clear all orders
  void clearOrder() {
    orders.clear();
    notifyListeners();
  }
}
