import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/custom_text_field.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/authentication/controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller = Get.put(
      ForgotPasswordController(),
    );

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBackButton(),
              _buildHeaderSection(),
              _buildFormSection(controller),
              _buildSendResetButton(controller),
              _buildBackToLoginSection(controller),
              _buildBottomSpacing(),
            ],
          ),
        ),
      ),
    );
  }

  /// Back button at top
  Widget _buildBackButton() {
    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 32.h),
      child: GestureDetector(
        onTap: () => Get.back(),
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

  /// Header section with title and subtitle
  Widget _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          60.verticalSpace,
          // Main title
          Text(
            'forgot_password_title'.tr,
            style: getTextStyle(
              fontSize: 32.sp, // H2 from Figma
              fontWeight: FontWeight.w700, // Bold from Figma
              color: AppColors.textPrimary,
            ),
          ),

          20.verticalSpace,

          // Subtitle with proper text wrapping
          SizedBox(
            width: double.infinity,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: getTextStyle(
                  fontSize: 16.sp, // Body/B1 from Figma
                  fontWeight: FontWeight.w400, // Regular from Figma
                  color: AppColors.textSecondary,
                  lineHeight: 20.8, // 1.3 line height from Figma
                ),
                children: [TextSpan(text: 'forgot_password_subtitle'.tr)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Form section with email field
  Widget _buildFormSection(ForgotPasswordController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        children: [
          // Email field
          CustomTextField(
            label: 'email_address'.tr,
            hintText: 'enter_email_address'.tr,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Image.asset(
              'assets/icons/mail.png',
              width: 16.w,
              height: 16.h,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Send reset link button section
  Widget _buildSendResetButton(ForgotPasswordController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Obx(
        () => CustomFilledButton(
          text: controller.isLoading.value ? 'sending'.tr : 'send_otp'.tr,
          onPressed: controller.isLoading.value
              ? () {}
              : controller.onSendResetLinkPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  /// Back to login section
  Widget _buildBackToLoginSection(ForgotPasswordController controller) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: getTextStyle(
            fontSize: 14.sp, // Body/B2 from Figma
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            lineHeight: 18,
          ),
          children: [
            TextSpan(text: 'remember_password'.tr),
            WidgetSpan(
              child: GestureDetector(
                onTap: controller.onBackToLoginPressed,
                child: Text(
                  'back_to_login'.tr,
                  style: getTextStyle(
                    fontSize: 14.sp, // Body/B2 from Figma
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    lineHeight: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom spacing for proper layout
  Widget _buildBottomSpacing() {
    return 40.verticalSpace;
  }
}
