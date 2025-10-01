import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/routes/app_routes.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

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
                  'privacy_security_title'.tr,
                  style: getTextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
              15.verticalSpace,
              changePasswordCardSection(),
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

  Widget changePasswordCardSection() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoute.changePasswordScreen),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Color(0xFFC7D6FF),
                  borderRadius: BorderRadius.circular(30.w),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    IconPath.key, // Replace with your SVG path
                    width: 30.w,
                    height: 30.w,
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // Right section: Column with Title, Subtitle and Forward Icon
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'change_password'.tr,
                      style: getTextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,

                        // Right section: Column with Title, Subtitle and Forward Icon
                      ),
                    ),

                    Text(
                      'last_changed_3_months_ago'.tr,
                      style: getTextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.w),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20.w,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
