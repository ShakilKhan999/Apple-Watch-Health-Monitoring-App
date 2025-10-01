import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surajashray/core/models/profile_setup_model.dart';

class ProfileSetupController extends GetxController {
  final  profileSetupModel = ProfileSetupModel().obs;

  /// Text Controllers
  final fullNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final heightCmController = TextEditingController();
  final heightFtController = TextEditingController();
  final heightInController = TextEditingController();
  final weightKgController = TextEditingController();
  final weightLbsController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  final PageController pageController = PageController();

  /// Page Indicator
  final RxInt currentPageIndex = 0.obs;

  void nextPage() {
    if (currentPageIndex.value < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last page: maybe navigate to next screen
      // Get.toNamed(AppRoute.getHealthGoalScreen());
    }
  }

  @override
  void onInit() {
    super.onInit();
    _syncControllersWithModel();
  }

  void _syncControllersWithModel() {
    fullNameController.text = profileSetupModel.value.fullName;
    dobController.text = profileSetupModel.value.dob;
    heightCmController.text = profileSetupModel.value.heightCm;
    heightFtController.text = profileSetupModel.value.heightFt;
    heightInController.text = profileSetupModel.value.heightIn;
    weightKgController.text = profileSetupModel.value.weightKg;
    weightLbsController.text = profileSetupModel.value.weightLbs;
  }

  void updateFullName(String name) {
    profileSetupModel.update((m) {
      m!.fullName = name;
    });
  }

  void updateDOB(String dob) {
    profileSetupModel.update((m) {
      m!.dob = dob;
    });
  }

  void selectGender(String gender) {
    profileSetupModel.update((m) {
      m!.gender = gender;
    });
  }

  void toggleHeightUnit() {
    profileSetupModel.update((m) {
      m!.isHeightInCm = !m.isHeightInCm;
    });
  }

  void toggleWeightUnit() {
    profileSetupModel.update((m) {
      m!.isWeightInKg = !m.isWeightInKg;
    });
  }

  void updateHeight(String value, {required bool isCm, bool isFt = false}) {
    profileSetupModel.update((m) {
      if (isCm) {
        m!.heightCm = value;
      } else if (isFt) {
        m!.heightFt = value;
      } else {
        m!.heightIn = value;
      }
    });
  }

  void updateWeight(String value, {required bool isKg}) {
    profileSetupModel.update((m) {
      if (isKg) {
        m!.weightKg = value;
      } else {
        m!.weightLbs = value;
      }
    });
  }

  @override
  void onClose() {
    fullNameController.dispose();
    dobController.dispose();
    heightCmController.dispose();
    heightFtController.dispose();
    heightInController.dispose();
    weightKgController.dispose();
    weightLbsController.dispose();
    pageController.dispose();
    super.onClose();
  }

  
}
