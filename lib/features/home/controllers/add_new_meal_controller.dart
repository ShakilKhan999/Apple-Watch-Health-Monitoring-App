import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surajashray/core/common/widgets/success_dialog.dart';
import 'package:surajashray/features/home/controllers/home_controller.dart';

class AddNewMealController extends GetxController {
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
  final RxString _selectedMealType = 'Lunch'.obs;
  final Rx<File?> _selectedImage = Rx<File?>(null);
  final RxBool _showImagePreview = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get selectedMealType => _selectedMealType.value;
  File? get selectedImage => _selectedImage.value;
  bool get showImagePreview => _showImagePreview.value;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Meal type options
  final List<String> mealTypes = ['Lunch', 'Breakfast', 'Snack', 'Dinner'];

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    debugPrint('AddNewMealController initialized');
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
    debugPrint('AddNewMealController disposed');
  }

  // Initialize data
  void _initializeData() {
    // Set default time to current time in 12-hour format
    final now = DateTime.now();
    final formattedTime = _formatTime(TimeOfDay.fromDateTime(now));
    timeController.text = formattedTime;
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
    debugPrint('Back button pressed');
  }

  // Camera functionality
  void onTakePhotoPressed() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        _selectedImage.value = File(image.path);
        _showImagePreview.value = true;
        debugPrint('Photo captured: ${image.path}');
      }
    } catch (e) {
      showErrorDialog(
        title: 'Camera Error',
        message: 'Failed to capture photo. Please try again.',
        confirmText: 'OK',
      );
      debugPrint('Error capturing photo: $e');
    }
  }

  void onScanBarcodePressed() {
    debugPrint('Scan barcode pressed');

    showInfoDialog(
      title: 'Coming Soon',
      message: 'Barcode scanner will be available in the next update!',
      confirmText: 'OK',
    );
  }

  // Image preview actions
  void removeImage() {
    _selectedImage.value = null;
    _showImagePreview.value = false;
    debugPrint('Image removed');
  }

  void retakePhoto() {
    onTakePhotoPressed();
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

  // Get meal color based on type
  Color _getMealColor(String mealType) {
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

  // Add meal
  void onAddMealPressed() async {
    if (_validateForm()) {
      _setLoading(true);

      try {
        // Simulate API call delay
        await Future.delayed(const Duration(seconds: 2));

        // Create meal data
        final mealData = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': selectedMealType,
          'subtitle': mealNameController.text.trim(),
          'time': timeController.text,
          'color': _getMealColor(selectedMealType).value,
          'checked': false,
          'icon': _getMealIcon(selectedMealType),
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
          'imagePath': selectedImage?.path,
          'dateAdded': DateTime.now().toIso8601String(),
        };

        // Add to home controller's food diary
        final homeController = Get.find<HomeController>();
        homeController.addMeal(mealData);

        debugPrint('Meal added successfully: $mealData');

        // Clear all text fields after successful addition
        _clearAllFields();

        // Reset loading state
        _setLoading(false);

        // Show modern success dialog
        showSuccessDialog(
          title: 'Meal Added!',
          message: 'Your meal has been added to your food diary successfully.',
          animationPath: 'assets/animations/welcomeAnimation.gif',
          confirmText: 'Go to Home',
          onConfirm: () {
            // Navigate back to home screen
            Get.back();
          },
        );
      } catch (e) {
        // Show error dialog
        showErrorDialog(
          title: 'Error',
          message: 'Failed to add meal. Please try again.',
        );
        debugPrint('Error adding meal: $e');
      } finally {
        // Ensure loading is always reset in case of error
        if (isLoading) {
          _setLoading(false);
        }
      }
    }
  }

  // Form validation
  bool _validateForm() {
    if (mealNameController.text.trim().isEmpty) {
      showErrorDialog(
        title: 'Missing Information',
        message: 'Please enter a meal name',
        confirmText: 'OK',
      );
      return false;
    }

    if (timeController.text.trim().isEmpty) {
      showErrorDialog(
        title: 'Missing Information',
        message: 'Please select a time',
        confirmText: 'OK',
      );
      return false;
    }

    return true;
  }

  // Clear all form fields
  void _clearAllFields() {
    mealNameController.clear();
    notesController.clear();
    caloriesController.clear();
    proteinController.clear();
    carbsController.clear();
    fatsController.clear();
    timeController.clear();

    // Reset selections and images
    _selectedMealType.value = 'Breakfast';
    _selectedImage.value = null;
    _showImagePreview.value = false;

    debugPrint('All form fields cleared');
  }

  // Show time picker
  void _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A7BFF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF161618),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime = _formatTime(picked);
      timeController.text = formattedTime;
      debugPrint('Time selected: $formattedTime');
    }
  }
}
