import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

import '../../../core/utils/constants/icon_path.dart';

class AccountDeactivateScreen extends StatelessWidget {
  const AccountDeactivateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final HealthGoalController healthGoalController = Get.put(
    //   HealthGoalController(),
    // );
    // final ProfileSetupController profileSetupController =
    //     Get.find<ProfileSetupController>();

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
                        'account_deactivation'.tr,
                        style: getTextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                    20.verticalSpace,

                    _buildDeleteAccountSection(),
                    32.h.verticalSpace,
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

  Widget _buildDeleteAccountSection() {
    return Card(
      color: const Color(0xFFFFEDED),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: const Color(0xFFFF3B30), width: 0.5),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Circular Icon Container
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE5E5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  IconPath.delete,
                  width: 20.sp,
                  height: 20.sp,
                  color: const Color.fromARGB(255, 244, 67, 54),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Text
            Expanded(
              child: Text(
                'delete_account'.tr,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            // Delete Button
            TextButton(
              onPressed: () {
                // Confirm and delete logic here
                Get.defaultDialog(
                  title: "are_you_sure".tr,
                  titleStyle: getTextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 22, 7, 61),
                  ),
                  middleText: "delete_account_confirmation".tr,
                  middleTextStyle: getTextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  backgroundColor: Colors.white, // Dialog background
                  // Confirm (Delete) Button

                  // Custom buttons styling using `actions` (overrides default buttons if needed)
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                        print("Account deleted");
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 244, 67, 54),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 10.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        "delete".tr,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    // Cancel Button
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.grey,
                        side: BorderSide(color: AppColors.grey),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 10.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        "cancel".tr,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),

                    // Delete Button
                  ],
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text('delete'.tr, style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      ),
    );
  }
}
