import 'package:flutter/material.dart';
import 'food_item.dart';

List<FoodItem> foodItems = [
  FoodItem(
    name: 'Masala Dosa',
    category: 'South Indian',
    price: 80,
    isVeg: true,
    icon: Icons.restaurant,
  ),

  FoodItem(
    name: 'Samosa',
    category: 'Snacks',
    price: 20,
    isVeg: true,
    icon: Icons.fastfood,
  ),

  FoodItem(
    name: 'Veg Burger',
    category: 'Fast Food',
    price: 90,
    isVeg: true,
    icon: Icons.lunch_dining,
  ),

  FoodItem(
    name: 'Chicken Burger',
    category: 'Fast Food',
    price: 120,
    isVeg: false,
    icon: Icons.lunch_dining,
  ),

  FoodItem(
    name: 'Paneer Pizza',
    category: 'Italian',
    price: 150,
    isVeg: true,
    icon: Icons.local_pizza,
  ),

  FoodItem(
    name: 'Chicken Pizza',
    category: 'Italian',
    price: 180,
    isVeg: false,
    icon: Icons.local_pizza,
  ),

  FoodItem(
    name: 'French Fries',
    category: 'Snacks',
    price: 70,
    isVeg: true,
    icon: Icons.fastfood,
  ),

  FoodItem(
    name: 'Pav Bhaji',
    category: 'Indian',
    price: 100,
    isVeg: true,
    icon: Icons.dinner_dining,
  ),
];