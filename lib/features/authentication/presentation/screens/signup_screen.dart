import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/common/widgets/custom_text_field.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/authentication/controllers/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());

    return GetBuilder<SignupController>(
      builder: (controller) => CommonBackgroundScaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackButton(controller),
                _buildHeaderSection(controller),
                _buildFormSection(controller),
                _buildTermsSection(controller),
                _buildCreateAccountButton(controller),
                _buildBottomSpacing(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Back button section
  Widget _buildBackButton(SignupController controller) {
    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 24.h),
      child: GestureDetector(
        onTap: controller.onBackPressed,
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20.w,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  /// Header section with title and subtitle
  Widget _buildHeaderSection(SignupController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Main title
          SizedBox(
            width: double.infinity,
            child: Text(
              'signup_title'.tr,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 32.sp, // H2 from Figma
                fontWeight: FontWeight.w700, // Bold
                color: AppColors.textPrimary,
              ),
            ),
          ),

          16.verticalSpace,

          // Subtitle
          SizedBox(
            width: double.infinity,
            child: Text(
              'signup_subtitle'.tr,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 16.sp, // Body/B1 from Figma
                fontWeight: FontWeight.w400, // Regular
                color: AppColors.textSecondary,
                lineHeight: 20.8, // 1.3 line height from Figma
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Form section with all input fields and language selector
  Widget _buildFormSection(SignupController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        children: [
          // Full Name Field
          _buildFullNameField(controller),

          20.verticalSpace,

          // Email Field
          _buildEmailField(controller),

          20.verticalSpace,

          // Password Field
          _buildPasswordField(controller),

          20.verticalSpace,

          // Confirm Password Field
          _buildConfirmPasswordField(controller),

          20.verticalSpace,

          // Language Selector
          _buildLanguageSelector(controller),
        ],
      ),
    );
  }

  /// Full Name input field
  Widget _buildFullNameField(SignupController controller) {
    return CustomTextField(
      label: 'full_name'.tr,
      hintText: 'enter_full_name'.tr,
      controller: controller.fullNameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      suffixIcon: Image.asset(
        'assets/icons/person.png',
        width: 16.w,
        height: 16.h,
        color: AppColors.textSecondary,
      ),
    );
  }

  /// Email input field
  Widget _buildEmailField(SignupController controller) {
    return CustomTextField(
      label: 'email_address'.tr,
      hintText: 'enter_email_address'.tr,
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      suffixIcon: Image.asset(
        'assets/icons/mail.png',
        width: 16.w,
        height: 16.h,
        color: AppColors.textSecondary,
      ),
    );
  }

  /// Password input field
  Widget _buildPasswordField(SignupController controller) {
    return Obx(
      () => CustomTextField(
        label: 'create_password'.tr,
        hintText: 'create_strong_password'.tr,
        controller: controller.passwordController,
        obscureText: controller.isPasswordHidden.value,
        textInputAction: TextInputAction.next,
        suffixIcon: GestureDetector(
          onTap: controller.togglePasswordVisibility,
          child: Icon(
            controller.isPasswordHidden.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 16.w,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Confirm Password input field
  Widget _buildConfirmPasswordField(SignupController controller) {
    return Obx(
      () => CustomTextField(
        label: 'confirm_password'.tr,
        hintText: 'confirm_your_password'.tr,
        controller: controller.confirmPasswordController,
        obscureText: controller.isConfirmPasswordHidden.value,
        textInputAction: TextInputAction.done,
        suffixIcon: GestureDetector(
          onTap: controller.toggleConfirmPasswordVisibility,
          child: Icon(
            controller.isConfirmPasswordHidden.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 16.w,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Language selector widget
  Widget _buildLanguageSelector(SignupController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(),
        GestureDetector(
          onTap: controller.onLanguagePressed,
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textSecondary, width: 1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Globe icon
                Icon(
                  Icons.language,
                  size: 12.w,
                  color: AppColors.textSecondary,
                ),

                4.horizontalSpace,

                // Language text
                Obx(
                  () => Text(
                    controller.selectedLanguage.value,
                    style: getTextStyle(
                      fontSize: 12.sp, // Body/B3 from Figma
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      lineHeight: 18, // 1.5 line height
                    ),
                  ),
                ),

                4.horizontalSpace,

                // Dropdown arrow
                Transform.rotate(
                  angle: 3.14159, // 180 degrees
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 12.w,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Terms and privacy policy agreement section
  Widget _buildTermsSection(SignupController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Obx(
            () => GestureDetector(
              onTap: controller.toggleTermsAgreement,
              child: Container(
                width: 18.w,
                height: 18.h,
                margin: EdgeInsets.only(top: 2.h, right: 8.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.isTermsAgreed.value
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(3.r),
                  color: controller.isTermsAgreed.value
                      ? AppColors.primary
                      : Colors.transparent,
                ),
                child: controller.isTermsAgreed.value
                    ? Icon(Icons.check, size: 12.w, color: Colors.white)
                    : null,
              ),
            ),
          ),

          // Terms text
          Expanded(
            child: RichText(
              text: TextSpan(
                style: getTextStyle(
                  fontSize: 12.sp, // Body/B3 from Figma
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  lineHeight: 18, // 1.5 line height
                ),
                children: [
                  TextSpan(text: 'terms_agreement'.tr),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: controller.onTermsPressed,
                      child: Text(
                        'terms_of_service'.tr,
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary,
                          lineHeight: 18,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(text: 'and'.tr),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: controller.onPrivacyPolicyPressed,
                      child: Text(
                        'privacy_policy'.tr,
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary,
                          lineHeight: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Create Account button
  Widget _buildCreateAccountButton(SignupController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Obx(
        () => CustomFilledButton(
          text: 'create_account'.tr,
          onPressed: controller.isLoading.value
              ? () {}
              : controller.onCreateAccountPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  /// Bottom spacing for proper layout
  Widget _buildBottomSpacing() {
    return SizedBox(height: 40.h);
  }
}
