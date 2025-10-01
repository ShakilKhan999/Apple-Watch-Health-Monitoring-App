import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/custom_text_field.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/account/controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangePasswordController controller = Get.put(
      ChangePasswordController(),
    );

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              _buildHeaderSection(),
              32.verticalSpace,
              _buildTitleSection(),
              24.verticalSpace,
              _buildFormSection(controller),
              32.verticalSpace,
              _buildSaveButton(controller),
              40.verticalSpace,
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

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'change_password_title'.tr,
            style: getTextStyle(
              color: AppColors.textPrimary,
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        16.verticalSpace,
        Center(
          child: Text(
            'change_password_subtitle'.tr,
            style: getTextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              lineHeight: 20.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection(ChangePasswordController controller) {
    return Column(
      children: [
        _buildCurrentPasswordField(controller),
        20.verticalSpace,
        _buildNewPasswordField(controller),
        20.verticalSpace,
        _buildConfirmPasswordField(controller),
      ],
    );
  }

  Widget _buildCurrentPasswordField(ChangePasswordController controller) {
    return Obx(
      () => CustomTextField(
        label: 'current_password_label'.tr,
        hintText: 'enter_current_password'.tr,
        controller: controller.currentPasswordController,
        obscureText: controller.isCurrentPasswordHidden.value,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
        suffixIcon: GestureDetector(
          onTap: controller.toggleCurrentPasswordVisibility,
          child: Icon(
            controller.isCurrentPasswordHidden.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 16.w,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildNewPasswordField(ChangePasswordController controller) {
    return Obx(
      () => CustomTextField(
        label: 'new_password_label'.tr,
        hintText: 'enter_new_password'.tr,
        controller: controller.newPasswordController,
        obscureText: controller.isNewPasswordHidden.value,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
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
    );
  }

  Widget _buildConfirmPasswordField(ChangePasswordController controller) {
    return Obx(
      () => CustomTextField(
        label: 'confirm_new_password_label'.tr,
        hintText: 'reenter_new_password'.tr,
        controller: controller.confirmPasswordController,
        obscureText: controller.isConfirmPasswordHidden.value,
        keyboardType: TextInputType.visiblePassword,
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

  Widget _buildSaveButton(ChangePasswordController controller) {
    return Obx(
      () => CustomFilledButton(
        text: controller.isLoading.value ? 'saving'.tr : 'save_changes'.tr,
        onPressed: controller.isLoading.value
            ? () {}
            : controller.onSaveChanges,
        height: 48.h,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
