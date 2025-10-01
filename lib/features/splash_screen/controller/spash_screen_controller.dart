import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/routes/app_routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    debugPrint('SplashScreenController initialized');
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      Get.offNamed(AppRoute.onboardingScreen);
    });
  }

  // @override
  // void onClose() {
  //   debugPrint('SplashScreenController disposed');
  //   super.onClose();
  // }
}
