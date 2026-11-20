
import 'package:flutter/material.dart';
import '../models/food_item.dart';

class OrderProvider extends ChangeNotifier {
  final Map<FoodItem, int> _quantities = {};

  // Get all ordered items
  Map<FoodItem, int> get quantities => _quantities;

  // Calculate total quantity
  int get totalCount {
    return _quantities.values.fold(
      0,
          (sum, quantity) => sum + quantity,
    );
  }

  // Add food item
  void add(FoodItem item) {
    _quantities[item] = (_quantities[item] ?? 0) + 1;
    notifyListeners();
  }

  // Remove food item
  void remove(FoodItem item) {
    if (!_quantities.containsKey(item)) return;

    if (_quantities[item]! > 1) {
      _quantities[item] = _quantities[item]! - 1;
    } else {
      _quantities.remove(item);
    }

    notifyListeners();
  }

  // Clear order
  void clearOrder() {
    _quantities.clear();
    notifyListeners();
  }
}
