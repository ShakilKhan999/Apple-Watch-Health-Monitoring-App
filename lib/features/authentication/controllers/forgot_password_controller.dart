import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/routes/app_routes.dart';

/// Controller for the forgot password screen
class ForgotPasswordController extends GetxController {
  // Form controller
  final TextEditingController emailController = TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('ForgotPasswordController initialized');
  }

  /// Handle send reset link button press
  void onSendResetLinkPressed() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Basic email validation
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call for sending reset link
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      Get.snackbar(
        'Success',
        'Reset link sent to your email!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );

      // Navigate to check email screen with email parameter
      Get.offNamed(
        AppRoute.getCheckEmailScreen(),
        arguments: {'email': emailController.text.trim()},
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send reset link. Please try again.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle back to login press
  void onBackToLoginPressed() {
    Get.back();
  }
}
