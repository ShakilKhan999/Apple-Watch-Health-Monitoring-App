import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/account/controller/notification_controller.dart';
import 'package:surajashray/features/account/widget/notification_card_widget.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController = Get.put(
      NotificationController(),
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
                    10.h.verticalSpace,
                    _buildHeaderSection(),

                    Center(
                      child: Text(
                        'Notification Settings',
                        style: getTextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                    15.verticalSpace,

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
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 24.w,
              color: AppColors.textSecondary,
            ),
          ),
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
                "Don't disturb me",
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
          children: [
            Text(
              "From",
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
            120.w.horizontalSpace,
            Text(
              "To",
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
                    style: getTextStyle(
                      fontSize: 14.sp,
                      color:
                          Colors.black, // Ensure typed text is black or visible
                    ),
                    decoration: InputDecoration(
                      hintText: "HH:MM",
                      hintStyle: getTextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary, // Hint text color
                      ),
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
                            // Optional: color of the icon
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
                        controller.updateToTime(formatted);
                      }
                    },
                    style: getTextStyle(
                      fontSize: 14.sp,
                      color:
                          Colors.black, // Ensure typed text is black or visible
                    ),
                    decoration: InputDecoration(
                      hintText: "HH:MM",
                      hintStyle: getTextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary, // Hint text color
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          final TimeOfDay? picked = await controller
                              .showCustomTimePicker(context);
                          if (picked != null) {
                            final formatted = picked.format(context);
                            controller.toTimeController.text = formatted;
                            controller.updateToTime(formatted);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            IconPath.clock,
                            width: 20.w,
                            height: 20.h,
                            // Optional: color of the icon
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
