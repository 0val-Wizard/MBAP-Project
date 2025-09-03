import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  // Singleton pattern to ensure only one instance of ThemeService
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final _themeStreamController = StreamController<ThemeMode>.broadcast();
  SharedPreferences? _prefs;
  ThemeMode _currentTheme = ThemeMode.light;  // Add this private field

  // Getter for the theme stream
  Stream<ThemeMode> get themeStream => _themeStreamController.stream;

  // Getter for the current theme
  ThemeMode get currentTheme => _currentTheme;  // Add this getter

  // Method to set the theme and save it to shared preferences
  void setTheme(ThemeMode themeMode) async {
    _currentTheme = themeMode;  // Update the current theme
    _themeStreamController.add(themeMode);
    _prefs = await SharedPreferences.getInstance();
    await _prefs!.setString('selectedTheme', themeMode == ThemeMode.dark ? 'dark' : 'light');
    debugPrint('Theme: ' + (themeMode == ThemeMode.dark ? 'dark' : 'light'));
  }

  // Method to load the theme from shared preferences
  Future<void> loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    ThemeMode currentTheme = ThemeMode.light;

    if (_prefs!.containsKey('selectedTheme')) {
      String selectedTheme = _prefs!.getString('selectedTheme')!;
      currentTheme = selectedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    _currentTheme = currentTheme;  // Update the current theme
    _themeStreamController.add(currentTheme);
  }

  // Dispose of the StreamController when it is no longer needed
  void dispose() {
    _themeStreamController.close();
  }
}