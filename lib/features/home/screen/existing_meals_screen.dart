import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/custom_text_field.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/home/controllers/existing_meals_controller.dart';

class ExistingMealsScreen extends StatelessWidget {
  const ExistingMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ExistingMealsController controller = Get.put(
      ExistingMealsController(),
    );

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

  Widget _buildHeader(ExistingMealsController controller) {
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
              'existing_meals'.tr,
              style: getTextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            20.verticalSpace,

            // Search field
            CustomTextField(
              label: '',
              controller: controller.searchController,
              hintText: 'search_meals'.tr,
              prefixIcon: Icon(
                Icons.search,
                size: 20.w,
                color: AppColors.textSecondary,
              ),
              onChanged: controller.onSearchChanged,
            ),

            20.verticalSpace,

            // Meal type filter
            _buildMealTypeFilter(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypeFilter(ExistingMealsController controller) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.mealTypes.length,
        itemBuilder: (context, index) {
          final mealType = controller.mealTypes[index];

          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => controller.selectMealType(mealType),
              child: Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: controller.selectedMealType == mealType
                        ? AppColors.primary
                        : const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: Text(
                      mealType,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: controller.selectedMealType == mealType
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(ExistingMealsController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.verticalSpace,

          Obx(() {
            if (controller.filteredMeals.isEmpty) {
              return _buildEmptyState();
            }

            return _buildMealsList(controller);
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          60.verticalSpace,
          Icon(
            Icons.restaurant_menu,
            size: 64.w,
            color: AppColors.textSecondary,
          ),
          16.verticalSpace,
          Text(
            'no_meals_added_yet'.tr,
            style: getTextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          8.verticalSpace,
          Text(
            'add_first_meal_message'.tr,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMealsList(ExistingMealsController controller) {
    // Group meals by meal type
    final groupedMeals = <String, List<Map<String, dynamic>>>{};

    for (final meal in controller.filteredMeals) {
      final mealType = meal['mealType'] as String;
      if (!groupedMeals.containsKey(mealType)) {
        groupedMeals[mealType] = [];
      }
      groupedMeals[mealType]!.add(meal);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedMeals.entries.map((entry) {
        final mealType = entry.key;
        final meals = entry.value;

        return _buildMealTypeSection(controller, mealType, meals);
      }).toList(),
    );
  }

  Widget _buildMealTypeSection(
    ExistingMealsController controller,
    String mealType,
    List<Map<String, dynamic>> meals,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: controller.getMealTypeColor(mealType),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                _getMealTypeIcon(mealType),
                size: 20.w,
                color: controller.getMealTypeIconColor(mealType),
              ),
            ),
            12.horizontalSpace,
            Text(
              mealType,
              style: getTextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
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

        // Meals list
        ...meals.map((meal) => _buildMealItem(controller, meal)),

        24.verticalSpace,
      ],
    );
  }

  Widget _buildMealItem(
    ExistingMealsController controller,
    Map<String, dynamic> meal,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Row(
        children: [
          // Meal image placeholder
          Container(
            width: 60.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: controller.getMealTypeColor(meal['mealType']),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              _getMealTypeIcon(meal['mealType']),
              size: 24.w,
              color: controller.getMealTypeIconColor(meal['mealType']),
            ),
          ),

          12.horizontalSpace,

          // Meal info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name'],
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                4.verticalSpace,
                Text(
                  'calories_count'.tr.replaceAll(
                    '{calories}',
                    '${meal['calories']}',
                  ),
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),

          // Add button
          GestureDetector(
            onTap: () => controller.addMealToFoodDiary(meal),
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.add, size: 18.w, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMealTypeIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snack':
        return Icons.cookie;
      default:
        return Icons.fastfood;
    }
  }
}
