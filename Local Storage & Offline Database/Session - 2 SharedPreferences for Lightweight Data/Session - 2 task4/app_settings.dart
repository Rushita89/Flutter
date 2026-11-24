import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  bool _isDarkMode;
  bool _loggedIn;
  String _studentName;

  AppSettings({
    required bool isDarkMode,
    required bool loggedIn,
    required String studentName,
  })  : _isDarkMode = isDarkMode,
        _loggedIn = loggedIn,
        _studentName = studentName;

  bool get isDarkMode => _isDarkMode;
  bool get loggedIn => _loggedIn;
  String get studentName => _studentName;

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }

  Future<void> toggleLogin() async {
    _loggedIn = !_loggedIn;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', _loggedIn);
  }

  Future<bool> saveStudentName(String name) async {
    String trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_name', trimmedName);

    _studentName = trimmedName;
    notifyListeners();

    return true;
  }

  // Reset all saved preferences
  Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('dark_mode');
    await prefs.remove('logged_in');
    await prefs.remove('student_name');

    _isDarkMode = false;
    _loggedIn = false;
    _studentName = '';

    notifyListeners();
  }
}
