import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/localization/localization_service.dart';
import 'package:surajashray/routes/app_routes.dart';

/// Controller for the signup screen
class SignupController extends GetxController {
  // Form controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;

  // Password visibility states
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  // Terms agreement state
  final RxBool isTermsAgreed = false.obs;

  // Language selection (make it reactive to actual locale)
  final RxString selectedLanguage = 'English'.obs;

  // Add a reactive variable for locale changes
  final Rx<Locale> currentLocale = Locale('en').obs;

  // Keep track of bottom sheet state
  bool _isBottomSheetOpen = false;

  // Available languages list (using LocalizationService)
  List<String> get availableLanguages => LocalizationService.availableLanguages;

  @override
  void onClose() {
    // Ensure bottom sheet is closed when controller is disposed
    _closeBottomSheetSafely();

    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Responsive getters based on screen size
  EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: 16.w);

  double get titleFontSize => 32.sp; // H2 from Figma
  double get subtitleFontSize => 16.sp; // Body/B1 from Figma
  double get labelFontSize => 16.sp; // Body/B1 from Figma
  double get inputTextFontSize => 14.sp; // Body/B2 from Figma
  double get linkTextFontSize => 12.sp; // Body/B3 from Figma

  double get headerSpacing => 16.h;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  /// Toggle terms agreement
  void toggleTermsAgreement() {
    isTermsAgreed.value = !isTermsAgreed.value;
  }

  /// Handle language selection
  void onLanguagePressed() {
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
          color: const Color(0xFFF5F5F7), // Background color from Figma
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Text(
                  'select_language'.tr,
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                16.verticalSpace,

                // Language options
                ...availableLanguages.map(
                  (language) => _buildLanguageOption(language),
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      // Reset bottom sheet state when closed
      _isBottomSheetOpen = false;
    });
  }

  /// Build individual language option
  Widget _buildLanguageOption(String language) {
    return Obx(
      () => GestureDetector(
        onTap: () => _selectLanguage(language),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: const Color(0xFFEEEEF2), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language,
                style: getTextStyle(
                  fontSize: 12.sp, // Body/B3 from Figma
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  lineHeight: 18, // 1.5 line height
                ),
              ),
              // Show checkmark for selected language
              if (selectedLanguage.value == language)
                Icon(Icons.check, size: 12.w, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  /// Select a language and close bottom sheet
  void _selectLanguage(String language) async {
    try {
      debugPrint('Selecting language: $language');

      // Don't proceed if same language is selected
      if (selectedLanguage.value == language) {
        _closeBottomSheetSafely();
        return;
      }

      // Close bottom sheet first
      _closeBottomSheetSafely();

      // Small delay to ensure smooth UI transition
      await Future.delayed(Duration(milliseconds: 300));

      // Update the selected language immediately for UI
      selectedLanguage.value = language;

      // Change app language using LocalizationService
      await LocalizationService.changeLanguage(language);

      // Update the reactive locale variable to force UI refresh
      currentLocale.value = Get.locale ?? Locale('en');

      // Force update the entire screen
      update();

      // Show success message
      Get.snackbar(
        'success'.tr,
        'language_changed_successfully'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF34C759),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      debugPrint('Language selection completed for: $language');
    } catch (e) {
      debugPrint('Error selecting language: $e');
      // Reset to previous value if error occurs
      selectedLanguage.value = LocalizationService.currentLanguageName;

      Get.snackbar(
        'error'.tr,
        'failed_to_change_language'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
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

  /// Validate form inputs
  bool _validateInputs() {
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar(
        'error'.tr,
        'please_enter_full_name'.tr,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'error'.tr,
        'please_enter_email'.tr,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    // Basic email validation
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'error'.tr,
        'please_enter_valid_email'.tr,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'error'.tr,
        'please_create_password'.tr,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    // Password strength validation
    if (passwordController.text.trim().length < 6) {
      Get.snackbar(
        'error'.tr,
        'password_min_length'.tr,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'error'.tr,
        'please_confirm_password'.tr,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Get.snackbar(
        'error'.tr,
        'passwords_do_not_match'.tr,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (!isTermsAgreed.value) {
      Get.snackbar(
        'error'.tr,
        'please_agree_terms'.tr,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  /// Handle create account button press
  void onCreateAccountPressed() async {
    if (!_validateInputs()) {
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'success'.tr,
        'account_created_successfully'.tr,
        snackPosition: SnackPosition.TOP,
      );

      // Navigate to login screen or home screen based on your flow
      // Get.offAllNamed(AppRoute.getLoginScreen());
      Get.offAllNamed(AppRoute.getProfileSetupScreen());
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'account_creation_failed'.tr,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle terms of service press
  void onTermsPressed() {
    debugPrint('Terms of Service pressed');

    Get.snackbar(
      'info'.tr,
      'terms_coming_soon'.tr,
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Handle privacy policy press
  void onPrivacyPolicyPressed() {
    debugPrint('Privacy Policy pressed');

    Get.snackbar(
      'info'.tr,
      'privacy_policy_coming_soon'.tr,
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Handle back button press
  void onBackPressed() {
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize selected language with current locale
    _initializeLanguage();
    debugPrint(
      'SignupController initialized with language: ${selectedLanguage.value}',
    );
  }

  /// Initialize language from saved preferences
  void _initializeLanguage() async {
    try {
      // Small delay to ensure the app is fully initialized
      await Future.delayed(const Duration(milliseconds: 100));

      // Force update the selected language based on current locale
      final currentLocaleValue = Get.locale;
      if (currentLocaleValue != null) {
        final langName =
            LocalizationService.languageNames[currentLocaleValue
                .languageCode] ??
            'English';
        selectedLanguage.value = langName;
        currentLocale.value = currentLocaleValue;
        debugPrint('Locale-based language set to: $langName');
      }

      // Debug: Check what's saved in preferences
      final savedCode = await LocalizationService.getSavedLanguageCode();
      debugPrint('Saved language code in preferences: $savedCode');
      debugPrint('Current locale after init: ${Get.locale}');
    } catch (e) {
      debugPrint('Error initializing language: $e');
      selectedLanguage.value = 'English';
      currentLocale.value = Locale('en');
    }
  }
}
