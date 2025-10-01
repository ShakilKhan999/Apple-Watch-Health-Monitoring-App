import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surajashray/core/controllers/global_language_controller.dart';
import 'package:surajashray/core/localization/languages/en.dart';
import 'package:surajashray/core/localization/languages/hi.dart';
import 'package:surajashray/core/localization/languages/ur.dart';
import 'package:surajashray/core/localization/languages/bn.dart';
import 'package:surajashray/core/localization/languages/fr.dart';
import 'package:surajashray/core/localization/languages/de.dart';
import 'package:surajashray/core/localization/languages/ar.dart';
import 'package:surajashray/core/localization/languages/ml.dart';
import 'package:surajashray/core/localization/languages/te.dart';
import 'package:surajashray/core/localization/languages/ta.dart';
import 'package:surajashray/core/localization/languages/pa.dart';

/// Localization service for managing app languages and translations
class LocalizationService extends Translations {
  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('hi', 'IN'), // Hindi
    Locale('ur', 'PK'), // Urdu
    Locale('bn', 'BD'), // Bangla
    Locale('fr', 'FR'), // French
    Locale('de', 'DE'), // German
    Locale('ar', 'SA'), // Arabic
    Locale('ml', 'IN'), // Malayalam
    Locale('te', 'IN'), // Telugu
    Locale('ta', 'IN'), // Tamil
    Locale('pa', 'IN'), // Punjabi
  ];

  /// Language names for display
  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'Hindi',
    'ur': 'Urdu',
    'bn': 'Bangla',
    'fr': 'French',
    'de': 'German',
    'ar': 'Arabic',
    'ml': 'Malayalam',
    'te': 'Telugu',
    'ta': 'Tamil',
    'pa': 'Punjabi',
  };

  /// Available languages list for UI
  static List<String> get availableLanguages => languageNames.values.toList();

  /// Default locale
  static const Locale fallbackLocale = Locale('en', 'US');

  /// Shared preferences key for storing selected language
  static const String _languageKey = 'selected_language';

  /// Get current locale from GetX
  static Locale get currentLocale => Get.locale ?? fallbackLocale;

  /// Get current language code
  static String get currentLanguageCode => currentLocale.languageCode;

  /// Get current language name
  static String get currentLanguageName =>
      languageNames[currentLanguageCode] ?? 'English';

  /// Get saved language from SharedPreferences (for debugging)
  static Future<String?> getSavedLanguageCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_languageKey);
    } catch (e) {
      debugPrint('Error getting saved language: $e');
      return null;
    }
  }

  /// Initialize localization service
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey);

      debugPrint('Localization init - saved language code: $savedLanguageCode');

      if (savedLanguageCode != null) {
        final locale = _getLocaleFromCode(savedLanguageCode);
        if (locale != null) {
          debugPrint('Setting locale to: $locale');
          // Force the locale change
          Get.locale = locale;
          debugPrint('Locale force-set to: ${Get.locale}');
        } else {
          debugPrint(
            'Invalid locale for code: $savedLanguageCode, using fallback',
          );
          Get.locale = fallbackLocale;
        }
      } else {
        debugPrint('No saved language found, using fallback locale');
        Get.locale = fallbackLocale;
      }
    } catch (e) {
      debugPrint('Error initializing localization: $e');
      // If any error occurs, use default locale
      Get.locale = fallbackLocale;
    }
  }

  /// Change language and save to local storage
  static Future<void> changeLanguage(String languageName) async {
    try {
      debugPrint('Changing language to: $languageName');

      final languageCode = _getLanguageCodeFromName(languageName);
      if (languageCode == null) {
        debugPrint('Invalid language name: $languageName');
        return;
      }

      final locale = _getLocaleFromCode(languageCode);
      if (locale == null) {
        debugPrint('Invalid locale for language code: $languageCode');
        return;
      }

      debugPrint('Setting locale to: $locale');

      // Save to SharedPreferences first
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      // Update GetX locale - this forces all screens to update
      Get.updateLocale(locale);

      // Additional force update to ensure all controllers refresh
      await Future.delayed(Duration(milliseconds: 100));

      // Update global language controller if available
      try {
        if (Get.isRegistered<GlobalLanguageController>()) {
          Get.find<GlobalLanguageController>().forceRefreshAllScreens();
        }
      } catch (e) {
        // GlobalLanguageController not found, just continue
        debugPrint('GlobalLanguageController not found: $e');
      }

      Get.forceAppUpdate();

      debugPrint('Language saved to preferences: $languageCode');
      debugPrint('Current locale after change: ${Get.locale}');
    } catch (e) {
      debugPrint('Error changing language: $e');
      // Handle error
      Get.snackbar(
        'Error',
        'Failed to change language. Please try again.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Get language code from language name
  static String? _getLanguageCodeFromName(String languageName) {
    for (final entry in languageNames.entries) {
      if (entry.value == languageName) {
        return entry.key;
      }
    }
    return null;
  }

  /// Get locale from language code
  static Locale? _getLocaleFromCode(String languageCode) {
    for (final locale in supportedLocales) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return null;
  }

  /// Debug method to check localization state
  static Future<void> debugLocalizationState() async {
    debugPrint('=== LOCALIZATION DEBUG ===');
    debugPrint('Current GetX locale: ${Get.locale}');
    debugPrint('Current language code: $currentLanguageCode');
    debugPrint('Current language name: $currentLanguageName');

    final savedCode = await getSavedLanguageCode();
    debugPrint('Saved language code: $savedCode');

    debugPrint('Supported locales: $supportedLocales');
    debugPrint('Available languages: $availableLanguages');
    debugPrint('========================');
  }

  /// GetX Translations implementation
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': EnglishTranslations.translations,
    'hi_IN': HindiTranslations.translations,
    'ur_PK': UrduTranslations.translations,
    'bn_BD': BanglaTranslations.translations,
    'fr_FR': FrenchTranslations.translations,
    'de_DE': GermanTranslations.translations,
    'ar_SA': ArabicTranslations.translations,
    'ml_IN': MalayalamTranslations.translations,
    'te_IN': TeluguTranslations.translations,
    'ta_IN': TamilTranslations.translations,
    'pa_IN': PunjabiTranslations.translations,
  };
}
