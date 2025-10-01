import 'package:flutter/material.dart';

class Sizer {
  final BuildContext context;
  final Size _size;

  static const double figmaScreenWidth = 393;
  static const double figmaScreenHeight = 852;

  Sizer(this.context) : _size = MediaQuery.of(context).size;

  // Width Percentage from Figma
  double wp(double width) {
    return (width / figmaScreenWidth) * _size.width;
  }

  // Height Percentage from Figma
  double hp(double height) {
    return (height / figmaScreenHeight) * _size.height;
  }

  // Font Size Percentage from Figma
  double sp(double fontSize) {
    return (fontSize / figmaScreenHeight) * _size.height;
  }
}



// class Sizer {
//   Sizer._();
//   static final size = MediaQuery.sizeOf(AppContext.currentContext);

//   static const double figmaScreenWidth = 393;
//   static const double figmaScreenHeight = 852;

//   // Width Percentage from Figma
//   static double wp(double width) {
//     return (width / figmaScreenWidth) * size.width;
//   }

//   // Height Percentage from Figma
//   static double hp(
//     double height, {
//     double figmaScreenHeight = figmaScreenHeight,
//   }) {
//     return (height / figmaScreenHeight) * size.height;
//   }

//   // Font Size Percentage from Figma
//   static double sp(double fontSize) {
//     return (fontSize / figmaScreenHeight) * size.height;
//   }
// }