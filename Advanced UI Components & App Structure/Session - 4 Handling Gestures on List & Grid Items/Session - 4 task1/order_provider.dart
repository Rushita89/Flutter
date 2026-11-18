import 'package:flutter/material.dart';
import 'food_item.dart';

class OrderProvider extends ChangeNotifier {

  Map<String, int> orders = {};

  void add(FoodItem item) {

    if (orders.containsKey(item.name)) {
      orders[item.name] = orders[item.name]! + 1;
    } else {
      orders[item.name] = 1;
    }

    notifyListeners();
  }

  int getQuantity(String name) {
    return orders[name] ?? 0;
  }
}