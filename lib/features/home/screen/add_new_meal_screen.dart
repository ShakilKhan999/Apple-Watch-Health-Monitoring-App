import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/custom_text_field.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/home/controllers/add_new_meal_controller.dart';

class AddNewMealScreen extends StatelessWidget {
  const AddNewMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNewMealController controller = Get.put(AddNewMealController());

    return CommonBackgroundScaffold(
      useSafeArea: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(controller),
            _buildContent(controller),
            SizedBox(height: 100.h), // Extra space for bottom navigation
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AddNewMealController controller) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            14.verticalSpace,

            // Header with back button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: controller.onBackPressed,
                  child: Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18.w,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),

            24.verticalSpace,

            // Title
            Text(
              'new_meal'.tr,
              style: getTextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            32.verticalSpace,

            // Action buttons
            _buildActionButtons(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(AddNewMealController controller) {
    return Obx(() {
      // If image is selected, show preview instead of action buttons
      if (controller.showImagePreview && controller.selectedImage != null) {
        return _buildImagePreview(controller);
      }

      // Show normal action buttons
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            title: 'take_a_photo'.tr,
            icon: Icons.camera_alt_outlined,
            onTap: controller.onTakePhotoPressed,
          ),

          32.horizontalSpace,

          _buildActionButton(
            title: 'scan_a_barcode'.tr,
            icon: Icons.qr_code_scanner_outlined,
            backgroundColor: AppColors.primary,
            iconColor: Colors.white,
            onTap: controller.onScanBarcodePressed,
          ),
        ],
      );
    });
  }

  Widget _buildImagePreview(AddNewMealController controller) {
    return Column(
      children: [
        // Image preview
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(controller.selectedImage!, fit: BoxFit.cover),
          ),
        ),

        16.verticalSpace,

        // Action buttons for image
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImageActionButton(
              title: 'retake'.tr,
              icon: Icons.camera_alt_outlined,
              onTap: controller.retakePhoto,
              backgroundColor: Colors.grey.shade100,
              textColor: AppColors.textPrimary,
            ),

            16.horizontalSpace,

            _buildImageActionButton(
              title: 'remove'.tr,
              icon: Icons.delete_outline,
              onTap: controller.removeImage,
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              textColor: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                (backgroundColor != null &&
                    backgroundColor != Colors.grey.shade100)
                ? Colors.transparent
                : AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.w, color: textColor ?? AppColors.primary),
            8.horizontalSpace,
            Text(
              title,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: textColor ?? AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: backgroundColor ?? const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(32.r),
              border: backgroundColor == null
                  ? Border.all(color: const Color(0xFFE8E8E8), width: 1.w)
                  : null,
            ),
            child: Icon(
              icon,
              size: 24.w,
              color: iconColor ?? AppColors.textPrimary,
            ),
          ),

          12.verticalSpace,

          SizedBox(
            width: 107.w,
            child: Text(
              title,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AddNewMealController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          32.verticalSpace,

          _buildMealNameField(controller),
          24.verticalSpace,

          _buildMealTypeSection(controller),
          24.verticalSpace,

          _buildNotesField(controller),
          24.verticalSpace,

          _buildNutritionSection(controller),
          24.verticalSpace,

          _buildTimeField(controller),
          40.verticalSpace,

          _buildAddMealButton(controller),
        ],
      ),
    );
  }

  Widget _buildMealNameField(AddNewMealController controller) {
    return CustomTextField(
      label: 'meal_name'.tr,
      controller: controller.mealNameController,
      hintText: 'enter_meal_name'.tr,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildMealTypeSection(AddNewMealController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'meal_type'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),

        12.verticalSpace,

        Obx(
          () => Row(
            children: controller.mealTypes.map((mealType) {
              final isSelected = controller.selectedMealType == mealType;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: mealType != controller.mealTypes.last ? 12.w : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => controller.selectMealType(mealType),
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE1F7E6)
                            : const Color(0xFFF5F5F7),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          mealType,
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: isSelected
                                ? AppColors.secondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField(AddNewMealController controller) {
    return CustomTextField(
      label: 'notes_optional'.tr,
      controller: controller.notesController,
      hintText: 'add_notes_about_meal'.tr,
      keyboardType: TextInputType.multiline,
      maxLines: 4,
    );
  }

  Widget _buildNutritionSection(AddNewMealController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'nutrition_info'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),

        12.verticalSpace,

        // First row: Calories and Protein
        Row(
          children: [
            Expanded(
              child: _buildNutritionField(
                label: 'calories'.tr,
                controller: controller.caloriesController,
              ),
            ),

            12.horizontalSpace,

            Expanded(
              child: _buildNutritionField(
                label: 'protein'.tr,
                controller: controller.proteinController,
              ),
            ),
          ],
        ),

        12.verticalSpace,

        // Second row: Carbs and Fats
        Row(
          children: [
            Expanded(
              child: _buildNutritionField(
                label: 'carbs'.tr,
                controller: controller.carbsController,
              ),
            ),

            12.horizontalSpace,

            Expanded(
              child: _buildNutritionField(
                label: 'fats'.tr,
                controller: controller.fatsController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionField({
    required String label,
    required TextEditingController controller,
  }) {
    return CustomTextField(
      label: label,
      hintText: 'enter_nutrition_value'.tr.replaceAll('{label}', label),
      controller: controller,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildTimeField(AddNewMealController controller) {
    return GestureDetector(
      onTap: controller.onTimeFieldTapped,
      child: AbsorbPointer(
        child: CustomTextField(
          label: 'time'.tr,
          hintText: 'select_time'.tr,
          controller: controller.timeController,
          keyboardType: TextInputType.none,
          suffixIcon: Icon(
            Icons.access_time,
            size: 16.w,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildAddMealButton(AddNewMealController controller) {
    return Obx(
      () => CustomFilledButton(
        text: controller.isLoading ? 'adding_meal'.tr : 'add_meal'.tr,
        onPressed: controller.isLoading ? () {} : controller.onAddMealPressed,
        icon: controller.isLoading ? null : Icons.add,
        iconWidget: controller.isLoading
            ? SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : null,
        padding: EdgeInsetsGeometry.zero,
      ),
    );
  }
}
