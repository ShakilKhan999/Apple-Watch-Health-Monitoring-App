import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final int maxLines;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: getTextStyle(
            fontSize: 16.sp, // Body/B1 from Figma
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
            lineHeight: 20.8,
          ),
        ),

        12.verticalSpace,

        // Input field
        Container(
          height: maxLines == 1 ? 46.h : null,
          constraints: maxLines != 1 ? BoxConstraints(minHeight: 46.h) : null,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8), // Input background color
            borderRadius: BorderRadius.circular(12.r),
            // No border as requested
          ),
          alignment: Alignment.center,
          child: TextField(
            cursorColor: AppColors.primary,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            enabled: enabled,
            maxLines: maxLines,
            textInputAction: textInputAction,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: getTextStyle(
              fontSize: 14.sp, // Body/B2 from Figma
              fontWeight: FontWeight.w400,
              color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: getTextStyle(
                fontSize: 14.sp, // Body/B2 from Figma
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 12.w),
                      child: prefixIcon,
                    )
                  : null,
              prefixIconConstraints: prefixIcon != null
                  ? BoxConstraints(minWidth: 16.w, minHeight: 16.h)
                  : null,
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: suffixIcon,
                    )
                  : null,
              suffixIconConstraints: suffixIcon != null
                  ? BoxConstraints(minWidth: 16.w, minHeight: 16.h)
                  : null,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                // vertical: maxLines == 1 ? 12.h : 16.h,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
