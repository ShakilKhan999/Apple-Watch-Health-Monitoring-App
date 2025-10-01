import 'package:flutter/material.dart';

class CustomCardModel {
  final String title;
  final String? subtitle;
  final String leftIconPath;
  final String? rightIconPath;
  final Color backgroundColor;
  final Color borderColor;
  final Color? iconBackgroundColor;
  final bool isSelected; 

  CustomCardModel({
    required this.title,
    this.subtitle,
    required this.leftIconPath,
    this.rightIconPath,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color.fromARGB(255, 224, 224, 224), // Lighter grey
    this.iconBackgroundColor,
    this.isSelected = false, 
  });

  
  CustomCardModel copyWith({
    String? title,
    String? subtitle,
    String? leftIconPath,
    String? rightIconPath,
    Color? backgroundColor,
    Color? borderColor,
    Color? iconBackgroundColor,
    bool? isSelected,
  }) {
    return CustomCardModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      leftIconPath: leftIconPath ?? this.leftIconPath,
      rightIconPath: rightIconPath ?? this.rightIconPath,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
