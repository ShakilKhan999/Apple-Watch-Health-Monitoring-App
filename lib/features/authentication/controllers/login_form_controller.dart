import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/routes/app_routes.dart';

/// Controller for the login form screen
class LoginFormController extends GetxController {
  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;

  // Password visibility state
  final RxBool isPasswordHidden = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Responsive getters based on screen size
  EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: 16.w);

  double get titleFontSize => 32.sp; // H2 from Figma
  double get subtitleFontSize => 16.sp; // Body/B1 from Figma
  double get labelFontSize => 16.sp; // Body/B1 from Figma
  double get inputTextFontSize => 14.sp; // Body/B2 from Figma
  double get linkTextFontSize => 14.sp; // Body/B2 from Figma

  double get headerSpacing => 16.h;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  /// Handle login button press
  void onLoginPressed() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email or phone',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call
      // await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.TOP,
      );

      // Navigate to home screen (you can create this route)
      // Get.offAllNamed(AppRoutes.home);
      // Get.offNamed(AppRoute.profileSetupScreen);
      // Get.offAllNamed(AppRoute.getProfileSetupScreen());
      Get.offAllNamed(AppRoute.getBottomNavigationScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed. Please try again.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle forgot password press
  void onForgotPasswordPressed() {
    // Navigate to forgot password screen
    Get.toNamed(AppRoute.getForgotPasswordScreen());
  }

  /// Handle Google login press
  void onGoogleLoginPressed() {
    Get.snackbar(
      'Info',
      'Google login feature coming soon!',
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Handle Apple login press
  void onAppleLoginPressed() {
    Get.snackbar(
      'Info',
      'Apple login feature coming soon!',
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Handle sign up press
  void onSignUpPressed() {
    Get.toNamed(AppRoute.getSignupScreen());
  }

  /// Handle create account press
  void onCreateAccountPressed() {
    // Navigate to signup screen
    Get.toNamed(AppRoute.getSignupScreen());
  }
}
