
import 'package:flutter/material.dart';

import '../food_data.dart';
import '../models/past_order.dart';

class OrderProvider extends ChangeNotifier {
  // Current order items
  Map<String, int> orders = {};

  // Past orders list with 5 sample orders
  List<PastOrder> pastOrders = [
    PastOrder(
      orderNo: 1001,
      dateLabel: '12 Aug',
      itemCount: 3,
      total: 250,
      status: 'Delivered',
    ),
    PastOrder(
      orderNo: 1002,
      dateLabel: '14 Aug',
      itemCount: 2,
      total: 180,
      status: 'Delivered',
    ),
    PastOrder(
      orderNo: 1003,
      dateLabel: '16 Aug',
      itemCount: 4,
      total: 350,
      status: 'Cancelled',
    ),
    PastOrder(
      orderNo: 1004,
      dateLabel: '18 Aug',
      itemCount: 1,
      total: 120,
      status: 'Delivered',
    ),
    PastOrder(
      orderNo: 1005,
      dateLabel: '20 Aug',
      itemCount: 3,
      total: 290,
      status: 'Delivered',
    ),
  ];

  // Get total number of current items
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

    final nextOrderNo = pastOrders.isEmpty
        ? 1001
        : pastOrders
        .map((order) => order.orderNo)
        .reduce((a, b) => a > b ? a : b) +
        1;

    final now = DateTime.now();

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    final dateLabel =
        '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]}';

    pastOrders.insert(
      0,
      PastOrder(
        orderNo: nextOrderNo,
        dateLabel: dateLabel,
        itemCount: totalCount,
        total: totalAmount,
        status: 'Preparing',
      ),
    );

    orders.clear();

    notifyListeners();
  }
}
