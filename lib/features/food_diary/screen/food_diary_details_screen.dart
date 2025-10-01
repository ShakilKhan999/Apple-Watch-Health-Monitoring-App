import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/food_diary/controllers/food_diary_details_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FoodDiaryDetailsScreen extends StatelessWidget {
  const FoodDiaryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FoodDiaryDetailsController controller = Get.put(
      FoodDiaryDetailsController(),
    );

    return CommonBackgroundScaffold(
      useSafeArea: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(controller),
                  24.verticalSpace,
                  _buildDateNavigation(controller),
                  24.verticalSpace,
                  _buildDailyOverview(controller),
                  32.verticalSpace,
                  _buildTodaysMeals(controller),
                  32.verticalSpace,
                  _buildMealPlanning(controller),
                  100.verticalSpace, // Space for bottom navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(FoodDiaryDetailsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: SizedBox(
              width: 24.w,
              height: 24.h,
              child: Icon(
                Icons.arrow_back_ios,
                size: 24.w,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'food_diary'.tr,
              style: getTextStyleSecondary(
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                lineHeight: 35.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 24.w), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildDateNavigation(FoodDiaryDetailsController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: controller.previousDay,
          child: Transform.flip(
            flipX: true,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 12.w,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Obx(
          () => Column(
            children: [
              Text(
                controller.selectedDateTitle,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              12.verticalSpace,
              Text(
                controller.selectedDateSubtitle,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: controller.nextDay,
          child: Icon(
            Icons.arrow_forward_ios,
            size: 12.w,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyOverview(FoodDiaryDetailsController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'daily_overview'.tr,
              style: getTextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                8.horizontalSpace,
                Text(
                  'synced_2_min_ago'.tr,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        24.verticalSpace,
        Obx(
          () => Column(
            children: [
              Row(
                children: [
                  // Calories Chart (without center text)
                  Column(
                    children: [
                      SizedBox(
                        width: 123.w,
                        height: 123.h,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 45.r,
                            startDegreeOffset: -90,
                            sections: [
                              // Consumed calories
                              PieChartSectionData(
                                color: AppColors.primary,
                                value: controller.consumedCalories.toDouble(),
                                radius: 12.r,
                                showTitle: false,
                              ),
                              // Remaining calories
                              PieChartSectionData(
                                color: const Color(0xFFF5F5F7),
                                value:
                                    (controller.targetCalories -
                                            controller.consumedCalories)
                                        .toDouble(),
                                radius: 12.r,
                                showTitle: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      12.verticalSpace,
                      Text(
                        '${controller.consumedCalories}',
                        style: getTextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        '${'of'.tr} ${controller.targetCalories} ${'kcal'.tr}',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  // Nutrition breakdown
                  Column(
                    children: [
                      _buildNutritionItem(
                        'carbs'.tr,
                        '${controller.carbs}g',
                        const Color(0xFF4A7BFF),
                      ),
                      8.verticalSpace,
                      _buildNutritionItem(
                        'protein'.tr,
                        '${controller.protein}g',
                        const Color(0xFF34C759),
                      ),
                      8.verticalSpace,
                      _buildNutritionItem(
                        'fat'.tr,
                        '${controller.fat}g',
                        const Color(0xFFFF9500),
                      ),
                      8.verticalSpace,
                      _buildNutritionItem(
                        'water'.tr,
                        '${controller.water}L',
                        const Color(0xFF007AFF),
                      ),
                      8.verticalSpace,
                      _buildNutritionItem(
                        'fiber'.tr,
                        '${controller.fiber}g',
                        const Color(0xFF8E4EC6),
                      ),
                      8.verticalSpace,
                      _buildNutritionItem(
                        'sugar'.tr,
                        '${controller.sugar}g',
                        const Color(0xFFFF3B30),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionItem(String label, String value, Color color) {
    return Row(
      children: [
        Row(
          children: [
            Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            8.horizontalSpace,
            SizedBox(
              width: 50.w,
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        32.horizontalSpace,
        SizedBox(
          width: 40.w,
          child: Text(
            value,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysMeals(FoodDiaryDetailsController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'todays_meals'.tr,
              style: getTextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'view_all'.tr,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        24.verticalSpace,
        Obx(
          () => controller.todaysMeals.isEmpty
              ? _buildEmptyMealsState()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.todaysMeals.length,
                  itemBuilder: (context, index) {
                    return _buildMealItem(
                      controller,
                      controller.todaysMeals[index],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyMealsState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 32.w),
      child: Column(
        children: [
          // Empty state icon
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Icon(
              Icons.restaurant_outlined,
              size: 40.w,
              color: AppColors.textSecondary,
            ),
          ),

          24.verticalSpace,

          // Title
          Text(
            'no_meals_logged'.tr,
            style: getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          12.verticalSpace,

          // Description
          Text(
            'start_tracking_nutrition'.tr,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          24.verticalSpace,

          // Add meal button
          GestureDetector(
            onTap: () {
              Get.snackbar(
                'add_meal'.tr,
                'add_meal_functionality_coming_soon'.tr,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                colorText: AppColors.textPrimary,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20.w, color: Colors.white),
                  8.horizontalSpace,
                  Text(
                    'log_your_first_meal'.tr,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealItem(
    FoodDiaryDetailsController controller,
    Map<String, dynamic> meal,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0x33929292), width: 1.w),
      ),
      child: Column(
        children: [
          // Meal header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Color(meal['iconColor']).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: _buildIconWidget(
                        meal['icon'],
                        Color(meal['iconColor']),
                        24.w,
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal['mealType'],
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        meal['time'],
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showDeleteConfirmation(controller, meal),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    Icons.delete_outline,
                    size: 24.w,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),

          24.verticalSpace,

          // Food item details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food image
              Container(
                width: 60.w,
                height: 46.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  image: DecorationImage(
                    image: AssetImage(meal['foodImage']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              12.horizontalSpace,

              // Food details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            meal['foodName'],
                            style: getTextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (meal['caloriesHighlight'] != null) ...[
                      8.verticalSpace,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${meal['caloriesHighlight']} cal ',
                              style: getTextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondary,
                              ),
                            ),
                            TextSpan(
                              text: '• ${meal['timeAgo']}',
                              style: getTextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    12.verticalSpace,

                    // Nutrition details
                    Row(
                      children: [
                        _buildNutritionDetail(
                          'Calories:',
                          '${meal['calories']}',
                        ),
                        Spacer(),
                        _buildNutritionDetail(
                          'Protein:',
                          '${meal['protein']}g',
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    Row(
                      children: [
                        _buildNutritionDetail('Carbs:', '${meal['carbs']}g'),
                        Spacer(),
                        _buildNutritionDetail('Fat:', '${meal['fat']}g'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          24.verticalSpace,

          // Key nutrients
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0x0F8E8E93),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0x338E8E93), width: 1.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Nutrients',
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: (meal['keyNutrients'] as List<Map<String, String>>)
                      .map(
                        (nutrient) => _buildKeyNutrient(
                          nutrient['name']!,
                          nutrient['value']!,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          // AI recommendation if available
          if (meal['aiRecommendation'] != null) ...[
            16.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Color(meal['aiRecommendation']['backgroundColor']),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Color(meal['aiRecommendation']['borderColor']),
                  width: 1.w,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Color(meal['aiRecommendation']['iconBgColor']),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Icon(
                      meal['aiRecommendation']['type'] == 'success'
                          ? Icons.check
                          : Icons.lightbulb_outline,
                      size: 24.w,
                      color: Color(meal['aiRecommendation']['iconColor']),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      meal['aiRecommendation']['message'],
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(meal['aiRecommendation']['textColor']),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionDetail(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          TextSpan(
            text: ' $value',
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyNutrient(String name, String value) {
    return Column(
      children: [
        Text(
          name,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        6.verticalSpace,
        Text(
          value,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMealPlanning(FoodDiaryDetailsController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'meal_planning'.tr,
              style: getTextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'view_all'.tr,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        16.verticalSpace,
        Obx(
          () => Column(
            children: [
              ...controller.plannedMeals.map(
                (meal) => _buildPlannedMealItem(meal),
              ),
              16.verticalSpace,
              _buildAddMealPlanItem(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlannedMealItem(Map<String, dynamic> meal) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      // height: 80.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.w),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Color(meal['iconColor']).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: _buildIconWidget(
                meal['icon'],
                Color(meal['iconColor']),
                24.w,
              ),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['title'],
                  style: getTextStyleSecondary(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                6.verticalSpace,
                Text(
                  meal['description'],
                  style: getTextStyleSecondary(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 63.w,
            height: 55.h,
          ), // Placeholder for potential image
        ],
      ),
    );
  }

  Widget _buildAddMealPlanItem() {
    return Container(
      padding: EdgeInsets.all(16.w),
      // height: 103.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.textSecondary,
          width: 1.w,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 32.w, color: AppColors.textSecondary),
          10.verticalSpace,
          Text(
            'add_meal_plan'.tr,
            style: getTextStyleSecondary(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIconWidget(String iconPath, Color color, double size) {
    if (iconPath.endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else {
      return Image.asset(iconPath, width: size, height: size, color: color);
    }
  }

  void _showDeleteConfirmation(
    FoodDiaryDetailsController controller,
    Map<String, dynamic> meal,
  ) {
    Get.dialog(
      _buildDeleteConfirmationDialog(controller, meal),
      barrierDismissible: false,
    );
  }

  Widget _buildDeleteConfirmationDialog(
    FoodDiaryDetailsController controller,
    Map<String, dynamic> meal,
  ) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Delete icon
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Center(
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 28.w,
                  ),
                ),
              ),
            ),

            20.verticalSpace,

            // Title
            Text(
              'delete_meal'.tr,
              style: getTextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            12.verticalSpace,

            // Message
            Text(
              'delete_meal_confirmation'.tr.replaceAll(
                '{foodName}',
                meal['foodName'],
              ),
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            32.verticalSpace,

            // Action buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                12.horizontalSpace,

                // Delete button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Close dialog first
                      Get.back();

                      // Delete the meal using the controller
                      controller.deleteMeal(meal);

                      // Show success message
                      Get.snackbar(
                        'meal_deleted'.tr,
                        'meal_deleted_successfully'.tr.replaceAll(
                          '{foodName}',
                          meal['foodName'],
                        ),
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                        colorText: AppColors.textPrimary,
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'delete'.tr,
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
