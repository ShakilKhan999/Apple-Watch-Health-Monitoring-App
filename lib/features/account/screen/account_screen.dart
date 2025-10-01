import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/models/account_screen_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/account/controller/account_screen_controller.dart';
import 'package:surajashray/features/account/screen/edit_profile_screen.dart';
import '../../../core/utils/constants/icon_path.dart';

class AccountScreen extends StatelessWidget {
  // const AccountScreen({super.key});
  final AccountScreenController controller = AccountScreenController();

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              personalInfoSection(controller.personalInfo),
              32.h.verticalSpace,
              Text(
                'health_metrics'.tr,
                style: getTextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22.sp,
                  color: Colors.black,
                ),
              ),
              8.h.verticalSpace,
              healthMetricsSection(controller.healthMetrics),
              32.h.verticalSpace,
              settingsFaqSection(controller.settingsOptions),
              32.h.verticalSpace,
              logOutSection(controller.logOut),
              150.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget personalInfoSection(PersonalInfo info) {
    return Column(
      children: [
        20.verticalSpace,
        Text(
          'my_profile'.tr,
          style: getTextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        15.verticalSpace,
        Center(
          child: CircleAvatar(
            radius: 50.r,
            backgroundImage: NetworkImage(info.profileImageUrl),
          ),
        ),
        16.h.verticalSpace,
        Center(
          child: Text(
            info.name,
            style: getTextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        8.h.verticalSpace,
        Center(
          child: Text(
            info.email,
            style: getTextStyle(
              fontSize: 14.sp,
              color: AppColors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        16.h.verticalSpace,
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 0.5.sw, // max 50% of screen width
              minWidth: 100.w, // minimum width
            ),
            child: OutlinedButton(
              onPressed: () {
                Get.to(EditProfileScreen());
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w, // horizontal padding responsive
                  vertical: 5.h, // vertical padding responsive
                ),
                backgroundColor: Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    IconPath.edit,
                    width: 20.sp,
                    height: 20.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: Text(
                      'edit_profile'.tr,
                      style: getTextStyle(
                        color: AppColors.primary,
                        fontSize:
                            14.sp +
                            (2 *
                                (0.5.sw > 400
                                    ? 1
                                    : 0)), // base 14sp, add 2 if width > 400
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget healthMetricsSection(List<HealthMetric> metrics) {
    return Column(
      children: metrics.map((metric) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon with background circle (rowspan)
              Container(
                decoration: BoxDecoration(
                  color: metric.iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(12.r),
                child: SvgPicture.asset(
                  metric.iconPath,
                  width: 28.sp,
                  height: 28.sp,
                ),
              ),
              SizedBox(width: 12.w),

              // Right side: Two rows stacked vertically
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1st row: title (left), quantity (right)
                    Row(
                      children: [
                        Text(
                          metric.title,
                          style: getTextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        Text(
                          metric.quantity,
                          style: getTextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6.h),

                    // 2nd row: subtitle (left), level (right)
                    Row(
                      children: [
                        Text(
                          metric.subtitle,
                          style: getTextStyle(
                            color: AppColors.grey,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        Text(
                          metric.level,
                          style: getTextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget settingsFaqSection(List<SettingsOption> options) {
    return Column(
      children: options.map((option) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListTile(
            title: Text(
              option.title,
              style: getTextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),

            /// 👇 Circular background for leading icon
            leading: option.leadingicon != null
                ? Container(
                    width: 40.sp,
                    height: 40.sp,
                    decoration: BoxDecoration(
                      color: Color(0xFFC7D6FF), // Set background color here
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      option.leadingicon,
                      width: 20.sp,
                      height: 20.sp,
                    ),
                  )
                : null,

            onTap: option.onTap,
          ),
        );
      }).toList(),
    );
  }

  Widget logOutSection(VoidCallback onConfirmed) {
    return Center(
      child: CustomFilledButton(
        text: 'logout_button'.tr,
        onPressed: () {
          Get.dialog(
            AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),

              content: Text(
                'logout_confirmation'.tr,
                style: getTextStyle(fontSize: 16.sp, color: Colors.black),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(), // Close dialog
                  child: Text(
                    'cancel'.tr,
                    style: getTextStyle(
                      color: AppColors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    onConfirmed(); // Call logout
                  },
                  child: Text(
                    'log_out'.tr,
                    style: getTextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },

        padding: EdgeInsets.zero,
        // iconPath: IconPath.logout,
        icon: Icons.logout,
      ),
    );
  }
}
