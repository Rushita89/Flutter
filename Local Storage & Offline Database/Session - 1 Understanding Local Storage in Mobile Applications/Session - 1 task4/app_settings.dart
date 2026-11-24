import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _loggedIn = false;

  // Dark mode getter
  bool get isDarkMode => _isDarkMode;

  // Login getter
  bool get loggedIn => _loggedIn;

  // Change dark mode
  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // Login and Logout
  void toggleLogin() {
    _loggedIn = !_loggedIn;
    notifyListeners();
  }
}
