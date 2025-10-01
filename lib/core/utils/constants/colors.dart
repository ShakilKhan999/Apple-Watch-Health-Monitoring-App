import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors from Figma Design
  static const Color primary = Color(0xFF4A7BFF); // Primary blue from Figma
  static const Color secondary = Color(0xFF2C4A99); // Secondary blue from Figma
  static const Color accent = Color(
    0xFF89A7FF,
  ); // Softer blue for a modern touch
  static const Color grey = Color(0xFF8E8E93); // Softer blue for a modern touch
  static const Color green = Color(
    0xFF34C759,
  ); // Softer blue for a modern touch

  // Background Colors from Figma
  static const Color backgroundLight = Color(
    0xFFF6F6F6,
  ); // Light background from Figma inspector - exact match
  static const Color primaryBackground = Color(0xFFFFFFFF); // Pure white

  // Text Colors from Figma
  static const Color textPrimary = Color(0xFF161618); // Primary text from Figma
  static const Color textSecondary = Color(
    0xFF8E8E93,
  ); // Secondary text from Figma
  static const Color textWhite = Colors.white;

  // Gradient Colors from Figma - EXACT positioning as described
  static const Gradient backgroundGradient = RadialGradient(
    center: Alignment(-0.7, -0.4), // Left side top area (not center, more left)
    radius: 1.2,
    colors: [
      Color(0x1F4A7BFF), // Blue with 12% opacity - left side top
      Color(0xFFF6F6F6), // Light gray/white base - rest of screen
    ],
    stops: [0.0, 0.6], // Blue fades out after 60%
  );

  // Common app background gradient (reusable) - Multiple gradients combined
  static const Gradient commonBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF6F6F6), // White/light gray base for entire screen
      Color(0xFFF6F6F6), // Consistent base color
    ],
  );

  static const Gradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF4A7BFF), Color(0xFF2C4A99)], // From Figma design
  );
  static const Gradient buttonGreenGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFEBF9EE), Color(0xFFEBF9EE)], // From Figma design
  );
  // Surface Colors
  static const Color surfaceLight = Color(0xFFE0E0E0);
  static const Color surfaceDark = Color(0xFF2C2C2C);
  static const Color backgroundDark = Color(0xFF121212);

  // Container Colors
  static const Color lightContainer = Color(0xFFF1F8E9);

  // Utility Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF29B6F6);
}
