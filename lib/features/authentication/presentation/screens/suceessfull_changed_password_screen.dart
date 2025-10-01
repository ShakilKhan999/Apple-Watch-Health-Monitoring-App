import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/authentication/controllers/successful_password_controller.dart';

class SuccessfulPasswordScreen extends StatelessWidget {
  const SuccessfulPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SuccessfulPasswordController controller = Get.put(
      SuccessfulPasswordController(),
    );

    return CommonBackgroundScaffold(
      body: SafeArea(
        child: Padding(
          padding: controller.screenPadding,
          child: Column(
            children: [
              _buildBackButton(controller),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildSuccessIcon(controller),
                        _buildHeaderSection(controller),
                        _buildSubtitleSection(controller),
                        _buildLoginButton(controller),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Back button at top
  Widget _buildBackButton(SuccessfulPasswordController controller) {
    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 32.h),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: controller.onBackPressed,
        child: Container(
          padding: EdgeInsets.all(8.w),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20.w,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Success icon section
  Widget _buildSuccessIcon(SuccessfulPasswordController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      child: SizedBox(
        width: 60.w,
        height: 60.h,

        child: Image.asset('assets/icons/success.png'),
      ),
    );
  }

  /// Header section with title
  Widget _buildHeaderSection(SuccessfulPasswordController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: controller.headerSpacing),
      child: Text(
        'password_changed_title'.tr,
        style: getTextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w700, // Bold from Figma
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Subtitle section with description
  Widget _buildSubtitleSection(SuccessfulPasswordController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Text(
        'password_changed_subtitle'.tr,
        textAlign: TextAlign.center,
        style: getTextStyle(
          fontSize: controller.subtitleFontSize,
          fontWeight: FontWeight.w400, // Regular from Figma
          color: AppColors.textSecondary,
          lineHeight: 20.8, // 1.3 line height from Figma
        ),
      ),
    );
  }

  /// Login button section
  Widget _buildLoginButton(SuccessfulPasswordController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h, top: 24.h),
      child: Obx(
        () => CustomFilledButton(
          text: 'login'.tr,
          onPressed: controller.isLoading.value
              ? () {}
              : controller.onLogInPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
