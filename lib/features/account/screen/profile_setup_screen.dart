import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/account/controller/profile_setup_controller.dart';
import 'package:surajashray/features/account/screen/health_goal_screen.dart';
import 'package:surajashray/features/account/widget/bottom_section_widget.dart';
import 'package:surajashray/features/account/widget/profile_header_widget.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileSetupController controller = Get.put(ProfileSetupController());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeaderWidget(controller: controller),
              32.h.verticalSpace,
              _buildBasicInfoSection(controller),
              32.h.verticalSpace,
              _buildPhysicalMeasureSection(controller),
              32.h.verticalSpace,
              Obx(
                () => BottomSectionWidget(
                  currentIndex: controller.currentPageIndex.value,
                  totalSteps: 4,
                  nextText: 'next'.tr,
                  onNext: () {
                    debugPrint('Navigating...');
                    // Get.offAllNamed(AppRoute.getHealthGoalScreen());
                    Get.to(() => HealthGoalScreen());
                  },
                ),
              ),

              32.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(ProfileSetupController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'basic_information'.tr,
          style: getTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          textAlign: TextAlign.start,
        ),
        16.h.verticalSpace,
        Text(
          'full_name_label'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          textAlign: TextAlign.start,
        ),
        8.h.verticalSpace,
        // Full Name
        _buildTextField(
          controller: controller.fullNameController,
          hint: 'enter_full_name_hint'.tr,
          onChanged: controller.updateFullName,
        ),

        16.h.verticalSpace,

        Text(
          'date_of_birth_label'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          textAlign: TextAlign.start,
        ),
        8.h.verticalSpace,
        // Date of Birth
        // Date of Birth
        TextFormField(
          controller: controller.dobController,
          readOnly: false,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary, // Ensure the text color is set
          ),
          decoration: InputDecoration(
            hintText: 'date_format_hint'.tr,
            hintStyle: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
            fillColor: Colors.white,
            filled: true,
            suffixIcon: GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary, // Header background color
                          onPrimary: Colors.white, // Header text color
                          onSurface: Colors.black, // Body text color
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                AppColors.primary, // Button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  final formattedDate =
                      "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                  controller.dobController.text = formattedDate;
                  controller.updateDOB(formattedDate);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: SvgPicture.asset(
                  IconPath.calander,
                  width: 20.w,
                  height: 20.h,
                ),
              ),
            ),
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
        ),

        16.h.verticalSpace,
        // Gender
        Text(
          'gender_label'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          textAlign: TextAlign.start,
        ),

        8.h.verticalSpace,
        Obx(
          () => Row(
            children: [
              _buildGenderOption(
                controller,
                iconPath: IconPath.male,
                label: 'male'.tr,
                isSelected: controller.profileSetupModel.value.gender == 'Male',
              ),
              16.w.horizontalSpace,
              _buildGenderOption(
                controller,
                iconPath: IconPath.female,
                label: 'female'.tr,
                isSelected:
                    controller.profileSetupModel.value.gender == 'Female',
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Physical Measurements section with height and weight.
  Widget _buildPhysicalMeasureSection(ProfileSetupController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'physical_measurements'.tr,
          style: getTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          textAlign: TextAlign.start,
        ),
        8.h.verticalSpace,
        // Height
        Text(
          'height_label'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          textAlign: TextAlign.start,
        ),

        8.h.verticalSpace,
        Obx(
          () => controller.profileSetupModel.value.isHeightInCm
              ? _buildUnitTextField(
                  controller: controller.heightCmController,
                  unit: 'unit_cm'.tr,
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildUnitTextField(
                        controller: controller.heightFtController,
                        unit: 'unit_ft'.tr,
                      ),
                    ),
                    16.w.horizontalSpace,
                    Expanded(
                      child: _buildUnitTextField(
                        controller: controller.heightInController,
                        unit: 'unit_in'.tr,
                      ),
                    ),
                  ],
                ),
        ),
        12.h.verticalSpace,
        Obx(
          () => _buildSwitchButton(
            onTap: () => controller.toggleHeightUnit(),
            label: controller.profileSetupModel.value.isHeightInCm
                ? 'switch_to_ft_in'.tr
                : 'switch_to_cm'.tr,
          ),
        ),

        24.h.verticalSpace,

        // Weight
        Text(
          'weight_label'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          textAlign: TextAlign.start,
        ),
        8.h.verticalSpace,
        Obx(
          () => controller.profileSetupModel.value.isWeightInKg
              ? _buildUnitTextField(
                  controller: controller.weightKgController,
                  unit: 'unit_kg'.tr,
                )
              : _buildUnitTextField(
                  controller: controller.weightLbsController,
                  unit: 'unit_lbs'.tr,
                ),
        ),
        12.h.verticalSpace,
        Obx(
          () => _buildSwitchButton(
            onTap: () => controller.toggleWeightUnit(),
            label: controller.profileSetupModel.value.isWeightInKg
                ? 'switch_to_lbs'.tr
                : 'switch_to_kg'.tr,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    Widget? suffixIcon,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: getTextStyle(
        // Set the text color for the entered text
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black, // Set text color here (adjust as per design)
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.grey, // Set hint text color here
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
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
  }

  Widget _buildUnitTextField({
    required TextEditingController controller,
    required String unit,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: getTextStyle(
        // Set the text color for the entered text
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black, // Set text color here (adjust as per design)
      ),
      decoration: InputDecoration(
        suffixText: unit,
        suffixStyle: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black, // Set the color for suffixText (unit)
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
  }

  Widget _buildGenderOption(
    ProfileSetupController controller, {
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectGender(label),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Radio icon
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                8.w.horizontalSpace,

                // Gender icon (optional)
                // SvgPicture.asset(IconPath.male),
                SvgPicture.asset(iconPath),

                8.w.horizontalSpace,

                // Label
                Text(
                  label,
                  style: getTextStyle(
                    // color: isSelected
                    //     ? AppColors.primary
                    //     : AppColors.textPrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchButton({
    required VoidCallback onTap,
    required String label,
  }) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: getTextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
              8.w.horizontalSpace,
              // Icon(Icons.sync, color: AppColors.primary, size: 16.w),
              SvgPicture.asset(IconPath.switchIcon),
            ],
          ),
        ),
      ),
    );
  }
}
