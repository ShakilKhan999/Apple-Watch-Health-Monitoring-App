import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/account/controller/contact_support_controller.dart';
import 'package:surajashray/features/account/widget/faq_list_widget.dart';

import '../../../core/utils/constants/icon_path.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        'contact_support_title'.tr,
                        style: getTextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                    20.verticalSpace,

                    _buildSendEmailSection(),
                    32.h.verticalSpace,

                    _buildFaqSection(),
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

  Widget _buildSendEmailSection() {
    ContactSupportController controller = Get.put(ContactSupportController());
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      color: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.transparent),
      ),

      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1st Row: Icon and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center vertically
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Color(0xFFC7D6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      IconPath.email,
                      width: 20.sp,
                      height: 20.sp,
                    ),
                  ),
                ),
                10.w.horizontalSpace, // Spacing between the icon and the text
                Expanded(
                  child: Text(
                    'email_support_title'.tr,
                    style: getTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),

                Text(
                  'response_time_24h'.tr,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.end, // Align to the end
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 55.0),
              child: Text(
                'detailed_assistance'.tr,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.green,
                ),
              ),
            ),

            Row(
              children: [
                SizedBox(width: 55.w), // match left padding
                Expanded(
                  child: Text(
                    'send_detailed_message'.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),

            15.h.verticalSpace,

            CustomFilledButton(
              text: 'send_email_button'.tr,
              onPressed: controller.contactSupport,
              padding: EdgeInsetsGeometry.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    final controller = ContactSupportController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // You can add a title or any other widget above the FAQ list
        Text(
          'faq_title'.tr,
          style: getTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        10.h.verticalSpace,
        Text(
          'faq_subtitle'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.grey,
          ),
        ),

        10.h.verticalSpace,

        FAQListWidget(controller: controller),
      ],
    );
  }
}
