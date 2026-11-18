import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final String category;
  final double price;
  final bool isVeg;
  final IconData icon;

  FoodItem({
    required this.name,
    required this.category,
    required this.price,
    required this.isVeg,
    required this.icon,
  });
}