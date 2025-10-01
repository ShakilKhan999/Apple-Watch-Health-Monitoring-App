import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/routes/app_routes.dart';

/// Controller for the check email screen
class VerifyController extends GetxController {
  final RxString emailAddress = ''.obs;
  final RxBool isResending = false.obs;
  var otpCode = ''.obs;
  final TextEditingController otpController = TextEditingController();

  void onOtpChanged(String value) {
    otpCode.value = value;
  }

  void onVerifyPressed() {
    if (otpCode.value.length == 4) {
      debugPrint("OTP Entered: ${otpCode.value}");
      Get.snackbar("Success", "OTP Verified!");

      // Navigate to reset password screen
      Get.offNamed(AppRoute.resetPasswordScreen);
    } else {
      Get.snackbar("Error", "Please enter 4 digit OTP");
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      emailAddress.value = arguments['email'] ?? 'your.email@example.com';
    } else {
      emailAddress.value = 'your.email@example.com';
    }
    debugPrint(
      'CheckEmailController initialized with email: ${emailAddress.value}',
    );
  }

  void onBackToLoginPressed() {
    Get.offAllNamed('/loginFormScreen');
  }

  void onResendEmailPressed() async {
    try {
      isResending.value = true;
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Email Sent',
        'Password reset otp has been sent again!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend email. Please try again.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isResending.value = false;
    }
  }
}
