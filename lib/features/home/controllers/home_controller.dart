import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:surajashray/routes/app_routes.dart';
import 'package:surajashray/features/bottom_navigation/controllers/bottom_navigation_controller.dart';
import 'package:surajashray/core/services/food_diary_service.dart';
import 'package:surajashray/features/nudges/controllers/daily_nudges_controller.dart';
import 'package:surajashray/features/nudges/models/nudge_model.dart';
import 'package:surajashray/features/health/health_service.dart';

class HomeController extends GetxController {
  // Reactive variables
  final RxBool _isLoading = false.obs;
  final RxString _userName = 'Alex'.obs;
  final RxString _currentDate = ''.obs;
  final RxString _greeting = 'Good Morning'.obs;
  final RxDouble _wellnessScore = 85.0.obs;
  final RxString _weatherTemp = '24*C'.obs;
  final RxString _weatherDescription = 'Perfect for outdoor activities!'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get userName => _userName.value;
  String get currentDate => _currentDate.value;
  String get greeting => _greeting.value;
  double get wellnessScore => _wellnessScore.value;
  String get weatherTemp => _weatherTemp.value;
  String get weatherDescription => _weatherDescription.value;

  // Wellness score calculation method based on health data
  void updateWellnessScore() {
    double score = 0.0;
    int factors = 0;

    // Steps contribution (25%)
    if (_healthSummary.containsKey('steps')) {
      final steps = _healthSummary['steps'] as int? ?? 0;
      if (steps >= 10000) {
        score += 25;
      } else if (steps >= 7500) {
        score += 20;
      } else if (steps >= 5000) {
        score += 15;
      } else if (steps >= 2500) {
        score += 10;
      } else {
        score += 5;
      }
      factors++;
    }

    // Sleep contribution (25%)
    if (_healthSummary.containsKey('sleepHours')) {
      final sleep = _healthSummary['sleepHours'] as double? ?? 0.0;
      if (sleep >= 7.5 && sleep <= 9.0) {
        score += 25;
      } else if (sleep >= 6.5 && sleep <= 9.5) {
        score += 20;
      } else if (sleep >= 5.5 && sleep <= 10.0) {
        score += 15;
      } else {
        score += 8;
      }
      factors++;
    }

    // Heart rate contribution (25%)
    if (_healthSummary.containsKey('heartRate')) {
      final heartRate = _healthSummary['heartRate'] as double? ?? 0.0;
      if (heartRate >= 60 && heartRate <= 80) {
        score += 25;
      } else if (heartRate >= 55 && heartRate <= 90) {
        score += 20;
      } else if (heartRate >= 50 && heartRate <= 95) {
        score += 15;
      } else {
        score += 10;
      }
      factors++;
    }

    // Food diary completion contribution (25%)
    final mealsLogged = foodDiary.length;
    if (mealsLogged >= 3) {
      score += 25;
    } else if (mealsLogged >= 2) {
      score += 18;
    } else if (mealsLogged >= 1) {
      score += 12;
    } else {
      score += 5;
    }
    factors++;

    // Calculate final score
    if (factors > 0) {
      _wellnessScore.value = (score / factors * 4).clamp(0.0, 100.0);
    } else {
      _wellnessScore.value = 75.0; // Default score
    }

    debugPrint('Wellness score updated: ${_wellnessScore.value}');
  }

  // Vital signs data - now integrates with Apple Watch health data
  final RxMap<String, dynamic> _vitalSigns = <String, dynamic>{
    'steps': {'value': 'Loading...', 'color': 0xFFD46434},
    'sleep': {'value': 'Loading...', 'color': 0xFF4A7BFF},
    'heart': {'value': 'Loading...', 'color': 0xFFFF6B6B},
    'calories': {'value': 'Loading...', 'color': 0xFF6F3FC3},
  }.obs;

  // Health data state management
  final RxBool _isHealthDataLoading = false.obs;
  final RxBool _hasHealthPermissions = false.obs;
  final RxString _healthDataError = ''.obs;
  final RxMap<String, dynamic> _healthSummary = <String, dynamic>{}.obs;

  Map<String, dynamic> get vitalSigns => _vitalSigns;
  bool get isHealthDataLoading => _isHealthDataLoading.value;
  bool get hasHealthPermissions => _hasHealthPermissions.value;
  String get healthDataError => _healthDataError.value;
  Map<String, dynamic> get healthSummary => _healthSummary;

  // Food diary data - now gets data from FoodDiaryService
  FoodDiaryService get _foodDiaryService => Get.find<FoodDiaryService>();

  List<Map<String, dynamic>> get foodDiary =>
      _foodDiaryService.currentDateMeals;
  RxList<Map<String, dynamic>> get foodDiaryRx =>
      _foodDiaryService.currentDateMealsRx;

  // Goals data - now gets data from Daily Nudges
  List<Map<String, dynamic>> get goals {
    try {
      final dailyNudgesController = Get.find<DailyNudgesController>();
      final nudges = dailyNudgesController.nudges;

      return nudges.map((nudge) => _convertNudgeToGoal(nudge)).toList();
    } catch (e) {
      debugPrint('DailyNudgesController not found, returning static goals');
      // Fallback to static goals if DailyNudgesController is not available
      return [
        {
          'title': 'Lose Weight',
          'progress': '-2.3kg',
          'target': 'Target: 75kg',
          'progressValue': 0.6,
          'color': 0xFF34C759,
          'message': "You're 60% closer to your goal!",
          'icon': 'assets/icons/workout_predict.png',
        },
        {
          'title': 'Better Sleep',
          'progress': '7.5h',
          'target': 'Target: 8h daily',
          'progressValue': 0.65,
          'color': 0xFF4A7BFF,
          'message': 'Great progress! Almost there',
          'icon': 'assets/icons/sleep_monitor.png',
        },
      ];
    }
  }

  Map<String, dynamic> _convertNudgeToGoal(NudgeModel nudge) {
    final progressValue = nudge.progressPercentage / 100;
    final colorMap = {
      NudgeCategory.hydration: 0xFF4A7BFF,
      NudgeCategory.sleep: 0xFFD46434,
      NudgeCategory.weight: 0xFF34C759,
      NudgeCategory.movement: 0xFFD46434,
    };

    final iconMap = {
      NudgeCategory.hydration: 'assets/icons/water.svg',
      NudgeCategory.sleep: 'assets/icons/sleep_monitor.png',
      NudgeCategory.weight: 'assets/icons/weightLoss.svg',
      NudgeCategory.movement: 'assets/icons/steps.png',
    };

    String message;
    if (nudge.isCompleted) {
      message = 'Goal completed! Well done 🎉';
    } else if (progressValue > 0.8) {
      message = 'Almost there! You\'re doing great';
    } else if (progressValue > 0.5) {
      message = 'Great progress! Keep it up';
    } else if (progressValue > 0.2) {
      message = 'Good start! You\'re on track';
    } else {
      message = 'Let\'s get started on this goal';
    }

    return {
      'title': nudge.category.displayName,
      'progress': _formatProgress(nudge),
      'target': 'Target: ${_formatValue(nudge.targetValue)} ${nudge.unit}',
      'progressValue': progressValue,
      'color': colorMap[nudge.category] ?? 0xFF4A7BFF,
      'message': message,
      'icon': iconMap[nudge.category] ?? 'assets/icons/workout_predict.png',
    };
  }

  String _formatProgress(NudgeModel nudge) {
    if (nudge.currentValue == 0) {
      return '0 ${nudge.unit}';
    }
    return '${_formatValue(nudge.currentValue)} ${nudge.unit}';
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  // Quick actions data
  final RxList<Map<String, dynamic>> _quickActions = <Map<String, dynamic>>[
    {
      'title': 'Scan Meal',
      'recentResult': 'Grilled Chicken Salad',
      'timestamp': 'Uploaded on Aug 25, 2025 at 2:30 PM',
      'color': 0xFF6F3FC3,
      'backgroundColor': 0xFFEBE0FF,
      'icon': 'assets/icons/dinner.png',
      'trailingIcon': 'assets/icons/scan_active.png',
    },
    {
      'title': 'Lab Upload',
      'recentResult': 'Complete Blood Count',
      'timestamp': 'Uploaded on Aug 25, 2025 at 2:30 PM',
      'color': 0xFF4A7BFF,
      'backgroundColor': 0xFFE4EBFF,
      'icon': 'assets/icons/lab_report.png',
      'trailingIcon': 'assets/icons/upload.png',
    },
    {
      'title': 'Chat with Al',
      'recentResult': 'Perfect! Your sleep schedule is improving.',
      'timestamp': 'Uploaded on Aug 25, 2025 at 2:30 PM',
      'color': 0xFF34C759,
      'backgroundColor': 0xFFEFF9F1,
      'icon': 'assets/icons/chat_ai.png',
      'trailingIcon': 'assets/icons/chat_group.png',
    },
    {
      'title': 'View Nudges',
      'recentResult': 'Mindful Breathing',
      'timestamp': 'Uploaded on Aug 25, 2025 at 2:30 PM',
      'color': 0xFFD46434,
      'backgroundColor': 0xFFFFF9F2,
      'icon': 'assets/icons/nudges.png',
      'trailingIcon': 'assets/icons/workout_predict.png',
    },
  ].obs;

  List<Map<String, dynamic>> get quickActions => _quickActions;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _initializeHealthData();
    debugPrint('HomeController initialized');
  }

  // Method to refresh goals data
  void refreshGoals() {
    update(); // Trigger UI update
    debugPrint('Goals refreshed from nudges data');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('HomeController disposed');
  }

  // Initialize data
  void _initializeData() {
    _setCurrentDate();
    _setGreeting();
    _setLoading(false);
  }

  // Set current date
  void _setCurrentDate() {
    final now = DateTime.now();
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];

    _currentDate.value = '$dayName, $monthName ${now.day}';
  }

  // Set greeting based on time
  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting.value = 'Good Morning';
    } else if (hour < 17) {
      _greeting.value = 'Good Afternoon';
    } else {
      _greeting.value = 'Good Evening';
    }
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  // Navigation methods
  void onVitalSignsTap() {
    // Sync health data before navigation
    if (_hasHealthPermissions.value) {
      syncHealthData();
    }

    // Update bottom navigation to Track tab before navigation
    final bottomNavController = Get.find<BottomNavigationController>();
    bottomNavController.changeTab(1); // Track tab (index 1)

    // Navigate to vital signs detail screen with back button enabled
    Get.toNamed(
      AppRoute.getVitalSignsDetailsScreen(),
      arguments: {'showBackButton': true},
    );
    debugPrint('Navigate to vital signs detail');
  }

  /// Manual refresh for vital signs data
  Future<void> onVitalSignsRefresh() async {
    if (!_hasHealthPermissions.value) {
      await requestHealthPermissions();
    } else {
      await syncHealthData();
    }
  }

  void onFoodDiaryTap() {
    // Navigate to food diary details screen
    Get.toNamed(AppRoute.getFoodDiaryDetailsScreen());
    debugPrint('Navigate to food diary details');
  }

  // Toggle food diary item checked state
  void toggleFoodDiaryItem(int index) {
    final currentMeals = _foodDiaryService.currentDateMealsRx;
    if (index >= 0 && index < currentMeals.length) {
      currentMeals[index]['checked'] = !currentMeals[index]['checked'];
      // Trigger update to ensure UI reflects the change
      currentMeals.refresh();
      debugPrint(
        'Food diary item $index toggled: ${currentMeals[index]['checked']}',
      );
    }
  }

  void onGoalTap(String goalTitle) {
    // Navigate to specific goal detail
    debugPrint('Navigate to goal: $goalTitle');
  }

  void onQuickActionTap(String actionTitle) {
    // Handle quick action tap
    debugPrint('Quick action tapped: $actionTitle');
    switch (actionTitle.toLowerCase()) {
      case 'scan meal':
        // Navigate to scan meal screen
        break;
      case 'lab upload':
        Get.toNamed(AppRoute.getlabReportScreen());

        break;
      case 'chat with al':
        // Navigate to AI chat screen
        break;
      case 'view nudges':
        // Navigate to nudges screen
        Get.toNamed(AppRoute.getDailyNudgesScreen());
        break;
    }
  }

  void onNotificationTap() {
    // Navigate to notifications
    debugPrint('Navigate to notifications');
  }

  void onSettingsTap() {
    // Navigate to settings
    debugPrint('Navigate to settings');
  }

  // Food diary menu actions
  void onAddNewMeal() {
    // Navigate to add new meal screen
    Get.toNamed(AppRoute.getAddNewMealScreen());
    debugPrint('Navigate to add new meal');
  }

  void onAddExistingMeal() {
    // Navigate to add existing meal screen - only enabled if meals exist
    if (foodDiary.isNotEmpty) {
      Get.toNamed(AppRoute.getExistingMealsScreen());
      debugPrint('Navigate to add existing meal');
    }
  }

  // Add meal to food diary
  void addMeal(Map<String, dynamic> mealData) {
    final foodDiaryService = Get.find<FoodDiaryService>();
    foodDiaryService.addMeal(mealData);
    updateWellnessScore(); // Update wellness score after adding meal
    update();
    debugPrint('Meal added to food diary: ${mealData['subtitle']}');
  }

  // Remove meal from food diary
  void removeMeal(String mealId) {
    final foodDiaryService = Get.find<FoodDiaryService>();
    foodDiaryService.removeMeal(mealId);
    updateWellnessScore(); // Update wellness score after removing meal
    update();
    debugPrint('Meal removed from food diary: $mealId');
  }

  // For testing purposes - clear food diary to test empty state
  void clearFoodDiary() {
    final foodDiaryService = Get.find<FoodDiaryService>();
    foodDiaryService.clearCurrentDateMeals();
    update();
    debugPrint('Food diary cleared');
  }

  // For testing purposes - reset food diary to default state
  void resetFoodDiary() {
    final foodDiaryService = Get.find<FoodDiaryService>();
    foodDiaryService.resetCurrentDateMeals();
    update();
    debugPrint('Food diary reset to default');
  }

  // ============================================================================
  // HEALTH DATA INTEGRATION METHODS
  // ============================================================================

  /// Initialize health data on app start
  Future<void> _initializeHealthData() async {
    _setStaticVitalSigns(); // Set static data first for immediate display
    await _checkHealthPermissions();

    // If no permissions, automatically request them
    if (!_hasHealthPermissions.value) {
      await requestHealthPermissions();
    } else {
      // If permissions already granted, sync data
      await syncHealthData();
    }
  }

  /// Set static vital signs data for immediate display
  void _setStaticVitalSigns() {
    _vitalSigns.value = {
      'steps': {'value': '8,247', 'color': 0xFFD46434},
      'sleep': {'value': '7.5h', 'color': 0xFF4A7BFF},
      'heart': {'value': '72 BPM', 'color': 0xFFFF6B6B},
      'calories': {'value': '247', 'color': 0xFF6F3FC3},
    };
    debugPrint('Static vital signs data set');
  }

  /// Check health permissions
  Future<void> _checkHealthPermissions() async {
    try {
      bool initialized = await HealthService.initialize();
      if (initialized) {
        bool hasPermissions = await HealthService.hasPermissions();
        _hasHealthPermissions.value = hasPermissions;

        if (!hasPermissions) {
          _healthDataError.value = 'Health permissions not granted';
        } else {
          _healthDataError.value = '';
        }
      } else {
        _hasHealthPermissions.value = false;
        _healthDataError.value = 'Health service initialization failed';
      }
    } catch (e) {
      _hasHealthPermissions.value = false;
      _healthDataError.value = 'Error checking health permissions: $e';
      debugPrint('Health permissions check failed: $e');
    }
  }

  /// Request health permissions
  Future<void> requestHealthPermissions() async {
    try {
      _isHealthDataLoading.value = true;
      _healthDataError.value = '';

      bool granted = await HealthService.requestPermissions();
      _hasHealthPermissions.value = granted;

      if (granted) {
        await syncHealthData();
        _healthDataError.value = '';
        debugPrint('Health permissions granted and data synced');
      } else {
        _healthDataError.value =
            'Health permissions denied. Tap refresh to try again.';
        debugPrint('Health permissions denied by user');
      }
    } catch (e) {
      _healthDataError.value = 'Error requesting permissions: $e';
      debugPrint('Health permissions request failed: $e');
    } finally {
      _isHealthDataLoading.value = false;
    }
  }

  /// Manually sync health data from Apple Watch
  Future<void> syncHealthData() async {
    if (!_hasHealthPermissions.value) {
      _healthDataError.value = 'Health permissions not granted';
      return;
    }

    try {
      _isHealthDataLoading.value = true;
      _healthDataError.value = '';

      // Get health summary from HealthService
      final healthData = await HealthService.getHealthSummary();
      _healthSummary.assignAll(healthData);

      // Update vital signs with real data
      _updateVitalSignsFromHealthData(healthData);

      // Update wellness score based on new health data
      updateWellnessScore();

      debugPrint('Health data synced successfully: $healthData');
    } catch (e) {
      _healthDataError.value = 'Error syncing health data: $e';
      debugPrint('Health data sync failed: $e');
    } finally {
      _isHealthDataLoading.value = false;
    }
  }

  /// Update vital signs display with real health data
  void _updateVitalSignsFromHealthData(Map<String, dynamic> healthData) {
    _vitalSigns.value = {
      'steps': {
        'value': _formatSteps(healthData['steps']),
        'color': 0xFFD46434,
      },
      'sleep': {
        'value': _formatSleep(healthData['sleepHours']),
        'color': 0xFF4A7BFF,
      },
      'heart': {
        'value': _formatHeartRate(healthData['heartRate']),
        'color': 0xFFFF6B6B,
      },
      'calories': {
        'value': _formatCalories(healthData['activeCalories']),
        'color': 0xFF6F3FC3,
      },
    };

    // Trigger UI update
    _vitalSigns.refresh();
    debugPrint('Vital signs updated with real health data');
  }

  // ============================================================================
  // HEALTH DATA FORMATTING METHODS
  // ============================================================================

  String _formatSteps(dynamic steps) {
    if (steps == null) return 'N/A';

    final stepCount = steps is int ? steps : (steps as double).toInt();
    if (stepCount >= 1000) {
      return '${(stepCount / 1000).toStringAsFixed(1)}K';
    }
    return stepCount.toString();
  }

  String _formatSleep(dynamic sleepHours) {
    if (sleepHours == null) return 'N/A';

    final hours = sleepHours is double
        ? sleepHours
        : (sleepHours as int).toDouble();
    return '${hours.toStringAsFixed(1)}h';
  }

  String _formatHeartRate(dynamic heartRate) {
    if (heartRate == null) return 'N/A';

    final bpm = heartRate is double ? heartRate.toInt() : heartRate as int;
    return '$bpm BPM';
  }

  String _formatCalories(dynamic calories) {
    if (calories == null) return 'N/A';

    final cal = calories is double ? calories.toInt() : calories as int;
    if (cal >= 1000) {
      return '${(cal / 1000).toStringAsFixed(1)}K';
    }
    return cal.toString();
  }

  // ============================================================================
  // BACKEND INTEGRATION READY METHODS
  // ============================================================================

  /// Get health data formatted for backend API
  Map<String, dynamic> getHealthDataForBackend() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'userId': 'user_id_here', // Replace with actual user ID
      'healthData': Map<String, dynamic>.from(_healthSummary),
      'deviceInfo': {
        'source': 'Apple Watch',
        'platform': 'iOS',
        'appVersion': '1.0.0', // Replace with actual app version
      },
    };
  }

  /// Send health data to backend (placeholder for future implementation)
  Future<bool> sendHealthDataToBackend() async {
    try {
      if (_healthSummary.isEmpty) {
        debugPrint('No health data to send to backend');
        return false;
      }

      final dataPayload = getHealthDataForBackend();

      // TODO: Implement actual API call to backend
      // final response = await ApiService.postHealthData(dataPayload);

      debugPrint('Health data ready for backend: $dataPayload');

      // For now, return true as placeholder
      return true;
    } catch (e) {
      debugPrint('Error preparing health data for backend: $e');
      return false;
    }
  }

  // ============================================================================
  // DEBUG AND TESTING METHODS
  // ============================================================================

  /// Debug method to test health data flow
  void debugHealthDataFlow() async {
    debugPrint('=== HEALTH DATA FLOW TEST ===');
    debugPrint('1. Health Permissions: ${_hasHealthPermissions.value}');
    debugPrint('2. Health Data Loading: ${_isHealthDataLoading.value}');
    debugPrint('3. Health Data Error: ${_healthDataError.value}');
    debugPrint('4. Health Summary: $_healthSummary');
    debugPrint('5. Formatted Vital Signs: $_vitalSigns');

    if (_hasHealthPermissions.value) {
      debugPrint('6. Testing sync...');
      await syncHealthData();
      debugPrint('7. After sync - Health Summary: $_healthSummary');
      debugPrint('8. After sync - Vital Signs: $_vitalSigns');
    } else {
      debugPrint('6. No permissions - requesting...');
      await requestHealthPermissions();
    }

    debugPrint('9. Testing backend preparation...');
    final backendReady = await sendHealthDataToBackend();
    debugPrint('10. Backend ready: $backendReady');
    debugPrint('=== END TEST ===');
  }
}
