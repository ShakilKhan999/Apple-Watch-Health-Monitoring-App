import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';

class CustomUnfilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Widget? iconWidget;
  final double iconSize;
  final Color iconColor;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsets padding;

  const CustomUnfilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.iconSize = 16,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.black12,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final double responsiveIconSize = iconSize.r;

    return SizedBox(
      width: double.infinity,
      // padding: padding.r,
      child: ElevatedButton(
        onPressed: onPressed,
        // style: ElevatedButton.styleFrom(
        //   backgroundColor: backgroundColor,
        //   foregroundColor: textColor,
        //   padding: EdgeInsets.symmetric(
        //     vertical: 10.h,
        //   ),
        //   elevation: 0,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(
        //       12.r,
        //     ),
        //     side: BorderSide(color: borderColor),
        //   ),
        // ).copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(backgroundColor),
          foregroundColor: WidgetStateProperty.all(textColor),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(vertical: 10.h),
          ),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(WidgetState.pressed)) {
              return BorderSide(color: borderColor);
            }
            if (states.contains(WidgetState.hovered)) {
              return BorderSide(color: borderColor);
            }
            if (states.contains(WidgetState.focused)) {
              return BorderSide(color: borderColor);
            }
            return BorderSide(color: borderColor);
          }),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconWidget != null)
              iconWidget!
            else if (icon != null)
              Icon(icon, size: responsiveIconSize, color: iconColor),

            if (iconWidget != null || icon != null) 8.w.horizontalSpace,

            Text(
              text,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
