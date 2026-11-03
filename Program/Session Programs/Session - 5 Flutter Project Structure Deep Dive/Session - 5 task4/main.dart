import 'package:flutter/material.dart';
import 'widgets.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Foodie Explorer',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    ),
  );
}