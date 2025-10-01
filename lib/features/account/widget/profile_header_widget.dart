import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/account/controller/profile_setup_controller.dart';
import 'package:surajashray/routes/app_routes.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key, required this.controller});

  final ProfileSetupController controller;

  @override
  Widget build(BuildContext context) {
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
                  Icons.arrow_back_ios,
                  size: 24.w,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.offAllNamed(AppRoute.getBottomNavigationScreen());
              },
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
          'profile_personalize_experience'.tr,
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
          'profile_personalize_subtitle'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.grey,
            lineHeight: 22.sp,
          ),
          textAlign: TextAlign.center,
        ),
        24.h.verticalSpace,
        Center(
          child: Container(
            width: 290.w,
            height: 210.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'profile_add_photo_title'.tr,
                    style: getTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  16.h.verticalSpace,
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: Color(0xFFE4EBFF), // Outer circle color
                          shape: BoxShape.circle,
                        ),
                      ),

                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: Color(0xFFC7D6FF), // Inner circle color
                          shape: BoxShape.circle,
                        ),
                        child: Obx(() {
                          final image = controller.selectedImage.value;
                          if (image != null) {
                            return ClipOval(
                              child: Image.file(
                                image,
                                width: 80.w,
                                height: 80.w,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return Center(
                              child: SvgPicture.asset(
                                IconPath.cameraIcon,
                                color: AppColors.primary,
                                width: 40.w,
                                height: 40.w,
                              ),
                            );
                          }
                        }),
                      ),

                      // Positioned Plus Button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        // child: Container(
                        //   width: 24.w,
                        //   height: 24.w,
                        //   decoration: BoxDecoration(
                        //     color: AppColors.primary,
                        //     shape: BoxShape.circle,
                        //     border: Border.all(color: Colors.white, width: 2.w),
                        //   ),
                        //   child: Icon(
                        //     Icons.add,
                        //     color: Colors.white,
                        //     size: 16.sp,
                        //   ),
                        // ),
                        child: GestureDetector(
                          onTap: () {
                            _showImageSourceBottomSheet(context);
                          },
                          child: Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.w,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  8.h.verticalSpace,
                  Text(
                    'profile_add_photo_optional'.tr,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  4.h.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('take_photo'.tr),
              onTap: () async {
                Navigator.pop(context);
                await controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('choose_from_gallery'.tr),
              onTap: () async {
                Navigator.pop(context);
                await controller.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
