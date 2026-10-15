import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final double price;
  final bool isAvailable;
  final IconData icon;

  FoodItem({
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.icon,
  });
}
