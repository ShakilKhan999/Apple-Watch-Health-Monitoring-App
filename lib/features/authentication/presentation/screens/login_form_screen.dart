import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/custom_text_field.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/authentication/controllers/login_form_controller.dart';

class LoginFormScreen extends StatelessWidget {
  const LoginFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginFormController controller = Get.put(LoginFormController());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: controller.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(),
              _buildHeaderSection(controller),
              _buildFormSection(controller),
              _buildLoginButton(controller),
              _buildSocialLoginSection(controller),
              _buildSignUpSection(controller),
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
  Widget _buildHeaderSection(LoginFormController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 48.h),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Main title
          Text(
            'login_welcome_title'.tr,
            style: getTextStyle(
              fontSize: controller.titleFontSize,
              fontWeight: FontWeight.w700, // Bold from Figma
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: controller.headerSpacing),

          // Subtitle
          Text(
            'login_welcome_subtitle'.tr,
            style: getTextStyle(
              fontSize: controller.subtitleFontSize,
              fontWeight: FontWeight.w400, // Regular from Figma
              color: AppColors.textSecondary,
              lineHeight: 20.8, // 1.3 line height from Figma
            ),
          ),
        ],
      ),
    );
  }

  /// Form section with email and password fields
  Widget _buildFormSection(LoginFormController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      child: Column(
        children: [
          // Email field
          CustomTextField(
            label: 'login_email_label'.tr,
            hintText: 'login_email_hint'.tr,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Image.asset(
              'assets/icons/mail.png',
              width: 16.w,
              height: 16.h,
              color: AppColors.textSecondary,
            ),
          ),

          20.verticalSpace,

          // Password field
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: 'password'.tr,
                  hintText: 'login_password_hint'.tr,
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
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

                SizedBox(height: 8.h),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: controller.onForgotPasswordPressed,
                    child: Text(
                      'login_forgot_password'.tr,
                      style: getTextStyle(
                        fontSize: controller.linkTextFontSize,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Login button section
  Widget _buildLoginButton(LoginFormController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        children: [
          // Login Button (Filled)
          Obx(
            () => CustomFilledButton(
              text: 'login'.tr,
              onPressed: controller.isLoading.value
                  ? () {}
                  : controller.onLoginPressed,
              padding: EdgeInsets.zero,
            ),
          ),

          SizedBox(height: 16.h),

          // Terms & Privacy Policy text
          Text(
            'login_terms_agreement'.tr,
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 12.sp, // Body/B3 from Figma
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              lineHeight: 18, // 1.5 line height from Figma
            ),
          ),
        ],
      ),
    );
  }

  /// Social login section with Google and Apple
  Widget _buildSocialLoginSection(LoginFormController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h, top: 32.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Google login
          _buildSocialButton(
            onTap: controller.onGoogleLoginPressed,
            child: SizedBox(
              width: 24.w,
              height: 24.h,

              child: Image.asset('assets/icons/google_icons.png'),
            ),
          ),

          SizedBox(width: 16.w),

          // Apple login
          _buildSocialButton(
            onTap: controller.onAppleLoginPressed,
            child: Icon(Icons.apple, size: 24.w, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  /// Social login button
  Widget _buildSocialButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 77.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7).withValues(alpha: 0.32),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF8E8E93).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }

  /// Sign up section
  Widget _buildSignUpSection(LoginFormController controller) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: getTextStyle(
            fontSize: controller.linkTextFontSize,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            lineHeight: 18,
          ),
          children: [
            TextSpan(text: 'login_no_account'.tr),
            WidgetSpan(
              child: GestureDetector(
                onTap: controller.onSignUpPressed,
                child: Text(
                  'signup'.tr,
                  style: getTextStyle(
                    fontSize: controller.linkTextFontSize,
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
    return SizedBox(height: 40.h);
  }
}
