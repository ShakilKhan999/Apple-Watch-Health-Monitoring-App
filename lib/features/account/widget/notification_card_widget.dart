import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/models/notification_card_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationCardModel cardModel;
  final VoidCallback onToggle;

  const NotificationCardWidget({
    super.key,
    required this.cardModel,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = cardModel.isEnabled;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: cardModel.iconBackgroundColor ?? AppColors.grey,
              shape: BoxShape.circle,
              border: Border.all(
                color: isEnabled ? Colors.transparent : Colors.transparent,
                width: 1.5.r,
              ),
            ),
            padding: EdgeInsets.all(8.r),
            child: SvgPicture.asset(cardModel.iconPath, fit: BoxFit.contain),
          ),

          const SizedBox(width: 12),

          // Title + Subtitle
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
                const SizedBox(height: 4),
                Text(
                  cardModel.subtitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Toggle button
          Switch(
            value: isEnabled,
            onChanged: (_) => onToggle(),
            activeColor: Color(0xFFE8F5E9),
            activeTrackColor: Colors.green,
            inactiveThumbColor: Color(
              0xFFECEFF1,
            ), // Change this to your preferred inactive thumb color
            inactiveTrackColor: Color(0xFFB0BEC5),
          ),
        ],
      ),
    );
  }
}
