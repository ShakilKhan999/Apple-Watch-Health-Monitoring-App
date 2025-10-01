import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/common/widgets/customize_unfilled_button.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/authentication/controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Login.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLogoSection(controller),
                    _buildHeaderSection(controller),
                    _buildButtonSection(controller),
                    _buildPrivacySection(controller),
                    _buildBottomSpacing(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Logo section with app logo
  Widget _buildLogoSection(LoginController controller) {
    return Container(
      margin: EdgeInsets.only(top: 60.h, bottom: 40.h),
      child: Container(
        width: 160.w,
        height: 160.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
        child: Image.asset(
          'assets/icons/app_icon.png',
          width: 160.w,
          height: 160.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Header section with title and subtitle
  Widget _buildHeaderSection(LoginController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 48.h),
      child: Column(
        children: [
          // Main title
          Text(
            'wellness_journey'.tr,
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          16.verticalSpace,

          // Subtitle
          Text(
            'login_subtitle'.tr,
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400, // Regular from Figma
              color: AppColors.textSecondary,
              lineHeight: 20.8, // 1.3 line height from Figma
            ),
          ),
        ],
      ),
    );
  }

  /// Button section with login and create account buttons
  Widget _buildButtonSection(LoginController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        children: [
          // Login Button (Filled)
          CustomFilledButton(
            text: 'login'.tr,
            // onPressed: controller.isLoading
            //     ? () {}
            //     : controller.onLoginPressed,
            onPressed: controller.onLoginPressed,
            // padding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),

          16.verticalSpace,

          // Create Account Button (Outlined)
          CustomUnfilledButton(
            text: 'create_account'.tr,
            onPressed: controller.onCreateAccountPressed,
            // padding: EdgeInsets.zero,
            textColor: AppColors.primary,
            borderColor: AppColors.primary,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  /// Privacy section with terms and privacy policy text
  Widget _buildPrivacySection(LoginController controller) {
    return Container(
      margin: EdgeInsets.only(top: 18.h),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: getTextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            lineHeight: 18,
          ),
          children: [
            TextSpan(text: 'by_continuing_agree'.tr),
            TextSpan(
              text: 'terms'.tr,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                lineHeight: 18,
              ),
            ),
            TextSpan(text: 'and_ampersand'.tr),
            TextSpan(
              text: 'privacy_policy'.tr,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                lineHeight: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom spacing for proper layout
  Widget _buildBottomSpacing() {
    return SizedBox(height: 40.h);
  }
}
