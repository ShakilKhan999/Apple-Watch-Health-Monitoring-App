import 'package:get/get.dart';
import 'package:surajashray/core/models/wearable_card_model.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';

class ConnectWearableController extends GetxController {
  final RxList<WearableCardModel> cards = <WearableCardModel>[].obs;
  var isAutoSyncEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCards();
  }

  void toggleConnection(int index) {
    if (index >= 0 && index < cards.length) {
      final card = cards[index];
      cards[index] = card.copyWith(isConnected: !card.isConnected);
    }
  }

  void toggleAutoSync(bool value) {
    isAutoSyncEnabled.value = value;
  }

  void _initializeCards() {
    cards.assignAll([
      WearableCardModel(
        title: "Apple Watch",
        subtitle: "Apple Watch",
        iconPath: IconPath.apple,
      ),
      WearableCardModel(
        title: "Google Fit",
        subtitle: "Android & Wear OS",
        iconPath: IconPath.google,
      ),
      WearableCardModel(
        title: "Fitbit",
        subtitle: "All Fitbit devices",
        iconPath: IconPath.fitbit,
      ),
      WearableCardModel(
        title: "Strava",
        subtitle: "Running & cycling",
        iconPath: IconPath.strava,
      ),
    ]);
  }
}
