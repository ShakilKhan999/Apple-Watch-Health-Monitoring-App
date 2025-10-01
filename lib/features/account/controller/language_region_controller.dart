import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/localization/localization_service.dart';

class LanguageRegionController extends GetxController {
  // Reactive variables
  var selectedLanguage = ''.obs;
  var selectedLanguageCode = ''.obs;
  var isLoading = false.obs;

  // Keep track of bottom sheet state
  bool _isBottomSheetOpen = false;

  @override
  void onInit() {
    super.onInit();
    _initializeCurrentLanguage();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh language settings when screen is ready
    refreshLanguageSettings();
  }

  @override
  void onClose() {
    // Ensure bottom sheet is closed when controller is disposed
    _closeBottomSheetSafely();
    super.onClose();
  }

  /// Refresh language settings (useful when returning to screen after language change)
  void refreshLanguageSettings() {
    _initializeCurrentLanguage();
  }

  /// Initialize current language from LocalizationService
  void _initializeCurrentLanguage() {
    selectedLanguage.value = LocalizationService.currentLanguageName;
    selectedLanguageCode.value = LocalizationService.currentLanguageCode
        .toUpperCase();
    update(); // Notify GetBuilder
  }

  /// Navigate back to settings screen
  void onBackPressed() {
    Get.back();
  }

  /// Handle language selection tap
  void onLanguageSelectionTapped() {
    if (!_isBottomSheetOpen) {
      _showLanguageSelectionBottomSheet();
    }
  }

  /// Show language selection bottom sheet
  void _showLanguageSelectionBottomSheet() {
    _isBottomSheetOpen = true;

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'select_language'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            // Language list
            ...LocalizationService.availableLanguages.map(
              (language) => Obx(
                () => ListTile(
                  title: Text(
                    language,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: selectedLanguage.value == language
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  trailing: selectedLanguage.value == language
                      ? Icon(Icons.check, color: Color(0xFF4A7BFF))
                      : null,
                  onTap: () => _onLanguageSelected(language),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    ).whenComplete(() {
      // Reset bottom sheet state when closed
      _isBottomSheetOpen = false;
    });
  }

  /// Handle language selection
  Future<void> _onLanguageSelected(String language) async {
    try {
      // Don't proceed if same language is selected
      if (selectedLanguage.value == language) {
        _closeBottomSheetSafely();
        return;
      }

      // Close bottom sheet first
      _closeBottomSheetSafely();

      // Small delay to ensure smooth UI transition
      await Future.delayed(Duration(milliseconds: 300));

      // Show loading
      isLoading.value = true;
      update(); // Notify GetBuilder

      // Change language
      await LocalizationService.changeLanguage(language);

      // Update reactive variables
      selectedLanguage.value = language;
      selectedLanguageCode.value = LocalizationService.currentLanguageCode
          .toUpperCase();

      // Force update ALL GetX controllers to refresh UI globally
      Get.forceAppUpdate();

      // Show success message
      Get.snackbar(
        'success'.tr,
        'language_changed_successfully'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF34C759),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      debugPrint('Error changing language: $e');
      Get.snackbar(
        'error'.tr,
        'failed_to_change_language'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      update(); // Notify GetBuilder
    }
  }

  /// Safely close bottom sheet
  void _closeBottomSheetSafely() {
    if (_isBottomSheetOpen) {
      try {
        Navigator.of(Get.context!).pop();
        _isBottomSheetOpen = false;
      } catch (e) {
        debugPrint('Error closing bottom sheet: $e');
        _isBottomSheetOpen = false;
      }
    }
  }

  /// Get language code for display
  String getLanguageCode(String languageName) {
    final codeMap = {
      'English': 'EN',
      'Hindi': 'HI',
      'Urdu': 'UR',
      'Bangla': 'BN',
      'French': 'FR',
      'German': 'DE',
      'Arabic': 'AR',
      'Malayalam': 'ML',
      'Telugu': 'TE',
      'Tamil': 'TA',
      'Punjabi': 'PA',
    };
    return codeMap[languageName] ?? 'EN';
  }
}
