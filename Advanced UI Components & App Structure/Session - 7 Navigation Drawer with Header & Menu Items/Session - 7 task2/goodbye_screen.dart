import 'package:flutter/material.dart';
import 'app_shell.dart';

class GoodbyeScreen extends StatelessWidget {
  const GoodbyeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.waving_hand,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text(
                'Thank you, visit again',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppShell(),
                    ),
                        (route) => false,
                  );
                },
                child: const Text('Login again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
