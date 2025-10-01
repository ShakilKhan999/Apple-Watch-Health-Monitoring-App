import 'package:flutter/material.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

class NotificationCardModel {
  final String title;
  final String subtitle;
  final String iconPath;
  final bool isEnabled;
  final Color iconBackgroundColor;

  NotificationCardModel({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.isEnabled = false,
    this.iconBackgroundColor = AppColors.grey,
  });

  NotificationCardModel copyWith({
    String? title,
    String? subtitle,
    String? iconPath,
    bool? isEnabled,
    Color? iconBackgroundColor,
  }) {
    return NotificationCardModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      iconPath: iconPath ?? this.iconPath,
      isEnabled: isEnabled ?? this.isEnabled,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
    );
  }
}
