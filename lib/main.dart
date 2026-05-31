// lib/main.dart
import 'package:fluid_caht_app/modules/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect',
      debugShowCheckedModeBanner: false,

      // Light theme
      theme: AppTheme.lightTheme(),

      // Dark theme
      darkTheme: AppTheme.darkTheme(),

      // 🔑 ThemeMode.system → automatically follows the device's
      // Settings → Display → Dark/Light mode toggle.
      // Change to ThemeMode.light or ThemeMode.dark to force a mode.
      themeMode: ThemeMode.system,

      home: const SplashView(),
    );
  }
}