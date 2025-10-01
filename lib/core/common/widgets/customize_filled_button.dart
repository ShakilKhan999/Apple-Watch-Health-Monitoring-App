import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Widget? iconWidget;
  final String? iconPath;
  final double iconSize;
  final Color iconColor;
  final EdgeInsetsGeometry padding;
  final double? height;
  final double? width;

  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.iconPath,
    this.iconSize = 16,
    this.iconColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Make icon responsive
    final double responsiveIconSize = iconSize.r;

    Widget? resolvedIcon;

    if (iconWidget != null) {
      resolvedIcon = iconWidget;
    } else if (icon != null) {
      resolvedIcon = Icon(icon, size: responsiveIconSize, color: iconColor);
    } else if (iconPath != null) {
      if (iconPath!.endsWith('.svg')) {
        resolvedIcon = SvgPicture.asset(
          iconPath!,
          width: responsiveIconSize,
          height: responsiveIconSize,
          color: iconColor,
        );
      } else {
        resolvedIcon = Image.asset(
          iconPath!,
          width: responsiveIconSize,
          height: responsiveIconSize,
          color: iconColor,
        );
      }
    }

    return Container(
      height: height ?? 50.h,
      width: width ?? double.infinity,
      padding: (padding as EdgeInsets).r,
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              side: WidgetStateProperty.all(BorderSide.none),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: getTextStyleSecondary(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            5.w.horizontalSpace,
            if (resolvedIcon != null) ...[resolvedIcon, 8.w.horizontalSpace],
          ],
        ),
      ),
    );
  }
}
