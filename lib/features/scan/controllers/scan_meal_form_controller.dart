import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surajashray/core/common/widgets/success_dialog.dart';
import 'package:surajashray/features/home/controllers/home_controller.dart';

class ScanMealFormController extends GetxController {
  // Form controllers
  final TextEditingController mealNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  // Reactive variables
  final RxBool _isLoading = false.obs;
  final RxString _selectedMealType = 'lunch'.obs;
  final Rx<File?> _scannedImage = Rx<File?>(null);

  // Getters
  bool get isLoading => _isLoading.value;
  String get selectedMealType => _selectedMealType.value;
  File? get scannedImage => _scannedImage.value;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Meal type options
  List<String> get mealTypes => [
    'lunch'.tr,
    'breakfast'.tr,
    'snack'.tr,
    'dinner'.tr,
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    debugPrint('ScanMealFormController initialized');
  }

  @override
  void onClose() {
    // Dispose controllers
    mealNameController.dispose();
    notesController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatsController.dispose();
    timeController.dispose();
    super.onClose();
    debugPrint('ScanMealFormController disposed');
  }

  // Initialize data with arguments from scan screen
  void _initializeData() {
    // Set default time to current time in 12-hour format
    final now = DateTime.now();
    final formattedTime = _formatTime(TimeOfDay.fromDateTime(now));
    timeController.text = formattedTime;

    // Get image path from arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['imagePath'] != null) {
      _scannedImage.value = File(arguments['imagePath']);
      debugPrint('Loaded scanned image: ${arguments['imagePath']}');
    }

    // Set default meal name
    mealNameController.text = 'Grilled Chicken Salad';

    // Set default nutrition values
    caloriesController.text = '250';
    proteinController.text = '25';
    carbsController.text = '15';
    fatsController.text = '12';
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  // Select meal type
  void selectMealType(String mealType) {
    _selectedMealType.value = mealType;
    debugPrint('Selected meal type: $mealType');
  }

  // Navigation methods
  void onBackPressed() {
    Get.back();
    debugPrint('Back button pressed from meal form');
  }

  // Time picker functionality
  void onTimeFieldTapped() {
    _showTimePicker();
  }

  void onTimeIconTapped() {
    _showTimePicker();
  }

  // Format time to 12-hour format
  String _formatTime(TimeOfDay time) {
    final hour = time.hour == 0
        ? 12
        : time.hour > 12
        ? time.hour - 12
        : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Show time picker
  void _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      timeController.text = _formatTime(picked);
      debugPrint('Time selected: ${timeController.text}');
    }
  }

  // Retake photo functionality
  void onRetakePhotoPressed() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        _scannedImage.value = File(image.path);
        debugPrint('Photo retaken: ${image.path}');
      }
    } catch (e) {
      debugPrint('Error retaking photo: $e');
      Get.snackbar(
        'Camera Error',
        'Failed to retake photo. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  // Save meal functionality
  void onSaveMealPressed() async {
    // Validate required fields
    if (mealNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a meal name.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    if (_scannedImage.value == null) {
      Get.snackbar(
        'Validation Error',
        'Image is required. Please scan or take a photo of your meal.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    try {
      _setLoading(true);

      // Create meal data
      final mealData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _selectedMealType.value,
        'subtitle': mealNameController.text.trim(),
        'time': timeController.text.trim().isNotEmpty
            ? timeController.text.trim()
            : _formatTime(TimeOfDay.now()),
        'color': _getMealTypeColor(_selectedMealType.value),
        'checked': false,
        'icon': _getMealTypeIcon(_selectedMealType.value),
        'calories': caloriesController.text.trim().isNotEmpty
            ? caloriesController.text.trim()
            : '0',
        'protein': proteinController.text.trim().isNotEmpty
            ? proteinController.text.trim()
            : '0',
        'carbs': carbsController.text.trim().isNotEmpty
            ? carbsController.text.trim()
            : '0',
        'fats': fatsController.text.trim().isNotEmpty
            ? fatsController.text.trim()
            : '0',
        'notes': notesController.text.trim(),
        'imagePath': _scannedImage.value?.path,
        'dateAdded': DateTime.now().toIso8601String(),
      };

      // Add to home controller's food diary
      final homeController = Get.find<HomeController>();
      homeController.addMeal(mealData);

      debugPrint('Scanned meal added successfully: $mealData');

      // Clear all text fields after successful addition
      _clearAllFields();

      // Reset loading state
      _setLoading(false);

      // Show modern success dialog
      showSuccessDialog(
        title: 'Meal Added!',
        message:
            'Your scanned meal has been added to your food diary successfully.',
        animationPath: 'assets/animations/welcomeAnimation.gif',
        confirmText: 'Go to Home',
        onConfirm: () {
          // Navigate back to home screen
          Get.offAllNamed('/bottomNavigationScreen');
        },
      );
    } catch (e) {
      _setLoading(false);
      debugPrint('Error adding scanned meal: $e');
      Get.snackbar(
        'Error',
        'Failed to add meal. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  // Get meal type color
  int _getMealTypeColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 0xFF34C759;
      case 'lunch':
        return 0xFFD46434;
      case 'snack':
        return 0xFF6F3FC3;
      case 'dinner':
        return 0xFF4A7BFF;
      default:
        return 0xFF34C759;
    }
  }

  // Get meal type icon
  String _getMealTypeIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'assets/icons/breakfast.png';
      case 'lunch':
        return 'assets/icons/lunch.png';
      case 'snack':
        return 'assets/icons/breakfast.png'; // Using breakfast icon for snack
      case 'dinner':
        return 'assets/icons/dinner.png';
      default:
        return 'assets/icons/breakfast.png';
    }
  }

  // Clear all form fields
  void _clearAllFields() {
    mealNameController.clear();
    notesController.clear();
    caloriesController.clear();
    proteinController.clear();
    carbsController.clear();
    fatsController.clear();
    _scannedImage.value = null;
  }

  // Show error dialog helper
  void showErrorDialog({
    required String title,
    required String message,
    required String confirmText,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(confirmText)),
        ],
      ),
    );
  }
}
