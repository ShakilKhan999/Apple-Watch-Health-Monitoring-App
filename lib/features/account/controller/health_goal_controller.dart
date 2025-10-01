import 'package:surajashray/core/models/customize_card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';

class HealthGoalController extends GetxController {
  final RxList<CustomCardModel> cards = <CustomCardModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCards();
  }

  /// Toggles the selection state of a card at a given index.
  void toggleCardSelection(int index) {
    // Ensure the index is valid.
    if (index >= 0 && index < cards.length) {
      final card = cards[index];
      // Update the card at the specific index with a new instance
      // where 'isSelected' is flipped. This triggers the reactive update.
      cards[index] = card.copyWith(isSelected: !card.isSelected);
    }
  }

  /// Populates the list with the initial health goal cards.
  void _initializeCards() {
    cards.assignAll([
      CustomCardModel(
        title: 'Loss Weight',
        subtitle: 'Achieve a healthier weight through balanced nutrition',
        leftIconPath: IconPath.weightLoss,
        rightIconPath: IconPath.right,
        backgroundColor: const Color(0xFFF5F5F7),
        borderColor: const Color(0xFFBFD1FF),
        iconBackgroundColor: const Color(0xFFC7D6FF),
      ),
      CustomCardModel(
        title: 'Build Muscle',
        subtitle: 'Keep your current fitness and wellness level',
        leftIconPath: IconPath.muscle,
        rightIconPath: IconPath.right,
        backgroundColor: const Color(0xFFEFF9F1),
        borderColor: const Color(0xFF95C7A2),
        iconBackgroundColor: const Color(0xFFEFF9F1),
      ),
      CustomCardModel(
        title: 'Maintain Health',
        subtitle: 'Keep your current fitness and wellness level',
        leftIconPath: IconPath.maintainHealth,
        rightIconPath: IconPath.right,
        backgroundColor: const Color(0xFFF5F5F7),
        borderColor: const Color(0xFF6F3FC3),
        iconBackgroundColor: const Color.fromARGB(255, 206, 191, 235),
      ),
      CustomCardModel(
        title: 'Improve Endurance',
        subtitle: 'Boost cardiovascular fitness and stamina',
        leftIconPath: IconPath.endurance,
        rightIconPath: IconPath.right,
        backgroundColor: const Color(0xFFFFF5F5),
        borderColor: const Color(0xFFFFC2BF),
        iconBackgroundColor: const Color(0xFFFFC2BF),
      ),
      CustomCardModel(
        title: 'Stress Management',
        subtitle: 'Focus on mental wellness and relaxation',
        leftIconPath: IconPath.lessStress,
        rightIconPath: IconPath.right,
        backgroundColor: const Color(0xFFFFF5F5),
        borderColor: const Color(0xFFFFC2BF),
        iconBackgroundColor: const Color(0xFFFFC2BF),
      ),
    ]);
  }
}
