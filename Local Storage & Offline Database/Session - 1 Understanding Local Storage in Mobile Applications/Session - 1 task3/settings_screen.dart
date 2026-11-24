import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),

      body: ListView(
        children: [
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
        ],
      ),
    );
  }
}
