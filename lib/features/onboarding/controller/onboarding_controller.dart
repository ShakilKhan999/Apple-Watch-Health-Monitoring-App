import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentPage = 0.obs;

  void nextPage() {
    if (currentPage.value < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login screen after completing onboarding
      Get.offAllNamed(AppRoute.getLoginScreen());
    }
  }

  /// Navigate to login screen (for "Maybe Later" button)
  void skipToLogin() {
    Get.offAllNamed(AppRoute.getLoginScreen());
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
