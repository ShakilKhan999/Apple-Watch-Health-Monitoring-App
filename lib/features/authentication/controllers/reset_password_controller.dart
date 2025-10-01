import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/routes/app_routes.dart';

/// Controller for the reset password screen
class ResetPasswordController extends GetxController {
  // Form controllers
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;

  // Password visibility states
  final RxBool isNewPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Responsive getters based on screen size
  EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: 16.w);

  double get titleFontSize => 32.sp; // H2 from Figma
  double get labelFontSize => 16.sp; // Body/B1 from Figma
  double get inputTextFontSize => 14.sp; // Body/B2 from Figma

  double get headerSpacing => 24.h;

  /// Toggle new password visibility
  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  /// Validate password requirements
  bool _isPasswordValid(String password) {
    // Add your password validation logic here
    return password.length >= 8;
  }

  /// Handle reset password button press
  void onResetPasswordPressed() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validation
    if (newPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your new password',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please confirm your password',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (!_isPasswordValid(newPassword)) {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters long',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to success screen
      Get.offNamed(AppRoute.successfulPasswordScreen);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reset password. Please try again.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle back button press
  void onBackPressed() {
    Get.back();
  }
}
