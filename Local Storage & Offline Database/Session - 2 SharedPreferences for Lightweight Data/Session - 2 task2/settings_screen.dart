import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // Dark Mode Switch
            SwitchListTile(
              title: const Text(
                'Dark mode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: const Text(
                'Enable dark theme for the entire app',
              ),

              secondary: const Icon(Icons.dark_mode),

              value: settings.isDarkMode,

              onChanged: (value) {
                settings.toggleDarkMode(value);
              },
            ),

            const SizedBox(height: 25),

            // Login / Logout Button
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () async {
                  await settings.toggleLogin();
                },

                child: Text(
                  settings.loggedIn ? 'Log out' : 'Log in',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
