import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:surajashray/core/services/food_diary_service.dart';

class FoodDiaryDetailsController extends GetxController {
  // Get the FoodDiaryService instance
  FoodDiaryService get _foodDiaryService => Get.find<FoodDiaryService>();

  // Date navigation
  final Rx<DateTime> _selectedDate = DateTime.now().obs;

  // Daily overview data - now calculated from actual meals
  final RxInt _targetCalories = 2200.obs;

  // Meals data - now gets actual logged meals
  final RxList<Map<String, dynamic>> _todaysMeals =
      <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> _plannedMeals = <Map<String, dynamic>>[
    {
      'title': "Tomorrow's Breakfast",
      'description': 'Greek yogurt with granola',
      'icon': 'assets/icons/breakfast.png',
      'iconColor': 0xFF34C759,
    },
    {
      'title': "Tomorrow's Lunch",
      'description': 'Quinoa Buddha bowl',
      'icon': 'assets/icons/lunch.png',
      'iconColor': 0xFFD46434,
    },
  ].obs;

  // Getters
  DateTime get selectedDate => _selectedDate.value;
  String get selectedDateTitle {
    final now = DateTime.now();
    final selected = _selectedDate.value;

    if (selected.year == now.year &&
        selected.month == now.month &&
        selected.day == now.day) {
      return 'Today';
    } else if (selected.year == now.year &&
        selected.month == now.month &&
        selected.day == now.day + 1) {
      return 'Tomorrow';
    } else if (selected.year == now.year &&
        selected.month == now.month &&
        selected.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE').format(selected);
    }
  }

  String get selectedDateSubtitle =>
      DateFormat('MMMM d, y').format(_selectedDate.value);

  // Daily nutrition calculated from actual meals
  int get consumedCalories {
    final nutrition = _foodDiaryService.calculateDailyNutrition(
      _selectedDate.value,
    );
    return nutrition['calories'] ?? 0;
  }

  int get targetCalories => _targetCalories.value;

  int get carbs {
    final nutrition = _foodDiaryService.calculateDailyNutrition(
      _selectedDate.value,
    );
    return nutrition['carbs'] ?? 0;
  }

  int get protein {
    final nutrition = _foodDiaryService.calculateDailyNutrition(
      _selectedDate.value,
    );
    return nutrition['protein'] ?? 0;
  }

  int get fat {
    final nutrition = _foodDiaryService.calculateDailyNutrition(
      _selectedDate.value,
    );
    return nutrition['fats'] ?? 0;
  }

  // Default values for nutrients not tracked in our meal system yet
  double get water => 2.1; // Default water intake
  int get fiber => (carbs * 0.15).round(); // Estimate fiber as 15% of carbs
  int get sugar => (carbs * 0.25).round(); // Estimate sugar as 25% of carbs

  List<Map<String, dynamic>> get todaysMeals => _todaysMeals;
  List<Map<String, dynamic>> get plannedMeals => _plannedMeals;

  // Methods
  void previousDay() {
    _selectedDate.value = _selectedDate.value.subtract(const Duration(days: 1));
    _loadDataForDate(_selectedDate.value);
  }

  void nextDay() {
    _selectedDate.value = _selectedDate.value.add(const Duration(days: 1));
    _loadDataForDate(_selectedDate.value);
  }

  void deleteMeal(Map<String, dynamic> meal) {
    final mealId = meal['id'];
    if (mealId != null) {
      // Remove meal from the current meals list
      _todaysMeals.removeWhere((m) => m['id'] == mealId);

      // Also remove from the food diary service
      _foodDiaryService.removeMeal(mealId);
    }
  }

  void _loadDataForDate(DateTime date) {
    // Load actual meal data from FoodDiaryService for the selected date
    final meals = _foodDiaryService.getMealsForDate(date);

    // Transform meals to the format expected by the UI
    final transformedMeals = meals
        .map((meal) => _transformMealForUI(meal))
        .toList();

    _todaysMeals.value = transformedMeals;

    print('Loading data for date: ${DateFormat('yyyy-MM-dd').format(date)}');
    print('Found ${meals.length} meals for this date');
  }

  Map<String, dynamic> _transformMealForUI(Map<String, dynamic> meal) {
    // Transform meal data from FoodDiaryService format to UI format
    return {
      'id': meal['id'], // Preserve original meal ID for deletion
      'mealType': meal['title'] ?? 'Unknown',
      'time': meal['time'] ?? '',
      'icon': meal['icon'] ?? 'assets/icons/breakfast.png',
      'iconColor': meal['color'] ?? 0xFF34C759,
      'foodName': meal['subtitle'] ?? 'Unknown Meal',
      'foodImage': meal['imagePath'] ?? 'assets/images/default_meal.jpg',
      'calories': int.tryParse(meal['calories']?.toString() ?? '0') ?? 0,
      'protein': int.tryParse(meal['protein']?.toString() ?? '0') ?? 0,
      'carbs': int.tryParse(meal['carbs']?.toString() ?? '0') ?? 0,
      'fat': int.tryParse(meal['fat']?.toString() ?? '0') ?? 0,
      'keyNutrients': _generateKeyNutrients(meal),
      'aiRecommendation': _generateAIRecommendation(meal),
    };
  }

  List<Map<String, String>> _generateKeyNutrients(Map<String, dynamic> meal) {
    // Generate key nutrients based on meal type and nutrition values
    final mealType = meal['title']?.toString().toLowerCase() ?? '';
    final calories = int.tryParse(meal['calories']?.toString() ?? '0') ?? 0;
    final protein = int.tryParse(meal['protein']?.toString() ?? '0') ?? 0;

    List<Map<String, String>> nutrients = [];

    if (mealType.contains('breakfast')) {
      nutrients = [
        {'name': 'Vitamin C', 'value': '${(calories * 0.1).round()}%'},
        {'name': 'Fiber', 'value': '${(protein * 0.8).round()}g'},
        {'name': 'Iron', 'value': '${(calories * 0.02).round()}%'},
      ];
    } else if (mealType.contains('lunch')) {
      nutrients = [
        {'name': 'Vitamin A', 'value': '${(calories * 0.12).round()}%'},
        {'name': 'Folate', 'value': '${(protein * 0.7).round()}%'},
        {'name': 'B12', 'value': '${(protein * 2.8).round()}%'},
      ];
    } else if (mealType.contains('dinner')) {
      nutrients = [
        {'name': 'Omega-3', 'value': 'High'},
        {'name': 'Vitamin D', 'value': '${(protein * 2.2).round()}%'},
        {'name': 'B6', 'value': '${(protein * 1.8).round()}%'},
      ];
    } else {
      nutrients = [
        {'name': 'Energy', 'value': '${calories}cal'},
        {'name': 'Protein', 'value': '${protein}g'},
        {'name': 'Nutrients', 'value': 'Balanced'},
      ];
    }

    return nutrients;
  }

  Map<String, dynamic>? _generateAIRecommendation(Map<String, dynamic> meal) {
    final protein = int.tryParse(meal['protein']?.toString() ?? '0') ?? 0;
    final calories = int.tryParse(meal['calories']?.toString() ?? '0') ?? 0;

    // Generate AI recommendations based on nutrition values
    if (protein >= 25 && calories >= 400) {
      return {
        'type': 'success',
        'message': 'Perfect protein goal achieved!',
        'backgroundColor': 0xFFE1F7E6,
        'borderColor': 0x8034C759,
        'iconBgColor': 0xFFC0EECC,
        'iconColor': 0xFF34C759,
        'textColor': 0xFF34C759,
      };
    } else if (protein >= 15 && calories >= 250) {
      return {
        'type': 'suggestion',
        'message': 'Great nutrition balance! Consider adding more vegetables.',
        'backgroundColor': 0xFFE4EBFF,
        'borderColor': 0x804A7BFF,
        'iconBgColor': 0xFFC7D6FF,
        'iconColor': 0xFF4A7BFF,
        'textColor': 0xFF4A7BFF,
      };
    }

    return null; // No recommendation for low nutrition meals
  }

  @override
  void onInit() {
    super.onInit();
    _loadDataForDate(_selectedDate.value);

    // Listen to changes in the selected date
    ever(_selectedDate, (date) {
      _loadDataForDate(date);
    });
  }
}
