
import 'package:flutter/material.dart';
import 'user_profile.dart';

void main() {
  UserProfile user = UserProfile(
    username: 'Rushita',
    followers: 1200,
    bio: 'Flutter Developer',
  );

  print(user.username);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Username printed in Debug Console'),
        ),
      ),
    );
  }
}
