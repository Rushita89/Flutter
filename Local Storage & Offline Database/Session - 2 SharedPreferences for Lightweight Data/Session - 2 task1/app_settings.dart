import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {

  bool _isDarkMode;
  bool _loggedIn = false;

  // Constructor
  AppSettings({required bool isDarkMode})
      : _isDarkMode = isDarkMode;

  // Dark mode getter
  bool get isDarkMode => _isDarkMode;

  // Login getter
  bool get loggedIn => _loggedIn;

  // Change and save dark mode
  Future<void> toggleDarkMode(bool value) async {

    _isDarkMode = value;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('dark_mode', value);
  }

  // Login / Logout
  void toggleLogin() {
    _loggedIn = !_loggedIn;

    notifyListeners();
  }
}
