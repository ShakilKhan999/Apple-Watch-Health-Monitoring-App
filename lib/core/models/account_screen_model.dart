import 'package:flutter/material.dart';

class PersonalInfo {
  final String name;
  final String email;
  final String profileImageUrl;

  PersonalInfo({
    required this.name,
    required this.email,
    required this.profileImageUrl,
  });
}

class HealthMetric {
  final String iconPath;
  final Color iconBackgroundColor;
  final String title;
  final String quantity;
  final String subtitle;
  final String level;

  HealthMetric({
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.title,
    required this.quantity,
    required this.subtitle,
    required this.level,
  });
}

class SettingsOption {
  final String title;
  final VoidCallback onTap;
  final String leadingicon;

  SettingsOption({
    required this.title,
    required this.onTap,
    required this.leadingicon,
  });
}
