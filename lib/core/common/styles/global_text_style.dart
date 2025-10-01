import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle getTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 29.0,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    // height: lineHeight / fontSize,
    // height: fontSize.sp / lineHeight.sp,
    height: lineHeight / fontSize,
    color: color,
  );
}

TextStyle getTextStyleSecondary({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 20.0,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    // height: lineHeight / fontSize,
    // height: fontSize.sp / lineHeight.sp,
    height: lineHeight / fontSize,
    color: color,
  );
}
