// import 'dart:async';
// import 'package:flutter/material.dart';

// class AppThemeService {
//   // Singleton pattern to ensure only one instance of AppThemeService
//   static final AppThemeService _instance = AppThemeService._internal();
//   factory AppThemeService() => _instance;
//   AppThemeService._internal();

//   final _themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
//   final StreamController<ThemeMode> _themeStreamController = StreamController<ThemeMode>.broadcast();

//   // Getter for current theme
//   ThemeMode get currentTheme => _themeNotifier.value;

//   // Setter to update the theme mode
//   void setTheme(ThemeMode themeMode) {
//     _themeNotifier.value = themeMode;
//     _themeStreamController.add(themeMode); // Add the new theme mode to the stream
//   }

//   // Stream to listen to theme changes
//   Stream<ThemeMode> get themeStream => _themeStreamController.stream;

//   // Dispose of resources
//   void dispose() {
//     _themeNotifier.dispose();
//     _themeStreamController.close();
//   }
// }
