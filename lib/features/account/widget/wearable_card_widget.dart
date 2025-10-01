import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/models/wearable_card_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

class WearableCardWidget extends StatelessWidget {
  final WearableCardModel cardModel;
  final VoidCallback onToggle;

  const WearableCardWidget({
    super.key,
    required this.cardModel,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isConnected = cardModel.isConnected;

    return Container(
      padding: EdgeInsets.all(16.r), // Responsive padding
      margin: EdgeInsets.only(bottom: 16.h), // Responsive margin
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isConnected ? Colors.transparent : Colors.transparent,
          width: 1.5.r,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          /// Left Icon
          SvgPicture.asset(cardModel.iconPath, width: 40.r, height: 40.r),

          12.w.horizontalSpace, // Use your extension here
          /// Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardModel.title,
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                4.h.verticalSpace,
                Text(
                  isConnected ? "Connected" : cardModel.subtitle,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: isConnected ? AppColors.green : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: 0.w),
            child: SizedBox(
              width: 100.w,
              height: 38.h,
              child: ElevatedButton(
                onPressed: onToggle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isConnected
                      ? Colors.white
                      : AppColors.primary,
                  side: isConnected
                      ? BorderSide(color: AppColors.grey, width: 1.5.r)
                      : BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical:
                        0, // Remove vertical padding since height is fixed
                  ),
                  elevation: 0,
                ),
                child: Center(
                  // wrap text in Center for perfect vertical + horizontal centering
                  child: Text(
                    isConnected ? "Disconnect" : "Connect",
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isConnected ? AppColors.grey : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
