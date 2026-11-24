import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: context.read<AppSettings>().studentName,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> saveName() async {
    final settings = context.read<AppSettings>();

    bool saved = await settings.saveStudentName(
      nameController.text,
    );

    if (!mounted) return;

    if (saved) {
      nameController.text = nameController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name saved successfully!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid name.'),
        ),
      );
    }
  }

  Future<void> resetSettings() async {
    await context.read<AppSettings>().resetPreferences();

    if (!mounted) return;

    nameController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences reset successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveName,
                child: const Text('Save'),
              ),
            ),

            const SizedBox(height: 25),

            const Divider(),

            SwitchListTile(
              title: const Text('Dark Mode'),
              value: settings.isDarkMode,
              onChanged: (value) {
                settings.toggleDarkMode(value);
              },
            ),

            const Divider(),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await settings.toggleLogin();
                },
                child: Text(
                  settings.loggedIn ? 'Log out' : 'Log in',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Reset Preferences Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: resetSettings,
                child: const Text('Reset preferences'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
