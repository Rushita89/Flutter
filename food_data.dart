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

final List<FoodItem> foodItems = [
  FoodItem(
    name: 'Masala Dosa',
    category: 'South Indian',
    price: 80,
    isVeg: true,
    icon: Icons.breakfast_dining,
  ),
  FoodItem(
    name: 'Veg Burger',
    category: 'Fast Food',
    price: 60,
    isVeg: true,
    icon: Icons.lunch_dining,
  ),
  FoodItem(
    name: 'Pizza',
    category: 'Fast Food',
    price: 120,
    isVeg: true,
    icon: Icons.local_pizza,
  ),
  FoodItem(
    name: 'Paneer Sandwich',
    category: 'Snacks',
    price: 70,
    isVeg: true,
    icon: Icons.fastfood,
  ),
  FoodItem(
    name: 'Cold Coffee',
    category: 'Drinks',
    price: 50,
    isVeg: true,
    icon: Icons.local_cafe,
  ),
  FoodItem(
    name: 'French Fries',
    category: 'Snacks',
    price: 60,
    isVeg: true,
    icon: Icons.restaurant,
  ),
  FoodItem(
    name: 'Chicken Burger',
    category: 'Fast Food',
    price: 100,
    isVeg: false,
    icon: Icons.lunch_dining,
  ),
  FoodItem(
    name: 'Veg Sandwich',
    category: 'Snacks',
    price: 55,
    isVeg: true,
    icon: Icons.breakfast_dining,
  ),
];
