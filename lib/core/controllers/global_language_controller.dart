import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/localization/localization_service.dart';

/// Global language controller to manage app-wide language state
/// This ensures all screens update when language changes
class GlobalLanguageController extends GetxController {
  static GlobalLanguageController get instance => Get.find();

  /// Current selected language name
  final RxString currentLanguage = 'English'.obs;

  /// Current locale
  final Rx<Locale> currentLocale = Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLanguage();
  }

  /// Initialize language from saved preferences
  void _initializeLanguage() async {
    try {
      // Get current language from LocalizationService
      final languageName = LocalizationService.currentLanguageName;
      final locale = Get.locale ?? LocalizationService.fallbackLocale;

      currentLanguage.value = languageName;
      currentLocale.value = locale;

      debugPrint('Global language initialized: $languageName');
    } catch (e) {
      debugPrint('Error initializing global language: $e');
      currentLanguage.value = 'English';
      currentLocale.value = Locale('en');
    }
  }

  /// Update global language state (called after language change)
  void updateLanguage() {
    final languageName = LocalizationService.currentLanguageName;
    final locale = Get.locale ?? LocalizationService.fallbackLocale;

    currentLanguage.value = languageName;
    currentLocale.value = locale;

    // Force update all GetX widgets
    update();

    debugPrint('Global language updated to: $languageName');
  }

  /// Force refresh all screens
  void forceRefreshAllScreens() {
    updateLanguage();
    Get.forceAppUpdate();
  }
}
