import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {

  bool _isDarkMode;
  bool _loggedIn;

  // Constructor
  AppSettings({
    required bool isDarkMode,
    required bool loggedIn,
  })  : _isDarkMode = isDarkMode,
        _loggedIn = loggedIn;

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

  // Login / Logout and save status
  Future<void> toggleLogin() async {

    _loggedIn = !_loggedIn;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('logged_in', _loggedIn);
  }
}
