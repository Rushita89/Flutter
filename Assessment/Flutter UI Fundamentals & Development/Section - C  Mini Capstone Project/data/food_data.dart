import 'package:flutter/material.dart';
import '../models/food_item.dart';

final List<FoodItem> foodItems = [
  FoodItem(
    name: 'Paneer Pizza',
    price: 249.0,
    isAvailable: true,
    icon: Icons.local_pizza,
  ),
  FoodItem(
    name: 'Veg Burger',
    price: 129.0,
    isAvailable: true,
    icon: Icons.lunch_dining,
  ),
  FoodItem(
    name: 'White Sauce Pasta',
    price: 199.0,
    isAvailable: true,
    icon: Icons.dinner_dining,
  ),
  FoodItem(
    name: 'French Fries',
    price: 89.0,
    isAvailable: true,
    icon: Icons.fastfood,
  ),
  FoodItem(
    name: 'Veg Sandwich',
    price: 99.0,
    isAvailable: false,
    icon: Icons.breakfast_dining,
  ),
];
