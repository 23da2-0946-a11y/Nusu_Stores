import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF276A3D);
  static const Color primaryLight = Color(0xFF4CA556);
  static const Color primaryDark = Color(0xFF1B4D2C);
  
  // Secondary / Accent
  static const Color accent = Color(0xFF8CC18D);
  static const Color accentLight = Color(0xFFE8EED3);
  
  // Neutral Palette
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6E6A);
  static const Color textHint = Color(0xFFADADAD);
  
  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color(0xFFE9ECEF)],
  );
}
