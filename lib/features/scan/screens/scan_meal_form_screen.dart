import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/custom_text_field.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/features/scan/controllers/scan_meal_form_controller.dart';

class ScanMealFormScreen extends StatelessWidget {
  const ScanMealFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScanMealFormController controller = Get.put(ScanMealFormController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(controller),

            // Title
            _buildTitle(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      // Image with camera icon
                      _buildImageSection(controller),

                      32.verticalSpace,

                      // Meal Name Field
                      _buildMealNameField(controller),

                      24.verticalSpace,

                      // Meal Type Selection
                      _buildMealTypeSelection(controller),

                      24.verticalSpace,

                      // Notes Field
                      _buildNotesField(controller),

                      32.verticalSpace,

                      // Nutrition Info
                      _buildNutritionInfo(controller),

                      40.verticalSpace,

                      // Save Button
                      _buildSaveButton(controller),

                      24.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ScanMealFormController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.onBackPressed,
            child: Container(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20.w,
                color: const Color(0xFF8E8E93),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          16.verticalSpace,
          Text(
            'scan_add_meal_plan'.tr,
            style: getTextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF161618),
              lineHeight: 35.sp,
            ),
            textAlign: TextAlign.center,
          ),
          32.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildImageSection(ScanMealFormController controller) {
    return Obx(() {
      final image = controller.scannedImage;

      return Container(
        width: double.infinity,
        height: 289.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.grey.shade200,
        ),
        child: Stack(
          children: [
            // Image
            if (image != null)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.grey.shade200,
                ),
                child: Icon(Icons.image, size: 64.w, color: Colors.grey),
              ),

            // Camera button overlay
            Positioned(
              bottom: 16.h,
              right: 16.w,
              child: GestureDetector(
                onTap: controller.onRetakePhotoPressed,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF9EE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16.w,
                    color: const Color(0xFF34C759),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMealNameField(ScanMealFormController controller) {
    return CustomTextField(
      label: 'meal_name'.tr,
      hintText: 'enter_meal_name'.tr,
      controller: controller.mealNameController,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildMealTypeSelection(ScanMealFormController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'meal_type'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF161618),
          ),
        ),
        12.verticalSpace,
        Obx(() {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.mealTypes.map((type) {
                final isSelected = type == controller.selectedMealType;
                return GestureDetector(
                  onTap: () => controller.selectMealType(type),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: type != controller.mealTypes.last ? 12.w : 0,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE1F7E6)
                          : const Color(0xFF8E8E93).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      type.toLowerCase().tr,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFF34C759)
                            : const Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNotesField(ScanMealFormController controller) {
    return CustomTextField(
      label: 'notes_optional'.tr,
      hintText: 'add_notes_about_meal'.tr,
      controller: controller.notesController,
      maxLines: 4,
    );
  }

  Widget _buildNutritionInfo(ScanMealFormController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'nutrition_info'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF161618),
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
                unit: 'kcal',
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: _buildNutritionField(
                label: 'protein'.tr,
                controller: controller.proteinController,
                unit: 'g',
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
                unit: 'g',
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: _buildNutritionField(
                label: 'fats'.tr,
                controller: controller.fatsController,
                unit: 'g',
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
    required String unit,
  }) {
    return CustomTextField(
      label: label,
      hintText: 'enter_nutrition_value'.tr,
      controller: controller,
      keyboardType: TextInputType.number,
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: Center(
          widthFactor: 1.0,
          child: Text(
            unit,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8E8E93),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(ScanMealFormController controller) {
    return Obx(() {
      return CustomFilledButton(
        text: controller.isLoading ? 'saving'.tr : 'save_meal_to_diary'.tr,
        onPressed: controller.isLoading ? () {} : controller.onSaveMealPressed,
        icon: Icons.bookmark_outline,
        // width: 263.w,
        height: 48.h,
        padding: EdgeInsetsGeometry.zero,
      );
    });
  }
}
