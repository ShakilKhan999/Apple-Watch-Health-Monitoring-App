import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/models/account_screen_model.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/account/screen/contact_support_screen.dart';
import 'package:surajashray/features/account/screen/settings_screen.dart';
import 'package:surajashray/features/authentication/presentation/screens/login_screen.dart';

class AccountScreenController extends ChangeNotifier {
  late PersonalInfo personalInfo;
  late List<HealthMetric> healthMetrics;
  late List<SettingsOption> settingsOptions;

  AccountScreenController() {
    loadData();
  }

  void loadData() {
    personalInfo = PersonalInfo(
      name: "Alexandra Johnson",
      email: "alexandrajohnson@emailecom",
      profileImageUrl: "https://i.pravatar.cc/150?img=3",
    );

    healthMetrics = [
      HealthMetric(
        iconPath: IconPath.lessStress,
        iconBackgroundColor: Color(0xFFFFC2BF),
        title: "Heart Rate",
        quantity: "72 BPM",
        subtitle: "Average today",
        level: "Normal",
      ),
      HealthMetric(
        iconPath: IconPath.water,
        iconBackgroundColor: const Color.fromARGB(255, 215, 224, 231),
        title: "Hydration",
        quantity: "1.8L",
        subtitle: "Daily intake",
        level: "Goal",
      ),
      HealthMetric(
        iconPath: IconPath.frame,
        iconBackgroundColor: Color(0xFFC7D6FF),
        title: "Sleep",
        quantity: "7.5h",
        subtitle: "Last Night",
        level: "Good",
      ),
    ];

    settingsOptions = [
      SettingsOption(
        title: "account_settings".tr,

        onTap: () {
          Get.to(SettingsScreen());
        },
        leadingicon: IconPath.settings,
      ),
      SettingsOption(
        title: "help_support".tr,
        onTap: () {
          Get.to(ContactSupportScreen());
        },
        leadingicon: IconPath.faq,
      ),
    ];

    notifyListeners();
  }

  void logOut() {
    Get.offAll(LoginScreen());
  }
}
