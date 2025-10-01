import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/nudge_model.dart';
import 'daily_nudges_controller.dart';

class AddNudgesController extends GetxController {
  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // Observable variables
  final Rx<NudgeCategory?> _selectedCategory = Rx<NudgeCategory?>(
    NudgeCategory.hydration,
  );
  final RxString _selectedUnit = 'ML'.obs;
  final RxDouble _quickAddValue = 250.0.obs;
  final RxList<bool> _selectedDays = [
    false,
    true,
    true,
    true,
    true,
    true,
    true,
  ].obs; // [M,T,W,T,F,S,S]
  final RxBool _isLoading = false.obs;
  final RxString _selectedDate = ''.obs;

  // Getters
  NudgeCategory? get selectedCategory => _selectedCategory.value;
  String get selectedUnit => _selectedUnit.value;
  double get quickAddValue => _quickAddValue.value;
  List<bool> get selectedDays => _selectedDays;
  bool get isLoading => _isLoading.value;
  String get selectedDate => _selectedDate.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint('AddNudgesController initialized');
    _initializeForm();
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    super.onClose();
    debugPrint('AddNudgesController disposed');
  }

  void _initializeForm() {
    // Set default date to today
    final todayFormatted = _formatDate(DateTime.now());
    dateController.text = todayFormatted;
    _selectedDate.value = todayFormatted;
  }

  void _clearForm() {
    // Clear text controllers
    titleController.clear();

    // Reset to default values
    _selectedCategory.value = NudgeCategory.hydration;
    _selectedUnit.value = 'ML';
    _quickAddValue.value = 250.0;
    _selectedDays.value = [false, true, true, true, true, true, true];

    // Reset date to today
    final todayFormatted = _formatDate(DateTime.now());
    dateController.text = todayFormatted;
    _selectedDate.value = todayFormatted;
  }

  // Category selection
  void selectCategory(NudgeCategory category) {
    _selectedCategory.value = category;

    // Update unit and quick add value based on category
    final defaultUnits = category.defaultUnits;
    if (defaultUnits.isNotEmpty) {
      _selectedUnit.value = defaultUnits.first;
    }

    // Set default quick add values based on category
    switch (category) {
      case NudgeCategory.hydration:
        _quickAddValue.value = 250.0;
        break;
      case NudgeCategory.movement:
        _quickAddValue.value = 1000.0;
        break;
      case NudgeCategory.sleep:
        _quickAddValue.value = 8.0;
        break;
      case NudgeCategory.weight:
        _quickAddValue.value = 70.0;
        break;
    }

    debugPrint('Selected category: ${category.displayName}');
  }

  // Unit selection
  void selectUnit(String unit) {
    _selectedUnit.value = unit;
    debugPrint('Selected unit: $unit');
  }

  // Quick add value adjustment
  void adjustQuickAddValue(double adjustment) {
    final newValue = _quickAddValue.value + adjustment;
    if (newValue >= 0) {
      _quickAddValue.value = newValue;
      debugPrint('Quick add value adjusted to: $newValue');
    }
  }

  void setQuickAddValue(double value) {
    if (value >= 0) {
      _quickAddValue.value = value;
      debugPrint('Quick add value set to: $value');
    }
  }

  // Day selection
  void toggleDay(int dayIndex) {
    if (dayIndex >= 0 && dayIndex < _selectedDays.length) {
      _selectedDays[dayIndex] = !_selectedDays[dayIndex];
      debugPrint('Day $dayIndex toggled: ${_selectedDays[dayIndex]}');
    }
  }

  // Date selection
  void selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4A7BFF),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF161618),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = _formatDate(picked);
      dateController.text = formattedDate;
      _selectedDate.value = formattedDate;
      debugPrint('Date selected: $formattedDate');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Form submission
  void onSaveChanges() async {
    if (!_validateForm()) {
      return;
    }

    _isLoading.value = true;

    try {
      // Create new nudge
      final newNudge = NudgeModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        description: _generateDescription(),
        category: _selectedCategory.value!,
        currentValue: 0,
        targetValue: _quickAddValue.value,
        unit: _selectedUnit.value,
        date: _parseDate(dateController.text),
        scheduledDays: List.from(_selectedDays),
      );

      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Add the nudge to the daily nudges controller
      if (Get.isRegistered<DailyNudgesController>()) {
        Get.find<DailyNudgesController>().addNudge(newNudge);
      }

      debugPrint('Created nudge: ${newNudge.title}');

      // Clear form fields
      _clearForm();

      // Navigate back
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Nudge created successfully!',
        backgroundColor: Color(0xFF34C759),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create nudge. Please try again.',
        backgroundColor: Color(0xFFFF3B30),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void onDeleteNudge() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Nudge',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF161618),
          ),
        ),
        content: Text(
          'Are you sure you want to delete this nudge?',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8E8E93),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8E8E93),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to previous screen
              Get.snackbar(
                'Deleted',
                'Nudge deleted successfully',
                backgroundColor: Color(0xFFFF3B30),
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF3B30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a nudge title',
        backgroundColor: Color(0xFFFF3B30),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      return false;
    }

    if (_selectedCategory.value == null) {
      Get.snackbar(
        'Error',
        'Please select a category',
        backgroundColor: Color(0xFFFF3B30),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      return false;
    }

    if (!_selectedDays.any((day) => day)) {
      Get.snackbar(
        'Error',
        'Please select at least one day',
        backgroundColor: Color(0xFFFF3B30),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      return false;
    }

    return true;
  }

  String _generateDescription() {
    final category = _selectedCategory.value!;
    final value = _quickAddValue.value;
    final unit = _selectedUnit.value;

    switch (category) {
      case NudgeCategory.hydration:
        return 'Target: ${_formatValue(value)} $unit of water today';
      case NudgeCategory.movement:
        return 'Target: ${_formatValue(value)} $unit today';
      case NudgeCategory.sleep:
        return 'Target: ${_formatValue(value)} $unit of sleep';
      case NudgeCategory.weight:
        return 'Target: ${_formatValue(value)}$unit';
    }
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  DateTime _parseDate(String dateString) {
    final parts = dateString.split('/');
    if (parts.length == 3) {
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }
    return DateTime.now();
  }

  // Navigation
  void onBackPressed() {
    Get.back();
  }
}
