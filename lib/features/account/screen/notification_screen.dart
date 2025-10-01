import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/account/controller/notification_controller.dart';
import 'package:surajashray/features/account/controller/profile_setup_controller.dart';
import 'package:surajashray/features/account/widget/bottom_section_widget.dart';
import 'package:surajashray/features/account/widget/notification_card_widget.dart';
import 'package:surajashray/routes/app_routes.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final HealthGoalController healthGoalController = Get.put(
    //   HealthGoalController(),
    // );
    // final ProfileSetupController profileSetupController =
    //     Get.find<ProfileSetupController>();
    final NotificationController notificationController = Get.put(
      NotificationController(),
    );
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
                    25.h.verticalSpace,

                    Obx(
                      () => Column(
                        children: List.generate(
                          notificationController.cards.length * 2 - 1,
                          (index) {
                            if (index.isEven) {
                              final card =
                                  notificationController.cards[index ~/ 2];
                              return NotificationCardWidget(
                                cardModel: card,
                                onToggle: () => notificationController
                                    .toggleNotification(index ~/ 2),
                              );
                            } else {
                              return Divider(
                                color: AppColors.grey,
                                thickness: 0.6,
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    _buildDontDisturbSection(),
                    32.h.verticalSpace,
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
                    // Setup complete, navigate to main app (bottom navigation with home screen)
                    // Get.offAllNamed(AppRoute.getBottomNavigationScreen());
                    Get.offAllNamed(AppRoute.getBottomNavigationScreen());
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
                // Skip setup and go to main app
                      Get.offAllNamed(AppRoute.getBottomNavigationScreen());

                //   Get.offAllNamed(AppRoute.getConnectWearableScreen());
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
          'notification_title'.tr,
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
          'notification_subtitle'.tr,
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

  Widget _buildDontDisturbSection() {
    NotificationController controller = Get.put(NotificationController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.grey, // Replace with AppColors.grey if available
          thickness: 0.6,
        ),

        // Row 1: "Don't disturb me" and Switch
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'dont_disturb_me'.tr,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Switch(
                value: controller.isDoNotDisturbOn.value,
                onChanged: (val) => controller.toggleDoNotDisturb(val),
                activeColor: Color(0xFFE8F5E9),
                activeTrackColor: Colors.green,
                inactiveThumbColor: Color(
                  0xFFECEFF1,
                ), // Change this to your preferred inactive thumb color
                inactiveTrackColor: Color(0xFFB0BEC5),
              ),
            ],
          ),
        ),

        8.h.verticalSpace,

        // Row 2: "From", "To"
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'from'.tr,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
            120.w.horizontalSpace,
            Text(
              'to'.tr,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
          ],
        ),

        8.h.verticalSpace,

        Row(
          children: [
            // From TextField
            Expanded(
              child: Builder(
                builder: (context) {
                  return TextField(
                    controller: controller.fromTimeController,
                    readOnly: true,
                    onTap: () async {
                      final TimeOfDay? picked = await controller
                          .showCustomTimePicker(context);
                      if (picked != null) {
                        final formatted = picked.format(context);
                        controller.fromTimeController.text = formatted;
                        controller.updateFromTime(formatted);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'time_format_hint'.tr,
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          final TimeOfDay? picked = await controller
                              .showCustomTimePicker(context);
                          if (picked != null) {
                            final formatted = picked.format(context);
                            controller.fromTimeController.text = formatted;
                            controller.updateFromTime(formatted);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            IconPath.clock,
                            width: 20.w,
                            height: 20.h,
                            // optional: color of the icon
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),

            14.h.horizontalSpace,
            // To TextField
            Expanded(
              child: Builder(
                builder: (context) {
                  return TextField(
                    controller: controller.toTimeController,
                    readOnly: true,
                    onTap: () async {
                      final TimeOfDay? picked = await controller
                          .showCustomTimePicker(context);
                      if (picked != null) {
                        final formatted = picked.format(context);
                        controller.toTimeController.text = formatted;
                        controller.updateFromTime(formatted);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'time_format_hint'.tr,
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          final TimeOfDay? picked = await controller
                              .showCustomTimePicker(context);
                          if (picked != null) {
                            final formatted = picked.format(context);
                            controller.toTimeController.text = formatted;
                            controller.updateFromTime(formatted);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            IconPath.clock,
                            width: 20.w,
                            height: 20.h,
                            // optional: color of the icon
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
