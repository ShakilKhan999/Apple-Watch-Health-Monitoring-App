import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  // Form controllers
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Reactive state for password visibility
  final RxBool isCurrentPasswordHidden = true.obs;
  final RxBool isNewPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Form validation methods
  String? validateCurrentPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your current password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a new password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    // Add more password strength validations if needed
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Toggle password visibility methods
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordHidden.value = !isCurrentPasswordHidden.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // Save changes method
  void onSaveChanges() async {
    // Validate all fields
    final currentPasswordError = validateCurrentPassword(
      currentPasswordController.text,
    );
    final newPasswordError = validateNewPassword(newPasswordController.text);
    final confirmPasswordError = validateConfirmPassword(
      confirmPasswordController.text,
    );

    if (currentPasswordError != null) {
      Get.snackbar(
        'Error',
        currentPasswordError,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (newPasswordError != null) {
      Get.snackbar(
        'Error',
        newPasswordError,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (confirmPasswordError != null) {
      Get.snackbar(
        'Error',
        confirmPasswordError,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Check if new password is different from current password
    if (currentPasswordController.text == newPasswordController.text) {
      Get.snackbar(
        'Error',
        'New password must be different from current password',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Start loading
    isLoading.value = true;

    try {
      // Simulate API call for password change
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      Get.snackbar(
        'Success',
        'Password changed successfully',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // Navigate back to security settings
      Get.back();
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to change password. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      // Stop loading
      isLoading.value = false;
    }
  }

  // Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    debugPrint('ChangePasswordController initialized');
  }

  @override
  void onClose() {
    // Dispose controllers
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
    debugPrint('ChangePasswordController disposed');
  }
}
