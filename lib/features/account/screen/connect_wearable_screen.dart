import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/account/controller/connect_wearable_controller.dart';
import 'package:surajashray/features/account/controller/profile_setup_controller.dart';
import 'package:surajashray/features/account/screen/notification_screen.dart';
import 'package:surajashray/features/account/widget/bottom_section_widget.dart';
import 'package:surajashray/features/account/widget/wearable_card_widget.dart';
import 'package:surajashray/routes/app_routes.dart';

class ConnectWearableScreen extends StatelessWidget {
  const ConnectWearableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final HealthGoalController healthGoalController = Get.put(
    //   HealthGoalController(),
    // );
    // final ProfileSetupController profileSetupController =
    //     Get.find<ProfileSetupController>();
    final ProfileSetupController profileSetupController = Get.put(
      ProfileSetupController(),
    );

    final ConnectWearableController controller = Get.put(
      ConnectWearableController(),
    );

    return CommonBackgroundScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    32.h.verticalSpace,

                    Obx(
                      () => Column(
                        children: List.generate(controller.cards.length, (
                          index,
                        ) {
                          final card = controller.cards[index];
                          return WearableCardWidget(
                            cardModel: card,
                            onToggle: () => controller.toggleConnection(index),
                          );
                        }),
                      ),
                    ),

                    // _buildCardSection(),
                    // 32.h.verticalSpace,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(
                () => BottomSectionWidget(
                  currentIndex: profileSetupController.currentPageIndex.value,
                  totalSteps: 4,
                  nextText: 'next'.tr,
                  onNext: () {
                    // Optional: You can access the selected goals here before navigating
                    // final selectedGoals = healthGoalController.cards.where((c) => c.isSelected).toList();
                    // print('Selected goals: ${selectedGoals.map((g) => g.title).toList()}');
                    // Get.offAllNamed(AppRoute.getNotificationScreen());
                    Get.to(() => NotificationScreen());
                  },
                ),
              ),
            ),
            32.h.verticalSpace,
          ],
        ),
      ),
    );
  }

  // This method is now self-contained and doesn't need the controller passed to it.
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.arrow_back,
                  size: 24.w,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Consider if this should clear selections or just skip
                Get.offAllNamed(AppRoute.getConnectWearableScreen());
              },
              // onPressed: () {
              //   healthGoalController.cards.assignAll(
              //     healthGoalController.cards
              //         .map((c) => c.copyWith(isSelected: false))
              //         .toList(),
              //   );
              //   Get.offAllNamed(AppRoute.getConnectWearableScreen());
              // },
              child: Text(
                'skip'.tr,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        16.h.verticalSpace,
        Text(
          "connect_wearables_title".tr,
          style: getTextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            lineHeight: 35.sp,
          ),
          textAlign: TextAlign.center,
        ),
        10.h.verticalSpace,
        Text(
          'connect_wearables_subtitle'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.grey,
            lineHeight: 22.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
