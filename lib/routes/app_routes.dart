import 'package:get/get.dart';
import 'package:surajashray/core/models/notification_model.dart';
import 'package:surajashray/features/account/screen/account_deactivate_screen.dart';
import 'package:surajashray/features/account/screen/account_screen.dart';
import 'package:surajashray/features/account/screen/change_password_screen.dart';
import 'package:surajashray/features/account/screen/connect_wearable_screen.dart';
import 'package:surajashray/features/account/screen/connect_wearable_settings_screen.dart';
import 'package:surajashray/features/account/screen/contact_support_screen.dart';
import 'package:surajashray/features/account/screen/edit_profile_screen.dart';
import 'package:surajashray/features/account/screen/health_goal_screen.dart';
import 'package:surajashray/features/account/screen/notification_screen.dart';
import 'package:surajashray/features/account/screen/notification_settings_screen.dart';
import 'package:surajashray/features/account/screen/profile_setup_screen.dart';
import 'package:surajashray/features/account/screen/security_settings_screen.dart';
import 'package:surajashray/features/account/screen/settings_screen.dart';
import 'package:surajashray/features/chat/screen/chat_history_screen.dart';
import 'package:surajashray/features/chat/screen/new_chat_screen.dart';
import 'package:surajashray/features/home/screen/lab_report_analysis_screen.dart';
import 'package:surajashray/features/home/screen/lab_report_screen.dart';
import 'package:surajashray/features/notification/screen/all_notification_screen.dart';
import 'package:surajashray/features/notification/screen/notification_details_screen.dart';
import 'package:surajashray/features/onboarding/screen/onboarding_screen.dart';
import 'package:surajashray/features/splash_screen/screen/splash_sccreen.dart';
import 'package:surajashray/features/bottom_navigation/screens/bottom_navigation_screen.dart';
import 'package:surajashray/features/home/screen/vital_signs_details_screen.dart';
import 'package:surajashray/features/home/screen/add_new_meal_screen.dart';
import 'package:surajashray/features/home/screen/existing_meals_screen.dart';
import 'package:surajashray/features/food_diary/screen/food_diary_details_screen.dart';
import 'package:surajashray/features/nudges/presentation/screens/daily_nudges_screen.dart';
import 'package:surajashray/features/nudges/presentation/screens/add_nudges_screen.dart';
import 'package:surajashray/features/scan/screens/scan_your_meal_screen.dart';
import 'package:surajashray/features/scan/screens/scan_meal_form_screen.dart';
import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/authentication/presentation/screens/login_form_screen.dart';
import '../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../features/authentication/presentation/screens/reset_password_screen.dart';
import '../features/authentication/presentation/screens/suceessfull_changed_password_screen.dart';
import '../features/authentication/presentation/screens/verify_otp_screen.dart';
import '../features/authentication/presentation/screens/signup_screen.dart';

class AppRoute {
  static String loginScreen = "/loginScreen";
  static String loginFormScreen = "/loginFormScreen";
  static String signupScreen = "/signupScreen";
  static String splashScreen = "/splashScreen";
  static String homeScreen = "/homeScreen";
  static String bottomNavigationScreen = "/bottomNavigationScreen";
  static String onboardingScreen = "/onboardingScreen";
  static String forgotPasswordScreen = "/forgotPasswordScreen";
  static String resetPasswordScreen = "/resetPasswordScreen";
  static String successfulPasswordScreen = "/successfulPasswordScreen";
  static String checkEmailScreen = "/checkEmailScreen";
  static String profileSetupScreen = "/profileSetupScreen";
  static String healthGoalScreen = "/healthGoalScreen";
  static String connectWearableScreen = "/connectWearableScreen";
  static String profileScreen = "/profileScreen";
  static String notificationScreen = "/notificationScreen";
  static String vitalSignsDetailsScreen = "/vitalSignsDetailsScreen";
  static String accountScreen = "/accountScreen";
  static String editProfileScreen = "/editProfileScreen";
  static String addNewMealScreen = "/addNewMealScreen";
  static String existingMealsScreen = "/existingMealsScreen";
  static String foodDiaryDetailsScreen = "/foodDiaryDetailsScreen";
  static String settingsScreen = "/settingsScreen";
  static String notificationSettingsScreen = "/notificationSettingsScreen";
  static String connectWearableSettingsScreen =
      "/connectWearableSettingsScreen";
  static String accountDeactivateScreen = "/accountDeactivateScreen";
  static String contactSupportScreen = "/contactSupportScreen";
  static String chatHistoryScreen = "/chatHistoryScreen";
  static String newChatScreen = "/newChatScreen";
  static String labReportScreen = "/labReportScreen";
  static String dailyNudgesScreen = "/dailyNudgesScreen";
  static String addNudgesScreen = "/addNudgesScreen";
  static String labReportAnalysisScreen = "/labReportAnalysisScreen";
  static String allNotificationScreen = "/allNotificationScreen";
  static String notificationDetailsScreen = "/notificationDetailsScreen";

  static String scanYourMealScreen = "/scanYourMealScreen";
  static String scanMealFormScreen = "/scanMealFormScreen";

  static String securitySettingsScreen = "/securitySettingsScreen";
  static String changePasswordScreen = "/changePasswordScreen";

  static String getLoginScreen() => loginScreen;
  static String getLoginFormScreen() => loginFormScreen;
  static String getSignupScreen() => signupScreen;
  static String getSplashScreen() => splashScreen;
  static String getHomeScreen() => homeScreen;
  static String getBottomNavigationScreen() => bottomNavigationScreen;
  static String getOnboardingScreen() => onboardingScreen;
  static String getForgotPasswordScreen() => forgotPasswordScreen;
  static String getResetPasswordScreen() => resetPasswordScreen;
  static String getSuccessfulPasswordScreen() => successfulPasswordScreen;
  static String getCheckEmailScreen() => checkEmailScreen;
  static String getProfileSetupScreen() => profileSetupScreen;
  static String getHealthGoalScreen() => healthGoalScreen;
  static String getConnectWearableScreen() => connectWearableScreen;
  static String getNotificationScreen() => notificationScreen;
  static String getVitalSignsDetailsScreen() => vitalSignsDetailsScreen;
  static String getAccountScreen() => accountScreen;
  static String getEditProfileScreen() => editProfileScreen;
  static String getAddNewMealScreen() => addNewMealScreen;
  static String getExistingMealsScreen() => existingMealsScreen;
  static String getFoodDiaryDetailsScreen() => foodDiaryDetailsScreen;
  static String getSettingsScreen() => settingsScreen;
  static String getNotificationSettingsScreen() => notificationSettingsScreen;
  static String getConnectWearableSettingsScreen() =>
      connectWearableSettingsScreen;
  static String getAccountDeactivateScreen() => accountDeactivateScreen;
  static String getContactSupportScreen() => contactSupportScreen;
  static String getChatHistoryScreen() => chatHistoryScreen;
  static String getNewChatScreen() => newChatScreen;
  static String getlabReportScreen() => labReportScreen;
  static String getLabReportAnalysisScreen() => labReportAnalysisScreen;
  static String getDailyNudgesScreen() => dailyNudgesScreen;
  static String getAddNudgesScreen() => addNudgesScreen;
  static String getAllNotificationScreen() => allNotificationScreen;
  static String getNotificationDetailsScreen() => notificationDetailsScreen;

  static String getScanYourMealScreen() => scanYourMealScreen;
  static String getScanMealFormScreen() => scanMealFormScreen;

  static String getSecuritySettingsScreen() => securitySettingsScreen;
  static String getChangePasswordScreen() => changePasswordScreen;

  static List<GetPage> routes = [
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: loginFormScreen, page: () => const LoginFormScreen()),
    GetPage(name: signupScreen, page: () => const SignupScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(
      name: forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(name: resetPasswordScreen, page: () => const ResetPasswordScreen()),
    GetPage(
      name: successfulPasswordScreen,
      page: () => const SuccessfulPasswordScreen(),
    ),
    GetPage(name: checkEmailScreen, page: () => const VerifyOtpScreen()),
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: homeScreen, page: () => const BottomNavigationScreen()),
    GetPage(
      name: bottomNavigationScreen,
      page: () => const BottomNavigationScreen(),
    ),
    GetPage(name: profileSetupScreen, page: () => const ProfileSetupScreen()),
    GetPage(name: healthGoalScreen, page: () => const HealthGoalScreen()),
    GetPage(
      name: connectWearableScreen,
      page: () => const ConnectWearableScreen(),
    ),
    GetPage(name: notificationScreen, page: () => const NotificationScreen()),
    GetPage(
      name: vitalSignsDetailsScreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final showBackButton = args?['showBackButton'] ?? false;
        return VitalSignsDetailsScreen(showBackButton: showBackButton);
      },
    ),
    GetPage(name: addNewMealScreen, page: () => const AddNewMealScreen()),
    GetPage(name: existingMealsScreen, page: () => const ExistingMealsScreen()),
    GetPage(
      name: foodDiaryDetailsScreen,
      page: () => const FoodDiaryDetailsScreen(),
    ),

    // Nudges routes
    GetPage(name: dailyNudgesScreen, page: () => const DailyNudgesScreen()),
    GetPage(name: addNudgesScreen, page: () => const AddNudgesScreen()),

    GetPage(name: accountScreen, page: () => AccountScreen()),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(name: settingsScreen, page: () => SettingsScreen()),
    GetPage(
      name: notificationSettingsScreen,
      page: () => NotificationSettingsScreen(),
    ),
    GetPage(
      name: connectWearableSettingsScreen,
      page: () => ConnectWearableSettingsScreen(),
    ),
    GetPage(
      name: accountDeactivateScreen,
      page: () => AccountDeactivateScreen(),
    ),
    GetPage(name: contactSupportScreen, page: () => ContactSupportScreen()),
    GetPage(name: chatHistoryScreen, page: () => ChatHistoryScreen()),
    GetPage(name: newChatScreen, page: () => NewChatScreen()),
    GetPage(name: labReportScreen, page: () => LabReportScreen()),
    // GetPage(name: labReportAnalysisScreen, page: () => LabReportAnalysisScreen(reportId: '',)),
    GetPage(
      name: labReportAnalysisScreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final reportId = args?["reportId"]?.toString() ?? '';
        return LabReportAnalysisScreen(reportId: reportId);
      },
    ),
    GetPage(name: allNotificationScreen, page: () => AllNotificationScreen()),
    
    GetPage(
      name: notificationDetailsScreen,
      page: () => NotificationDetailsScreen(
        notification: Get.arguments as NotificationModel,
      ),
    ),

    GetPage(name: scanYourMealScreen, page: () => const ScanYourMealScreen()),
    GetPage(name: scanMealFormScreen, page: () => const ScanMealFormScreen()),
    GetPage(name: securitySettingsScreen, page: () => SecuritySettingsScreen()),

    GetPage(
      name: changePasswordScreen,
      page: () => const ChangePasswordScreen(),
    ),

    //
  ];
}
