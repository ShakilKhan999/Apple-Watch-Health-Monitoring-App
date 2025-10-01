import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:surajashray/features/scan/controllers/scan_screen_controller.dart';

class BottomNavigationController extends GetxController {
  // Current selected index
  final RxInt _currentIndex = 0.obs;

  // Getters
  int get currentIndex => _currentIndex.value;

  // Navigation items data
  final List<Map<String, dynamic>> navigationItems = [
    {
      'label': 'Home',
      'icon': Icons.home_outlined,
      'activeIcon': Icons.home,
      'isActive': true,
    },
    {
      'label': 'Track',
      'icon': Icons.show_chart_outlined,
      'activeIcon': Icons.show_chart,
      'isActive': false,
    },
    {
      'label': 'Scan',
      'icon': Icons.qr_code_scanner_outlined,
      'activeIcon': Icons.qr_code_scanner,
      'isActive': false,
      'isCenter': true, // Special center button
    },
    {
      'label': 'Chat',
      'icon': Icons.chat_bubble_outline,
      'activeIcon': Icons.chat_bubble,
      'isActive': false,
    },
    {
      'label': 'Profile',
      'icon': Icons.person_outline,
      'activeIcon': Icons.person,
      'isActive': false,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    debugPrint('BottomNavigationController initialized');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('BottomNavigationController disposed');
  }

  // Change tab
  void changeTab(int index) {
    if (_currentIndex.value != index) {
      // Handle camera lifecycle when leaving scan screen
      if (_currentIndex.value == 2) {
        _pauseScanCamera();
      }

      _currentIndex.value = index;
      _handleNavigation(index);

      // Handle camera lifecycle when entering scan screen
      if (index == 2) {
        _resumeScanCamera();
      }
    }
  }

  // Handle camera lifecycle for scan screen
  void _pauseScanCamera() {
    try {
      final scanController = Get.find<ScanScreenController>();
      scanController.pauseCamera();
      debugPrint('Camera paused when leaving scan tab');
    } catch (e) {
      debugPrint('No scan controller found: $e');
    }
  }

  void _resumeScanCamera() {
    try {
      final scanController = Get.find<ScanScreenController>();
      scanController.resumeCamera();
      debugPrint('Camera resumed when entering scan tab');
    } catch (e) {
      debugPrint('No scan controller found: $e');
    }
  }

  // Handle navigation based on index
  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Already on home
        debugPrint('Navigate to Home');
        break;
      case 1:
        // Navigate to Track screen
        debugPrint('Navigate to Track screen');
        break;
      case 2:
        // Navigate to Scan screen
        debugPrint('Navigate to Scan screen');
        break;
      case 3:
        // Navigate to Chat screen
        debugPrint('Navigate to Chat screen');
        break;
      case 4:
        // Navigate to Profile screen
        debugPrint('Navigate to Profile screen');
        break;
    }
  }
}
