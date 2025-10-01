import 'package:get/get.dart';
import 'package:surajashray/features/account/controller/profile_setup_controller.dart';
import 'package:surajashray/core/services/food_diary_service.dart';
import 'package:surajashray/core/controllers/global_language_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LogInController>(
    //       () => LogInController(),
    //   fenix: true,
    // );

    // Initialize Global Language Controller as singleton
    Get.put(GlobalLanguageController(), permanent: true);

    // Initialize Food Diary Service as singleton
    Get.put(FoodDiaryService(), permanent: true);

    Get.lazyPut(() => ProfileSetupController());
    // Get.to(() => HealthGoalScreen());
  }
}
