import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/widgets/success_dialog.dart';
import 'package:surajashray/features/home/controllers/home_controller.dart';

class ExistingMealsController extends GetxController {
  // Reactive variables
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;
  final RxList<Map<String, dynamic>> _filteredMeals =
      <Map<String, dynamic>>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  List<Map<String, dynamic>> get filteredMeals => _filteredMeals;

  // Search controller
  final TextEditingController searchController = TextEditingController();

  // Sample existing meals data (this would come from API in real app)
  final List<Map<String, dynamic>> _allMeals = [];

  // Meal types
  final List<String> mealTypes = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];
  final RxString _selectedMealType = 'All'.obs;
  String get selectedMealType => _selectedMealType.value;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    debugPrint('ExistingMealsController initialized');
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh data when screen becomes ready
    _initializeData();

    // Listen to changes in home controller's food diary
    final homeController = Get.find<HomeController>();
    ever(homeController.foodDiaryRx, (_) {
      _initializeData();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
    debugPrint('ExistingMealsController disposed');
  }

  void _initializeData() {
    // Only show user-added meals from home controller (no hardcoded data)
    final List<Map<String, dynamic>> allMeals = [];

    try {
      final homeController = Get.find<HomeController>();
      final addedMeals = homeController.foodDiary;

      debugPrint('Found ${addedMeals.length} meals in food diary');

      // Convert home controller meals to existing meals format
      for (var meal in addedMeals) {
        debugPrint('Processing meal: ${meal['subtitle']}');
        allMeals.add({
          'id': meal['id'].toString(),
          'name': meal['subtitle'] ?? 'Untitled Meal',
          'calories': meal['calories']?.toString() ?? '0',
          'mealType': meal['title'] ?? 'Breakfast',
          'protein': meal['protein']?.toString() ?? '0g',
          'carbs': meal['carbs']?.toString() ?? '0g',
          'fats': meal['fats']?.toString() ?? '0g',
          'image': meal['imagePath'] ?? 'assets/images/default_meal.jpg',
          'description': meal['notes'] ?? 'Custom meal added by user',
        });
      }
    } catch (e) {
      debugPrint('Error accessing HomeController: $e');
    }

    debugPrint('Total processed meals: ${allMeals.length}');

    // Update the all meals list and filter
    _allMeals.clear();
    _allMeals.addAll(allMeals);
    _filterMeals();
  }

  // Filter meals by type
  void selectMealType(String mealType) {
    _selectedMealType.value = mealType;
    _filterMeals();
    debugPrint('Selected meal type: $mealType');
  }

  // Search functionality
  void onSearchChanged(String query) {
    _searchQuery.value = query;
    _filterMeals();
  }

  void _filterMeals() {
    List<Map<String, dynamic>> filtered = _allMeals;

    // Filter by meal type
    if (selectedMealType != 'All') {
      filtered = filtered
          .where((meal) => meal['mealType'] == selectedMealType)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (meal) =>
                meal['name'].toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                meal['description'].toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    _filteredMeals.value = filtered;
    debugPrint('Filtered meals: ${filtered.length} items');
  }

  // Get meal type color
  Color getMealTypeColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFF34C759).withValues(alpha: 0.1);
      case 'lunch':
        return const Color(0xFFD46434).withValues(alpha: 0.1);
      case 'dinner':
        return const Color(0xFF4A7BFF).withValues(alpha: 0.1);
      case 'snack':
        return const Color(0xFF6F3FC3).withValues(alpha: 0.1);
      default:
        return const Color(0xFF34C759).withValues(alpha: 0.1);
    }
  }

  // Get meal type icon color
  Color getMealTypeIconColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFF34C759);
      case 'lunch':
        return const Color(0xFFD46434);
      case 'dinner':
        return const Color(0xFF4A7BFF);
      case 'snack':
        return const Color(0xFF6F3FC3);
      default:
        return const Color(0xFF34C759);
    }
  }

  // Add existing meal to food diary
  void addMealToFoodDiary(Map<String, dynamic> meal) async {
    _isLoading.value = true;

    try {
      // Get current time
      final now = DateTime.now();
      final formattedTime =
          '${now.hour > 12
              ? now.hour - 12
              : now.hour == 0
              ? 12
              : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

      // Create meal data for food diary
      final mealData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': meal['mealType'],
        'subtitle': meal['name'],
        'time': formattedTime,
        'color': getMealTypeIconColor(meal['mealType']).value,
        'checked': false,
        'icon': _getMealIcon(meal['mealType']),
        'calories': meal['calories'],
        'protein': meal['protein'],
        'carbs': meal['carbs'],
        'fats': meal['fats'],
        'notes': meal['description'],
        'imagePath': meal['image'],
        'dateAdded': DateTime.now().toIso8601String(),
      };

      // Add to home controller's food diary
      final homeController = Get.find<HomeController>();
      homeController.addMeal(mealData);

      debugPrint('Existing meal added to food diary: ${meal['name']}');

      // Show modern success dialog
      showSuccessDialog(
        title: 'Meal Added!',
        message:
            '${meal['name']} has been added to your food diary successfully.',
        animationPath: 'assets/animations/welcomeAnimation.gif',
        confirmText: 'Go to Home',
        onConfirm: () {
          // Navigate back to home
          Get.back();
        },
      );
    } catch (e) {
      // Show error dialog
      showErrorDialog(
        title: 'Error',
        message: 'Failed to add meal. Please try again.',
      );
      debugPrint('Error adding existing meal: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Get meal icon based on type
  String _getMealIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'assets/icons/breakfast.png';
      case 'lunch':
        return 'assets/icons/lunch.png';
      case 'dinner':
        return 'assets/icons/dinner.png';
      case 'snack':
        return 'assets/icons/breakfast.png'; // Using breakfast icon for snack
      default:
        return 'assets/icons/breakfast.png';
    }
  }

  // Navigation
  void onBackPressed() {
    Get.back();
  }

  // Manual refresh method
  void refreshMeals() {
    _initializeData();
    debugPrint('Meals list refreshed');
  }
}
