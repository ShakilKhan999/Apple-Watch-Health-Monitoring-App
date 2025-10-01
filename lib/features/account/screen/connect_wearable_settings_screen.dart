import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/account/controller/connect_wearable_controller.dart';
import 'package:surajashray/features/account/widget/wearable_card_widget.dart';

class ConnectWearableSettingsScreen extends StatelessWidget {
  const ConnectWearableSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    10.h.verticalSpace,
                    _buildHeaderSection(),

                    Center(
                      child: Text(
                        'device_integration_settings'.tr,
                        style: getTextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                    20.verticalSpace,

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

                    20.h.verticalSpace,
                    _buildSyncSettingsCard(),
                    32.h.verticalSpace,

                    // _buildCardSection(),
                    // 32.h.verticalSpace,
                  ],
                ),
              ),
            ),
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

  Widget _buildSyncSettingsCard() {
    final controller = Get.find<ConnectWearableController>();

    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          color: Color(0xFFFFF9F2),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: Color(0xFFD46434), width: 0.5),
          ),

          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 1st Row: Icon and Title
                Row(
                  children: [
                    SvgPicture.asset(
                      IconPath.sync,
                      width: 24.sp,
                      height: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'sync_settings'.tr,
                      style: getTextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                /// 2nd Row: Subtitle
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    'sync_settings_description'.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                /// 3rd Row: Toggle Label + Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          'auto_sync_15_minutes'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ),
                    Switch(
                      value: controller.isAutoSyncEnabled.value,
                      onChanged: controller.toggleAutoSync,
                      activeColor: Color(0xFFE8F5E9),
                      activeTrackColor: Colors.green,
                      inactiveThumbColor: Color(0xFFECEFF1),
                      inactiveTrackColor: Color(0xFFB0BEC5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
