import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/routes/app_routes.dart';

/// Controller for the successful password changed screen
class SuccessfulPasswordController extends GetxController {
  // Loading state
  final RxBool isLoading = false.obs;

  // Responsive getters based on screen size
  EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: 16.w);

  double get titleFontSize => 32.sp; // H2 from Figma
  double get subtitleFontSize => 16.sp; // Body/B1 from Figma

  double get iconSize => 60.w;
  double get headerSpacing => 24.h;

  /// Handle log in button press
  void onLogInPressed() async {
    try {
      isLoading.value = true;

      // Small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate back to login screen
      Get.offAllNamed(AppRoute.getLoginFormScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle back button press (though typically not needed on success screens)
  void onBackPressed() {
    Get.back();
  }
}
