import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FoodDiaryService extends GetxService {
  // Store all food logs organized by date
  final RxMap<String, List<Map<String, dynamic>>> _foodLogsByDate =
      <String, List<Map<String, dynamic>>>{}.obs;

  // Current date's meals for quick access
  final RxList<Map<String, dynamic>> _currentDateMeals =
      <Map<String, dynamic>>[].obs;

  // Getters
  Map<String, List<Map<String, dynamic>>> get foodLogsByDate => _foodLogsByDate;
  List<Map<String, dynamic>> get currentDateMeals => _currentDateMeals;
  RxList<Map<String, dynamic>> get currentDateMealsRx => _currentDateMeals;

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  void _initializeService() {
    // Initialize with current date
    final today = _getDateKey(DateTime.now());
    if (!_foodLogsByDate.containsKey(today)) {
      _foodLogsByDate[today] = [];
    }

    // Add some default meals for demo purposes if no meals exist
    if (_foodLogsByDate[today]!.isEmpty) {
      _addDefaultMealsForToday();
    }

    // Use assignAll to properly sync the reactive list
    _currentDateMeals.assignAll(_foodLogsByDate[today] ?? []);
  }

  void _addDefaultMealsForToday() {
    final currentDate = _getDateKey(DateTime.now());
    _foodLogsByDate[currentDate] = [
      {
        'id': 'breakfast_${DateTime.now().millisecondsSinceEpoch}',
        'title': 'Breakfast',
        'subtitle': 'Oatmeal Bowl',
        'time': '7.00 AM',
        'color': 0xFF34C759,
        'checked': false,
        'icon': 'assets/icons/breakfast.png',
        'calories': 250,
        'protein': 8,
        'carbs': 45,
        'fat': 5,
        'mealType': 'breakfast',
        'date': currentDate,
        'dateAdded': DateTime.now().toIso8601String(),
      },
      {
        'id': 'lunch_${DateTime.now().millisecondsSinceEpoch + 1}',
        'title': 'Lunch',
        'subtitle': 'Grilled Chicken Salad',
        'time': '12:30 PM',
        'color': 0xFFD46434,
        'checked': false,
        'icon': 'assets/icons/lunch.png',
        'calories': 350,
        'protein': 30,
        'carbs': 20,
        'fat': 15,
        'mealType': 'lunch',
        'date': currentDate,
        'dateAdded': DateTime.now().toIso8601String(),
      },
      {
        'id': 'dinner_${DateTime.now().millisecondsSinceEpoch + 2}',
        'title': 'Dinner',
        'subtitle': 'Salmon with Quinoa',
        'time': '7:00 PM',
        'color': 0xFF4A7BFF,
        'checked': false,
        'icon': 'assets/icons/dinner.png',
        'calories': 450,
        'protein': 35,
        'carbs': 40,
        'fat': 20,
        'mealType': 'dinner',
        'date': currentDate,
        'dateAdded': DateTime.now().toIso8601String(),
      },
    ];
  }

  // Add a meal to a specific date
  void addMeal(Map<String, dynamic> mealData) {
    // Extract date from meal data or use current date
    final dateAdded = mealData['dateAdded'] != null
        ? DateTime.parse(mealData['dateAdded'])
        : DateTime.now();

    final dateKey = _getDateKey(dateAdded);

    // Initialize date entry if doesn't exist
    if (!_foodLogsByDate.containsKey(dateKey)) {
      _foodLogsByDate[dateKey] = [];
    }

    // Add meal to the specific date
    _foodLogsByDate[dateKey]!.add(mealData);

    // Update current date meals if it's today
    final today = _getDateKey(DateTime.now());
    if (dateKey == today) {
      // Use reactive list methods instead of replacing the entire list
      _currentDateMeals.add(mealData);
      _currentDateMeals.refresh(); // Ensure UI updates
    }

    // Trigger reactive update
    _foodLogsByDate.refresh();

    print('Meal added to $dateKey: ${mealData['subtitle']}');
  }

  // Get meals for a specific date
  List<Map<String, dynamic>> getMealsForDate(DateTime date) {
    final dateKey = _getDateKey(date);
    return _foodLogsByDate[dateKey] ?? [];
  }

  // Remove a meal by ID
  void removeMeal(String mealId) {
    bool removedFromCurrentDate = false;

    for (String dateKey in _foodLogsByDate.keys) {
      final initialLength = _foodLogsByDate[dateKey]!.length;
      _foodLogsByDate[dateKey]!.removeWhere((meal) => meal['id'] == mealId);

      // Check if we removed from current date
      final today = _getDateKey(DateTime.now());
      if (dateKey == today &&
          _foodLogsByDate[dateKey]!.length < initialLength) {
        removedFromCurrentDate = true;
      }
    }

    // Update current date meals if we removed from today
    if (removedFromCurrentDate) {
      final today = _getDateKey(DateTime.now());
      _currentDateMeals.assignAll(_foodLogsByDate[today] ?? []);
    }

    _foodLogsByDate.refresh();
  }

  // Calculate nutrition totals for a specific date
  Map<String, dynamic> calculateDailyNutrition(DateTime date) {
    final meals = getMealsForDate(date);

    int totalCalories = 0;
    int totalProtein = 0;
    int totalCarbs = 0;
    int totalFats = 0;

    for (var meal in meals) {
      totalCalories += int.tryParse(meal['calories']?.toString() ?? '0') ?? 0;
      totalProtein += int.tryParse(meal['protein']?.toString() ?? '0') ?? 0;
      totalCarbs += int.tryParse(meal['carbs']?.toString() ?? '0') ?? 0;
      totalFats += int.tryParse(meal['fats']?.toString() ?? '0') ?? 0;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fats': totalFats,
      'mealCount': meals.length,
    };
  }

  // Get meal breakdown by meal type for a date
  Map<String, List<Map<String, dynamic>>> getMealsByType(DateTime date) {
    final meals = getMealsForDate(date);
    Map<String, List<Map<String, dynamic>>> mealsByType = {
      'Breakfast': [],
      'Lunch': [],
      'Dinner': [],
      'Snack': [],
      'Other': [],
    };

    for (var meal in meals) {
      String mealType = meal['title'] ?? 'Other';
      if (mealType.toLowerCase().contains('snack') ||
          mealType.toLowerCase().contains('afternoon')) {
        mealType = 'Snack';
      }

      if (mealsByType.containsKey(mealType)) {
        mealsByType[mealType]!.add(meal);
      } else {
        mealsByType['Other']!.add(meal);
      }
    }

    return mealsByType;
  }

  // Check if user has meals on a specific date
  bool hasMealsOnDate(DateTime date) {
    final meals = getMealsForDate(date);
    return meals.isNotEmpty;
  }

  // Get date range with meals (for calendar features)
  List<DateTime> getDatesWithMeals() {
    return _foodLogsByDate.keys
        .map((dateKey) => DateTime.parse(dateKey))
        .toList()
      ..sort();
  }

  // Helper method to format date as key
  String _getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Clear all data (for testing or logout)
  void clearAllData() {
    _foodLogsByDate.clear();
    _currentDateMeals.clear();
    _initializeService();
  }

  // Export data (for backup/sync)
  Map<String, dynamic> exportData() {
    return {
      'foodLogsByDate': _foodLogsByDate.toJson(),
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  // Import data (for restore/sync)
  void importData(Map<String, dynamic> data) {
    if (data['foodLogsByDate'] != null) {
      _foodLogsByDate.clear();
      final Map<String, dynamic> importedData = data['foodLogsByDate'];

      importedData.forEach((dateKey, meals) {
        _foodLogsByDate[dateKey] = List<Map<String, dynamic>>.from(meals);
      });

      // Update current date meals
      final today = _getDateKey(DateTime.now());
      _currentDateMeals.value = _foodLogsByDate[today] ?? [];
      _foodLogsByDate.refresh();
    }
  }

  /// Clear all meals for the current date (for testing purposes)
  void clearCurrentDateMeals() {
    final currentDate = _getDateKey(DateTime.now());
    _foodLogsByDate[currentDate] = [];
    _currentDateMeals.clear();
    _foodLogsByDate.refresh();
  }

  /// Reset current date meals to default state (for testing purposes)
  void resetCurrentDateMeals() {
    final currentDate = _getDateKey(DateTime.now());
    _foodLogsByDate[currentDate] = [
      {
        'id': 'breakfast_${DateTime.now().millisecondsSinceEpoch}',
        'title': 'Breakfast',
        'subtitle': 'Oatmeal Bowl',
        'time': '7.00 AM',
        'color': 0xFF34C759,
        'checked': false,
        'icon': 'assets/icons/breakfast.png',
        'calories': 250,
        'protein': 8,
        'carbs': 45,
        'fat': 5,
        'mealType': 'breakfast',
        'date': currentDate,
      },
      {
        'id': 'lunch_${DateTime.now().millisecondsSinceEpoch}',
        'title': 'Lunch',
        'subtitle': 'Grilled Chicken Salad',
        'time': '12:30 PM',
        'color': 0xFFD46434,
        'checked': false,
        'icon': 'assets/icons/lunch.png',
        'calories': 350,
        'protein': 30,
        'carbs': 20,
        'fat': 15,
        'mealType': 'lunch',
        'date': currentDate,
      },
      {
        'id': 'dinner_${DateTime.now().millisecondsSinceEpoch}',
        'title': 'Dinner',
        'subtitle': 'Salmon with Quinoa',
        'time': '7:00 PM',
        'color': 0xFF4A7BFF,
        'checked': false,
        'icon': 'assets/icons/dinner.png',
        'calories': 450,
        'protein': 35,
        'carbs': 40,
        'fat': 20,
        'mealType': 'dinner',
        'date': currentDate,
      },
    ];
    _currentDateMeals.assignAll(_foodLogsByDate[currentDate]!);
    _foodLogsByDate.refresh();
  }
}
