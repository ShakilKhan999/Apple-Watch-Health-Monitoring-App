import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/models/notification_card_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';

class NotificationController extends GetxController {
  final RxList<NotificationCardModel> cards = <NotificationCardModel>[].obs;
  final TextEditingController toTimeController = TextEditingController();
  final TextEditingController fromTimeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeCards();
  }

  final RxBool isDoNotDisturbOn = false.obs;
  final RxString fromTime = ''.obs;
  final RxString toTime = ''.obs;

  void toggleNotification(int index) {
    if (index >= 0 && index < cards.length) {
      final card = cards[index];
      cards[index] = card.copyWith(isEnabled: !card.isEnabled);
    }
  }

  /// Toggle Do Not Disturb switch
  void toggleDoNotDisturb(bool value) {
    isDoNotDisturbOn.value = value;
  }

  /// Update "From" time
  void updateFromTime(String time) {
    fromTime.value = time;
  }

  /// Update "To" time
  void updateToTime(String time) {
    toTime.value = time;
  }

  void _initializeCards() {
    cards.assignAll([
      NotificationCardModel(
        title: "Activit Reminders",
        subtitle: "Daily at 10:00 AM, 3:00 PM",
        iconPath: IconPath.reminder,
        iconBackgroundColor: const Color(0xFFC7D6FF),
      ),

      NotificationCardModel(
        title: "Meal Tracking",
        subtitle: "Breakfast, Lunch, Dinner",
        iconPath: IconPath.mealTrack,
        iconBackgroundColor: const Color(0xFFFFC2BF),
      ),

      NotificationCardModel(
        title: "Sleep Insights",
        subtitle: "30 min before bedtime",
        iconPath: IconPath.sleep,
        iconBackgroundColor: const Color.fromARGB(255, 206, 191, 235),
      ),

      NotificationCardModel(
        title: "Progress Updates",
        subtitle: "Weekly summary",
        iconPath: IconPath.progress,
        iconBackgroundColor: const Color(0xFFC0EECC),
      ),

      NotificationCardModel(
        title: "Water Intake",
        subtitle: "Every 2 hours",
        iconPath: IconPath.water,
        iconBackgroundColor: const Color(0x5ECFBC1A),
      ),
      NotificationCardModel(
        title: "Motivational Nudges",
        subtitle: "Encouragement messages",
        iconPath: IconPath.motivational,
        iconBackgroundColor: const Color(0xFFFFC2BF),
      ),
      NotificationCardModel(
        title: "Wellness Tips",
        subtitle: "Daily health insights",
        iconPath: IconPath.wellness,
        iconBackgroundColor: const Color(0xFFC7D6FF),
      ),
    ]);
  }

  Future<TimeOfDay?> showCustomTimePicker(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary, // ✅ Purple for header & buttons
              onPrimary: Colors.white, // ✅ Text on primary
              onSurface: Colors.black, // ✅ Default text color
              surface: Colors.white, // ✅ Picker background
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                // Confirm/Cancel button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
