import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/custom_text_field.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/authentication/controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(
      ResetPasswordController(),
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
                        _buildHeaderSection(controller),
                        _buildFormSection(controller),
                        _buildResetButton(controller),
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
  Widget _buildBackButton(ResetPasswordController controller) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 8.h, bottom: 32.h),
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

  /// Header section with title
  Widget _buildHeaderSection(ResetPasswordController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 48.h),
      alignment: Alignment.center,
      child: Text(
        'reset_password_title'.tr,
        style: getTextStyle(
          fontSize: controller.titleFontSize,
          fontWeight: FontWeight.w700, // Bold from Figma
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  /// Form section with password fields
  Widget _buildFormSection(ResetPasswordController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New password field
          Obx(
            () => CustomTextField(
              label: 'new_password'.tr,
              hintText: 'type_password'.tr,
              controller: controller.newPasswordController,
              obscureText: controller.isNewPasswordHidden.value,
              suffixIcon: GestureDetector(
                onTap: controller.toggleNewPasswordVisibility,
                child: Icon(
                  controller.isNewPasswordHidden.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 16.w,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          20.verticalSpace,

          // Confirm password field
          Obx(
            () => CustomTextField(
              label: 'confirm_password'.tr,
              hintText: 'repeat_password'.tr,
              controller: controller.confirmPasswordController,
              obscureText: controller.isConfirmPasswordHidden.value,
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
          ),
        ],
      ),
    );
  }

  /// Reset password button section
  Widget _buildResetButton(ResetPasswordController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Obx(
        () => CustomFilledButton(
          text: 'reset_password_button'.tr,
          onPressed: controller.isLoading.value
              ? () {}
              : controller.onResetPasswordPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
