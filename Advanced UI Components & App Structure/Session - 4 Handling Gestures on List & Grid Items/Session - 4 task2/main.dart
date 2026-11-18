import 'package:flutter/material.dart';
import 'item_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const ItemDetailScreen(
        itemName: 'Masala Dosa',
        price: 80,
        itemIcon: Icons.restaurant,
      ),
    );
  }
}
