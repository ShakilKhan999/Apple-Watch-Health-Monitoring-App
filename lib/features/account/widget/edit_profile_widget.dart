import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/account/controller/profile_setup_controller.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({super.key, required this.controller});

  final ProfileSetupController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        // 16.h.verticalSpace,
        Center(
          child: Container(
            width: 290.w,
            height: 150.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.transparent),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 10.h.verticalSpace,
                  Stack(
                    alignment: Alignment.center,
                    children: [
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
                              child: CircleAvatar(
                                radius: 50.r,
                                child: SvgPicture.asset(IconPath.user),
                              ),
                              // child: SvgPicture.asset(
                              //   IconPath.cameraIcon,
                              //   color: AppColors.primary,
                              //   width: 40.w,
                              //   height: 40.w,
                              // ),
                            );
                          }
                        }),
                      ),

                      // Positioned Plus Button
                      Positioned(
                        bottom: 0,
                        right: 0,
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

                  // 8.h.verticalSpace,
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
              title: Text(
                'choose_from_gallery'.tr.isNotEmpty
                    ? 'choose_from_gallery'.tr
                    : 'Choose from Gallery',
              ),
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
