import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/account/controller/language_region_controller.dart';

class LanguageRegionScreen extends StatelessWidget {
  LanguageRegionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LanguageRegionController());

    return GetBuilder<LanguageRegionController>(
      builder: (controller) => CommonBackgroundScaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(controller),
                // _buildTitleSection(controller),
                Center(
                  child: Text(
                    'language_and_region'.tr,
                    style: getTextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                32.verticalSpace,
                _buildLanguageSection(controller),
                40.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header section with back button
  Widget _buildHeaderSection(LanguageRegionController controller) {
    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 24.h),
      child: GestureDetector(
        onTap: controller.onBackPressed,
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20.w,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Title section with globe icon and title
  // Widget _buildTitleSection(LanguageRegionController controller) {
  //   return Row(
  //     children: [
  //       // Globe icon (from the Figma design)
  //       // Container(
  //       //   width: 24.w,
  //       //   height: 24.h,
  //       //   child: SvgPicture.asset(
  //       //     IconPath.region,
  //       //     width: 24.w,
  //       //     height: 24.h,
  //       //     colorFilter: ColorFilter.mode(
  //       //       AppColors.textPrimary,
  //       //       BlendMode.srcIn,
  //       //     ),
  //       //   ),
  //       // ),

  //       // 8.horizontalSpace,

  //       // Title
  //       Text(
  //         'language_and_region'.tr,
  //         style: getTextStyle(
  //           fontSize: 22.sp, // H4 from Figma
  //           fontWeight: FontWeight.w700, // Bold
  //           color: AppColors.textPrimary,
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //     ],
  //   );
  // }

  /// Language selection section
  Widget _buildLanguageSection(LanguageRegionController controller) {
    return Column(children: [_buildLanguageCard(controller)]);
  }

  /// Language selection card
  Widget _buildLanguageCard(LanguageRegionController controller) {
    return GestureDetector(
      onTap: controller.onLanguageSelectionTapped,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F8), // Input background from design
          border: Border.all(
            color: Color(0xFFE8E8E8), // Input border from design
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Language icon with circular background
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: Color(0xFFC7D6FF), // Foundation Blue Light Active
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                IconPath.region,
                width: 16.w,
                height: 16.h,
                colorFilter: ColorFilter.mode(
                  Color(0xFF4A7BFF), // Primary color
                  BlendMode.srcIn,
                ),
              ),
            ),

            12.horizontalSpace,

            // Language text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Language title
                  Text(
                    'app_language'.tr,
                    style: getTextStyle(
                      fontSize: 18.sp, // Medium size
                      fontWeight: FontWeight.w500, // Medium
                      color: AppColors.textPrimary,
                    ),
                  ),

                  8.verticalSpace,

                  // Currently: Language text
                  Obx(
                    () => Text(
                      '${'currently'.tr}: ${controller.selectedLanguage.value}',
                      style: getTextStyle(
                        fontSize: 16.sp, // Body/B1 from Figma
                        fontWeight: FontWeight.w400, // Regular
                        color: AppColors.textSecondary,
                        lineHeight: 20.8, // 1.3 line height
                      ),
                    ),
                  ),
                ],
              ),
            ),

            12.horizontalSpace,

            // Language code and arrow
            Row(
              children: [
                // Language code
                Obx(
                  () => Text(
                    controller.selectedLanguageCode.value,
                    style: getTextStyle(
                      fontSize: 16.sp, // Body/B1 from Figma
                      fontWeight: FontWeight.w400, // Regular
                      color: AppColors.textSecondary,
                      lineHeight: 20.8, // 1.3 line height
                    ),
                  ),
                ),

                4.horizontalSpace,

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.w,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
