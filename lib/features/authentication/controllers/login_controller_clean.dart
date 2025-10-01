import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/routes/app_routes.dart';

class LoginController extends GetxController {
  // Observable variables
  final RxBool _isLoading = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;

  // Responsive values
  double get logoSize => 160.w;

  double get buttonTextFontSize => 16.sp;
  double get privacyTextFontSize => 12.sp;

  EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: 16.w);
  EdgeInsets get buttonSpacing => EdgeInsets.symmetric(vertical: 8.h);

  double get buttonSpacing2 => 16.h;
  double get privacySpacing => 18.h;

  // Navigation and action methods
  void onLoginPressed() {
    _setLoading(true);
    debugPrint('Login button pressed');

    // Navigate to login form screen
    Future.delayed(const Duration(milliseconds: 500), () {
      _setLoading(false);
      Get.toNamed('/loginFormScreen');
    });
  }

  void onCreateAccountPressed() {
    debugPrint('Create Account button pressed');
    // Navigate to signup screen
    Get.toNamed(AppRoute.getSignupScreen());
  }

  void onTermsPressed() {
    debugPrint('Terms pressed');
  }

  void onPrivacyPolicyPressed() {
    debugPrint('Privacy Policy pressed');
  }

  // Private methods
  void _setLoading(bool value) {
    _isLoading.value = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('LoginController initialized');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('LoginController disposed');
  }
}
