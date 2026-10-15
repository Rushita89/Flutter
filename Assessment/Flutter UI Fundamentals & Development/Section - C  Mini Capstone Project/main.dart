
import 'package:flutter/material.dart';

import 'data/food_data.dart';
import 'models/food_item.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_summary_screen.dart';

void main() {
  runApp(QuickBiteApp());
}

class QuickBiteApp extends StatefulWidget {
  const QuickBiteApp({super.key});

  @override
  State<QuickBiteApp> createState() => _QuickBiteAppState();
}

class _QuickBiteAppState extends State<QuickBiteApp> {
  final List<FoodItem> cartItems = [];

  void addToCart(FoodItem item) {
    setState(() {
      cartItems.add(item);
    });
  }

  void removeFromCart(FoodItem item) {
    setState(() {
      cartItems.remove(item);
    });
  }

  double get totalPrice {
    double total = 0;

    for (final item in cartItems) {
      total += item.price;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickBite',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB71C1C),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB71C1C),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(
          foodItems: foodItems,
          cartCount: cartItems.length,
          onAdd: addToCart,
        ),
        '/cart': (context) => CartScreen(
          cartItems: cartItems,
          onRemove: removeFromCart,
          onPlaceOrder: () {
            Navigator.pushNamed(
              context,
              '/summary',
              arguments: totalPrice,
            );
          },
        ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/summary') {
          final total = settings.arguments as double;

          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return OrderSummaryScreen(total: total);
            },
          );
        }

        return null;
      },
    );
  }
}
