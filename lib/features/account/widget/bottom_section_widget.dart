import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

class BottomSectionWidget extends StatelessWidget {
  const BottomSectionWidget({
    super.key,
    required this.currentIndex,
    required this.totalSteps,
    required this.onNext,
    this.nextText = 'Next',
    this.showNextButton = true,
  });

  final int currentIndex;
  final int totalSteps;
  final VoidCallback onNext;
  final String nextText;
  final bool showNextButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),

        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(totalSteps, (index) {
                final isActive = currentIndex == index;
                return Container(
                  margin: EdgeInsets.only(
                    right: index != totalSteps - 1 ? 8.w : 0,
                  ),
                  width: isActive ? 16.w : 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.grey,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              }),
            ),
          ),
        ),

        if (showNextButton)
          TextButton(
            onPressed: onNext,
            child: Row(
              children: [
                Text(
                  nextText,
                  style: getTextStyle(
                    color: AppColors.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.arrow_forward, color: AppColors.primary, size: 20.w),
              ],
            ),
          ),
      ],
    );
  }
}
