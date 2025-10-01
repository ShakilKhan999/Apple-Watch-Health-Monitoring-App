import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/authentication/controllers/verify_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VerifyController controller = Get.put(VerifyController());

    return CommonBackgroundScaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              _buildBackButton(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeaderSection(controller),
                        _buildOtpInputSection(controller),
                        _buildButtonSection(controller),
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

  Widget _buildBackButton() {
    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
      child: Align(
        alignment: Alignment.centerLeft,
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
      ),
    );
  }

  Widget _buildHeaderSection(VerifyController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Main title
          Text(
            'check_your_email'.tr,
            style: getTextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          24.verticalSpace,

          Column(
            children: [
              Text(
                'otp_sent_message'.tr,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  lineHeight: 20.8,
                ),
              ),

              8.verticalSpace,

              Obx(
                () => Text(
                  controller.emailAddress.value,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    lineHeight: 20.8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInputSection(VerifyController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: PinCodeTextField(
        hintCharacter: "-",
        hintStyle: getTextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary.withValues(alpha: 0.6),
        ),
        appContext: Get.context!,
        controller: controller.otpController,
        length: 4,
        onChanged: controller.onOtpChanged,
        keyboardType: TextInputType.number,
        textStyle: getTextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10.r),
          fieldHeight: 55.h,
          fieldWidth: 50.w,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          selectedFillColor: Colors.white,
          activeColor: Colors.transparent,
          selectedColor: Colors.transparent,
          inactiveColor: Colors.transparent,
        ),
        enableActiveFill: true,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget _buildButtonSection(VerifyController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          15.verticalSpace,
          CustomFilledButton(
            text: 'verify'.tr,
            onPressed: controller.onVerifyPressed,
            padding: EdgeInsets.zero,
          ),

          16.verticalSpace,

          Obx(
            () => GestureDetector(
              onTap: controller.onResendEmailPressed,
              child: Text(
                controller.isResending.value
                    ? 'resend_email'.tr
                    : 'send_code_again'.tr,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  lineHeight: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
