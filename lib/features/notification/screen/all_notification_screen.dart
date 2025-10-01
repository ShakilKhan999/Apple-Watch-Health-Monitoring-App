import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/models/notification_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/notification/controller/all_notification_controller.dart';
import 'package:surajashray/features/notification/screen/notification_details_screen.dart';

class AllNotificationScreen extends StatelessWidget {
  const AllNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AllNotificationController controller = Get.put(
      AllNotificationController(),
    );

    return CommonBackgroundScaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              10.h.verticalSpace,
              _buildHeaderSection(),
              _buildTitleSection(),
              16.verticalSpace,
              Expanded(
                child: Obx(() {
                  final notifications = controller.notifications;
                  if (notifications.isEmpty) {
                    return Center(
                      child: Text(
                        "no_notifications_yet".tr,
                        style: getTextStyle(),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (_, index) {
                      final n = notifications[index];
                      return _buildNotificationTile(n, controller);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() => Align(
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      onTap: () => Get.back(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 24.w,
          color: AppColors.textSecondary,
        ),
      ),
    ),
  );

  Widget _buildTitleSection() => Column(
    children: [
      Text(
        "notifications_title".tr,
        style: getTextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ],
  );

  Widget _buildNotificationTile(
    NotificationModel notification,
    AllNotificationController controller,
  ) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        controller.deleteNotification(notification.id);
        Get.snackbar(
          "notification_deleted".tr,
          "notification_removed".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black.withValues(alpha: .7),
          colorText: Colors.white,
          margin: EdgeInsets.all(12.w),
          duration: const Duration(seconds: 2),
        );
      },

      child: GestureDetector(
        onTap: () {
          controller.markAsRead(notification.id);
          // Get.toNamed(notificationDetailsScreen, arguments: yourNotificationModel);

          // Get.to(() => NotificationDetailsScreen(notification: notification));
          Get.dialog(NotificationDetailsScreen(notification: notification));
        },
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.transparent : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1 → icon + message
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSourceIcon(notification.source),
                  10.w.horizontalSpace,
                  Expanded(
                    child: Text(
                      notification.message,
                      maxLines: 1, // limit lines here
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: notification.isRead
                            ? FontWeight.w400
                            : FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              6.h.verticalSpace,
              // Row 2 → date/time
              Text(
                notification.time,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
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
