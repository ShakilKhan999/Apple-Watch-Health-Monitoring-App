import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/account/screen/account_deactivate_screen.dart';
import 'package:surajashray/features/account/screen/connect_wearable_settings_screen.dart';
import 'package:surajashray/features/account/screen/notification_settings_screen.dart';
import 'package:surajashray/features/account/screen/language_region_screen.dart';
import 'package:surajashray/features/account/screen/security_settings_screen.dart';

enum SettingsType {
  notification,
  languageRegion,
  integration,
  security,
  accountDeactivation,
}

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.h.verticalSpace,
              _buildHeaderSection(),
              Center(
                child: Text(
                  'settings_title'.tr,
                  style: getTextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              15.verticalSpace,
              _buildSettingsSection(),
              32.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 24.w,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    final List<SettingsType> settingsTypes = [
      SettingsType.notification,
      SettingsType.languageRegion,
      SettingsType.integration,
      SettingsType.security,
      SettingsType.accountDeactivation,
    ];

    return Column(
      children: settingsTypes.map((settingsType) {
        return _buildSettingsItem(settingsType);
      }).toList(),
    );
  }

  Widget _buildSettingsItem(SettingsType settingsType) {
    String title;
    String iconPath;
    VoidCallback onTap;

    switch (settingsType) {
      case SettingsType.notification:
        title = "settings_notification".tr;
        iconPath = IconPath.reminder;
        onTap = () => Get.to(() => NotificationSettingsScreen());
        break;
      case SettingsType.languageRegion:
        title = "settings_language_region".tr;
        iconPath = IconPath.region;
        onTap = () => Get.to(() => LanguageRegionScreen());
        break;
      case SettingsType.integration:
        title = "settings_integration".tr;
        iconPath = IconPath.integration;
        onTap = () => Get.to(() => ConnectWearableSettingsScreen());
        break;
      case SettingsType.security:
        title = "settings_security".tr;
        iconPath = IconPath.security;
        onTap = () => Get.to(() => SecuritySettingsScreen());
        break;
      case SettingsType.accountDeactivation:
        title = "settings_account_deactivation".tr;
        iconPath = IconPath.deactivation;
        onTap = () => Get.to(() => AccountDeactivateScreen());
        break;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        title: Text(
          title,
          style: getTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: AppColors.grey,
        ),
        leading: Container(
          width: 40.sp,
          height: 40.sp,
          decoration: BoxDecoration(
            color: Color(0xFFC7D6FF),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(iconPath, width: 20.sp, height: 20.sp),
        ),
        onTap: onTap,
      ),
    );
  }
}
