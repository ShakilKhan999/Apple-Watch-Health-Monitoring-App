import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/features/account/screen/account_screen.dart';
import 'package:surajashray/features/bottom_navigation/controllers/bottom_navigation_controller.dart';
import 'package:surajashray/features/bottom_navigation/widgets/custom_bottom_navigation.dart';
import 'package:surajashray/features/chat/screen/chat_history_screen.dart';
import 'package:surajashray/features/home/screen/home_screen.dart';
import 'package:surajashray/features/home/screen/vital_signs_details_screen.dart';
import 'package:surajashray/features/scan/screens/scan_your_meal_screen.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavigationController controller = Get.put(
      BottomNavigationController(),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Obx(() => _getPage(controller.currentIndex)),

          // Bottom navigation overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(
              () => CustomStackBottomNavBar(
                currentIndex: controller.currentIndex,
                onTabSelected: (index) => controller.changeTab(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const VitalSignsDetailsScreen(showBackButton: false);
      case 2:
        return const ScanYourMealScreen();
      case 3:
        return ChatHistoryScreen();
      case 4:
        return AccountScreen();
      default:
        return const HomeScreen();
    }
  }
}
