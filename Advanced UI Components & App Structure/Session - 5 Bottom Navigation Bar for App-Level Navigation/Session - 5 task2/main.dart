
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/order_provider.dart';
import 'screens/app_shell.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => OrderProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Canteen',

      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      home: const AppShell(),
    );
  }
}
