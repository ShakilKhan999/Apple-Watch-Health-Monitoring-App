import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/models/customize_card_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

class CustomCardWidget extends StatelessWidget {
  final CustomCardModel cardModel;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap; // Make the onTap callback nullable (optional)

  const CustomCardWidget({
    super.key,
    required this.cardModel,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap, // Add the optional onTap to the constructor
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = cardModel.isSelected;
    final Color activeColor = AppColors.green;

    final Color currentBorderColor = isSelected
        ? activeColor
        : cardModel.borderColor;
    final double borderWidth = isSelected ? 2.0 : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding.r,
        decoration: BoxDecoration(
          color: cardModel.backgroundColor,
          border: Border.all(color: currentBorderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Icon Container
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                // color: isSelected
                //     ? (cardModel.iconBackgroundColor ??
                //           Colors.transparent)
                //     : Colors.transparent,
                color: cardModel.iconBackgroundColor ?? Colors.transparent,

                shape: BoxShape.circle,
                border: isSelected
                    ? null
                    : Border.all(color: Colors.transparent),
              ),
              padding: EdgeInsets.all(8.r),
              child: SvgPicture.asset(
                cardModel.leftIconPath,
                fit: BoxFit.contain,
              ),
            ),

            12.w.horizontalSpace,

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardModel.title,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (cardModel.subtitle != null) ...[
                    4.h.verticalSpace,
                    Text(
                      cardModel.subtitle!,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        lineHeight: 18.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Conditional Right Icon Logic **
            if (isSelected) ...[
              12.w.horizontalSpace,
              // Show a checkmark icon when the card is selected
              Icon(Icons.check_circle, color: activeColor, size: 24.r),
            ] else if (cardModel.rightIconPath != null) ...[
              12.w.horizontalSpace,
              // Show the default right icon if provided and not selected
              SvgPicture.asset(
                cardModel.rightIconPath!,
                width: 24.r,
                height: 24.r,
                colorFilter: ColorFilter.mode(
                  // Colors.grey.shade400,
                  Colors.transparent,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
