import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/custom_text_field.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/home/controllers/home_controller.dart';
import '../models/nudge_model.dart';

class DailyNudgesController extends GetxController {
  // Observable variables
  final RxList<NudgeModel> _nudges = <NudgeModel>[].obs;
  final RxList<UpcomingNudge> _upcomingNudges = <UpcomingNudge>[].obs;
  final RxBool _isLoading = false.obs;
  final RxDouble _todayProgress = 0.0.obs;
  final RxInt _completedNudges = 0.obs;
  final RxInt _totalNudges = 0.obs;

  // Getters
  List<NudgeModel> get nudges => _nudges;
  List<UpcomingNudge> get upcomingNudges => _upcomingNudges;
  bool get isLoading => _isLoading.value;
  double get todayProgress => _todayProgress.value;
  int get completedNudges => _completedNudges.value;
  int get totalNudges => _totalNudges.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint('DailyNudgesController initialized');
    _loadNudgesData();
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('DailyNudgesController disposed');
  }

  // Navigation methods
  void onAddNudgePressed() {
    debugPrint('Navigate to Add Nudges screen');
    Get.toNamed('/addNudgesScreen');
  }

  void onViewAllUpcomingPressed() {
    debugPrint('Navigate to All Upcoming Nudges screen');
    // Get.toNamed('/allUpcomingNudgesScreen');
  }

  // Nudge interaction methods
  void onLogNudge(String nudgeId, NudgeCategory category) {
    debugPrint('Log nudge: $nudgeId, category: ${category.displayName}');

    switch (category) {
      case NudgeCategory.hydration:
        _showLogWaterDialog(nudgeId);
        break;
      case NudgeCategory.movement:
        _showLogStepsDialog(nudgeId);
        break;
      case NudgeCategory.weight:
        _showLogWeightDialog(nudgeId);
        break;
      case NudgeCategory.sleep:
        _showLogSleepDialog(nudgeId);
        break;
    }
  }

  void _showLogWaterDialog(String nudgeId) {
    final TextEditingController customController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.textWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(
            maxHeight: 0.8.sh, // Limit dialog height to 80% of screen height
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Icon(
                    Icons.water_drop,
                    color: AppColors.primary,
                    size: 30.w,
                  ),
                ),
                16.verticalSpace,
                Text(
                  'Log Water Intake',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                6.verticalSpace,
                Text(
                  'How much water did you drink?',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                20.verticalSpace,
                // Custom input field
                CustomTextField(
                  label: '',
                  controller: customController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter amount in ML',
                ),
                16.verticalSpace,
                Text(
                  'Quick Add:',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                10.verticalSpace,
                // Quick add buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickLogButton('250ml', () {
                      customController.text = '250';
                    }),
                    _buildQuickLogButton('500ml', () {
                      customController.text = '500';
                    }),
                    _buildQuickLogButton('1L', () {
                      customController.text = '1000';
                    }),
                  ],
                ),
                20.verticalSpace,
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: AppColors.textSecondary.withValues(alpha:0.3),
                            ),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final value = double.tryParse(customController.text);
                          if (value != null && value > 0) {
                            _logWater(nudgeId, value);
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please enter a valid amount',
                              backgroundColor: AppColors.error,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Log',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogStepsDialog(String nudgeId) {
    final TextEditingController customController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(
            maxHeight: 0.8.sh, // Limit dialog height to 80% of screen height
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Icon(
                    Icons.directions_walk,
                    color: AppColors.primary,
                    size: 30.w,
                  ),
                ),
                16.verticalSpace,
                Text(
                  'Log Steps',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                Text(
                  'How many steps did you take?',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                // Custom input field
                CustomTextField(
                  label: '',
                  controller: customController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter number of steps',
                ),
                20.verticalSpace,
                Text(
                  'Quick Add:',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                12.verticalSpace,
                // Quick add buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickLogButton('1000', () {
                      customController.text = '1000';
                    }),
                    _buildQuickLogButton('2000', () {
                      customController.text = '2000';
                    }),
                    _buildQuickLogButton('5000', () {
                      customController.text = '5000';
                    }),
                  ],
                ),
                24.verticalSpace,
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: AppColors.textSecondary.withValues(alpha:0.3),
                            ),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final value = double.tryParse(customController.text);
                          if (value != null && value > 0) {
                            _logSteps(nudgeId, value);
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please enter a valid number of steps',
                              backgroundColor: AppColors.error,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Log',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLogButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha:0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  void _logWater(String nudgeId, double amount) {
    Get.back(); // Close dialog

    // Find the nudge and update it
    final nudgeIndex = _nudges.indexWhere((nudge) => nudge.id == nudgeId);
    if (nudgeIndex != -1) {
      final currentNudge = _nudges[nudgeIndex];
      final newCurrentValue = currentNudge.currentValue + amount;

      final updatedNudge = currentNudge.copyWith(
        currentValue: newCurrentValue,
        isCompleted: newCurrentValue >= currentNudge.targetValue,
        completedAt: newCurrentValue >= currentNudge.targetValue
            ? DateTime.now()
            : null,
      );

      _nudges[nudgeIndex] = updatedNudge;
      _calculateProgress();

      Get.snackbar(
        'Success',
        '${amount}ml water logged successfully!',
        backgroundColor: Color(0xFF34C759),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  void _logSteps(String nudgeId, double amount) {
    Get.back(); // Close dialog

    // Find the nudge and update it
    final nudgeIndex = _nudges.indexWhere((nudge) => nudge.id == nudgeId);
    if (nudgeIndex != -1) {
      final currentNudge = _nudges[nudgeIndex];
      final newCurrentValue = currentNudge.currentValue + amount;

      final updatedNudge = currentNudge.copyWith(
        currentValue: newCurrentValue,
        isCompleted: newCurrentValue >= currentNudge.targetValue,
        completedAt: newCurrentValue >= currentNudge.targetValue
            ? DateTime.now()
            : null,
      );

      _nudges[nudgeIndex] = updatedNudge;
      _calculateProgress();

      Get.snackbar(
        'Success',
        '${amount.toInt()} steps logged successfully!',
        backgroundColor: Color(0xFF34C759),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  void _calculateProgress() {
    if (_nudges.isEmpty) {
      _todayProgress.value = 0.0;
      _completedNudges.value = 0;
      _totalNudges.value = 0;
      return;
    }

    final completed = _nudges.where((nudge) => nudge.isCompleted).length;
    final total = _nudges.length;

    _completedNudges.value = completed;
    _totalNudges.value = total;
    _todayProgress.value = total > 0 ? (completed / total * 100) : 0.0;

    // Refresh home controller goals when nudges progress changes
    try {
      Get.find<HomeController>().refreshGoals();
    } catch (e) {
      debugPrint('HomeController not found, skipping goals refresh');
    }
  }

  // TODO: Replace with actual API service when backend is ready
  void _loadNudgesData() async {
    _isLoading.value = true;

    try {
      // TODO: Replace this mock data loading with API call
      // Example: final nudges = await _nudgesApiService.getNudges(date: DateTime.now());

      // Simulate API call delay
      await Future.delayed(Duration(milliseconds: 500));

      // For now, start with empty nudges list for new users
      // Later this will be: _nudges.value = nudges;
      _nudges.value = [];
      _upcomingNudges.value = [];

      _calculateProgress();
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      debugPrint('Error loading nudges: $e');
      // TODO: Handle API errors properly
      // Show error snackbar or retry mechanism
    }
  }

  void _generateUpcomingNudges() {
    final now = DateTime.now();
    final currentWeekday = now.weekday; // Monday = 1, Sunday = 7
    final upcomingList = <UpcomingNudge>[];

    // Generate upcoming nudges for today and tomorrow based on scheduled days
    for (final nudge in _nudges) {
      // Check if nudge is scheduled for today (convert DateTime weekday to our array index)
      final todayIndex = currentWeekday == 7
          ? 6
          : currentWeekday - 1; // Convert to 0-6 index (Mon-Sun)

      if (nudge.scheduledDays[todayIndex] && !nudge.isCompleted) {
        // Generate different times for different categories
        final time = _getScheduledTime(nudge.category, upcomingList.length);

        upcomingList.add(
          UpcomingNudge(
            id: '${nudge.id}_today',
            title: _getUpcomingTitle(nudge),
            time: time,
            category: nudge.category,
          ),
        );
      }
    }

    // Sort by time
    upcomingList.sort((a, b) => a.time.compareTo(b.time));

    _upcomingNudges.value = upcomingList;
  }

  String _getScheduledTime(NudgeCategory category, int index) {
    final baseHour = 9 + (index * 2); // Start from 9 AM, space 2 hours apart
    final hour = baseHour > 20 ? 20 : baseHour; // Cap at 8 PM

    switch (category) {
      case NudgeCategory.hydration:
        return '${hour}:00 AM';
      case NudgeCategory.movement:
        return '${hour + 1}:30 PM';
      case NudgeCategory.weight:
        return '8:00 AM'; // Morning weigh-in
      case NudgeCategory.sleep:
        return '10:00 PM'; // Evening reminder
    }
  }

  String _getUpcomingTitle(NudgeModel nudge) {
    switch (nudge.category) {
      case NudgeCategory.hydration:
        return 'Drink Water';
      case NudgeCategory.movement:
        return 'Time to Move';
      case NudgeCategory.weight:
        return 'Morning Weigh-in';
      case NudgeCategory.sleep:
        return 'Prepare for Sleep';
    }
  }

  void refreshData() {
    _loadNudgesData();
  }

  // Add new nudge to the list
  void addNudge(NudgeModel nudge) {
    _nudges.add(nudge);
    _generateUpcomingNudges(); // Generate upcoming nudges when a new nudge is added
    _calculateProgress();
    debugPrint('Nudge added: ${nudge.title}');
  }

  // Remove nudge from the list
  void removeNudge(String nudgeId) {
    _nudges.removeWhere((nudge) => nudge.id == nudgeId);
    _calculateProgress();
    debugPrint('Nudge removed: $nudgeId');
  }

  void _showLogWeightDialog(String nudgeId) {
    final TextEditingController customController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Icon(
                  Icons.monitor_weight,
                  color: AppColors.primary,
                  size: 30.w,
                ),
              ),
              16.verticalSpace,
              Text(
                'Log Weight',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                'Enter your current weight',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              // Custom input field
              CustomTextField(
                label: '',
                controller: customController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                hintText: 'Enter weight (kg)',
              ),
              24.verticalSpace,
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(
                            color: AppColors.textSecondary.withValues(alpha:0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final value = double.tryParse(customController.text);
                        if (value != null && value > 0) {
                          _logWeight(nudgeId, value);
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please enter a valid weight',
                            backgroundColor: AppColors.error,
                            colorText: Colors.white,
                            duration: Duration(seconds: 2),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Log',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogSleepDialog(String nudgeId) {
    final TextEditingController customController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Icon(
                  Icons.bedtime,
                  color: AppColors.primary,
                  size: 30.w,
                ),
              ),
              16.verticalSpace,
              Text(
                'Log Sleep',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                'How many hours did you sleep?',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              // Custom input field
              CustomTextField(
                label: '',
                controller: customController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                hintText: 'Enter hours (e.g., 7.5)',
              ),
              20.verticalSpace,
              Text(
                'Quick Add:',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              12.verticalSpace,
              // Quick add buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickLogButton('6h', () {
                    customController.text = '6';
                  }),
                  _buildQuickLogButton('7h', () {
                    customController.text = '7';
                  }),
                  _buildQuickLogButton('8h', () {
                    customController.text = '8';
                  }),
                ],
              ),
              24.verticalSpace,
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(
                            color: AppColors.textSecondary.withValues(alpha:0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final value = double.tryParse(customController.text);
                        if (value != null && value > 0) {
                          _logSleep(nudgeId, value);
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please enter valid sleep hours',
                            backgroundColor: AppColors.error,
                            colorText: Colors.white,
                            duration: Duration(seconds: 2),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Log',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logWeight(String nudgeId, double amount) {
    Get.back(); // Close dialog

    // Find the nudge and update it (for weight, we typically set the value, not add to it)
    final nudgeIndex = _nudges.indexWhere((nudge) => nudge.id == nudgeId);
    if (nudgeIndex != -1) {
      final currentNudge = _nudges[nudgeIndex];

      final updatedNudge = currentNudge.copyWith(
        currentValue: amount,
        isCompleted: true, // Weight logging typically completes the goal
        completedAt: DateTime.now(),
      );

      _nudges[nudgeIndex] = updatedNudge;
      _calculateProgress();

      Get.snackbar(
        'Success',
        '${amount}kg weight logged successfully!',
        backgroundColor: Color(0xFF34C759),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  void _logSleep(String nudgeId, double amount) {
    Get.back(); // Close dialog

    // Find the nudge and update it
    final nudgeIndex = _nudges.indexWhere((nudge) => nudge.id == nudgeId);
    if (nudgeIndex != -1) {
      final currentNudge = _nudges[nudgeIndex];

      final updatedNudge = currentNudge.copyWith(
        currentValue: amount,
        isCompleted: amount >= currentNudge.targetValue,
        completedAt: amount >= currentNudge.targetValue ? DateTime.now() : null,
      );

      _nudges[nudgeIndex] = updatedNudge;
      _calculateProgress();

      Get.snackbar(
        'Success',
        '${amount}h sleep logged successfully!',
        backgroundColor: Color(0xFF34C759),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }
}
