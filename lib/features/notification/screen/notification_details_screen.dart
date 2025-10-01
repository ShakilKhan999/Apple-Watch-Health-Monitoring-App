import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surajashray/core/models/notification_model.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailsScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title / Icon Row
            Row(
              children: [
                _buildSourceIcon(notification.source),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    notification.source.toUpperCase(),
                    style: getTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, size: 20.sp, color: Colors.grey),
                ),
              ],
            ),
            16.verticalSpace,

            // Message Body
            Text(
              notification.message,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
            16.verticalSpace,

            // Time
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                notification.time,

                style: getTextStyle(fontSize: 12.sp, color: AppColors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceIcon(String source) {
    String assetPath;
    switch (source.toLowerCase()) {
      case "vidhme":
        assetPath = "assets/icons/app_icon.png";
        break;
      case "google":
        assetPath = "assets/icons/google.svg";
        break;
      case "strava":
        assetPath = "assets/icons/strava.svg";
        break;
      default:
        assetPath = "assets/icons/reminder.svg"; // fallback to PNG
    }

    if (assetPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(assetPath, width: 28.w, height: 28.w);
    } else {
      return Image.asset(
        assetPath,
        width: 28.w,
        height: 28.w,
        fit: BoxFit.contain,
      );
    }
  }
}
