import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/customize_card_widget.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/account/controller/health_goal_controller.dart';
import 'package:surajashray/features/account/controller/profile_setup_controller.dart';
import 'package:surajashray/features/account/screen/connect_wearable_screen.dart';
import 'package:surajashray/features/account/widget/bottom_section_widget.dart';
import 'package:surajashray/routes/app_routes.dart';

class HealthGoalScreen extends StatelessWidget {
  const HealthGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HealthGoalController healthGoalController = Get.put(
      HealthGoalController(),
    );
    // final ProfileSetupController profileSetupController =
    //     Get.find<ProfileSetupController>();
    final ProfileSetupController profileSetupController = Get.put(
      ProfileSetupController(),
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
                        children: List.generate(
                          healthGoalController.cards.length,
                          (index) {
                            final cardModel = healthGoalController.cards[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: CustomCardWidget(
                                cardModel: cardModel,
                                // Call the controller's method on tap
                                onTap: () => healthGoalController
                                    .toggleCardSelection(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
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
                  nextText: 'next_button'.tr,
                  onNext: () {
                    // Optional: You can access the selected goals here before navigating
                    // final selectedGoals = healthGoalController.cards.where((c) => c.isSelected).toList();
                    // print('Selected goals: ${selectedGoals.map((g) => g.title).toList()}');
                    // Get.offAllNamed(AppRoute.getConnectWearableScreen());
                    Get.to(() => ConnectWearableScreen());
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
                Get.offAllNamed(AppRoute.getBottomNavigationScreen());
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
                'skip_button'.tr,
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
          'health_goals_title'.tr,
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
          'health_goals_subtitle'.tr,
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
