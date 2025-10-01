import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/features/home/controllers/home_controller.dart';
import 'package:surajashray/features/notification/screen/all_notification_screen.dart';
import 'package:surajashray/features/notification/controller/all_notification_controller.dart';
import 'package:surajashray/features/nudges/presentation/screens/daily_nudges_screen.dart';
import 'package:surajashray/features/nudges/controllers/daily_nudges_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    Get.put(DailyNudgesController());
    Get.put(AllNotificationController());

    return CommonBackgroundScaffold(
      useSafeArea: false,
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh health data when user pulls to refresh
          if (controller.hasHealthPermissions) {
            await controller.syncHealthData();
          }
          // Also refresh other data if needed
          controller.refreshGoals();
        },
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Ensure scroll is always possible for refresh
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopGradientSection(controller),
              _buildMainContent(controller),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopGradientSection(HomeController controller) {
    return Container(
      width: double.infinity,
      height: 350.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A7BFF), Color(0xFF2C4A99)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              24.verticalSpace,
              _buildHeader(controller),
              24.verticalSpace,
              _buildWeatherCard(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(HomeController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Transform.translate(
            offset: Offset(0, -40.h),
            child: _buildWellnessScore(controller),
          ),

          Transform.translate(
            offset: Offset(0, -24.h),
            child: _buildWellnessInsight(controller),
          ),

          _buildVitalSigns(controller),
          _buildFoodDiary(controller),
          _buildGoals(controller),
          _buildQuickActions(controller),
        ],
      ),
    );
  }

  Widget _buildHeader(HomeController controller) {
    return Obx(
      () => Row(
        children: [
          // Profile image
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Icon(Icons.person, color: Colors.grey[600], size: 24.w),
            ),
          ),

          8.horizontalSpace,

          // Greeting and name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${controller.greeting}, ',
                        style: getTextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF5F5F7),
                        ),
                      ),
                      TextSpan(
                        text: controller.userName,
                        style: getTextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF5F5F7),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  controller.currentDate,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFF5F5F7),
                  ),
                ),
              ],
            ),
          ),

          // Notification and settings icons
          Row(
            children: [
              // Container(
              //   width: 32.w,
              //   height: 32.h,
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFEDF2FF),
              //     borderRadius: BorderRadius.circular(24.r),
              //   ),
              //   child: Icon(
              //     Icons.notifications_outlined,
              //     size: 16.w,
              //     color: AppColors.primary,
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  Get.to(AllNotificationScreen()); // or AllNotificationScreen()
                },
                child: _buildNotificationIcon(),
              ),

              12.horizontalSpace,

              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF2FF),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  size: 16.w,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(HomeController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.0.w, right: 8.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.celebration_sharp,
                  size: 40.w,
                  color: const Color.fromARGB(255, 147, 249, 142),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // 'youre_doing_great'.tr,
                              'Best week yet!',
                              style: getTextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textWhite,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              // 'keep_it_up'.tr,
                              'You completed of your habits',
                              style: getTextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textWhite,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Celebrate icon
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessScore(HomeController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF929292).withValues(alpha: 0.24),
            offset: const Offset(0, 4),
            blurRadius: 25.r,
          ),
        ],
      ),
      child: Obx(
        () => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'wellness_score'.tr,
                  style: getTextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'today'.tr,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            32.verticalSpace,

            // PieChart
            SizedBox(
              width: 140.w,
              height: 140.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 50.r,
                      startDegreeOffset: -90,
                      sections: [
                        // Filled section
                        PieChartSectionData(
                          color: AppColors.primary,
                          value: controller.wellnessScore.toDouble(),
                          radius: 16.r,
                          showTitle: false,
                        ),

                        // Remaining section
                        PieChartSectionData(
                          color: const Color(0xFFF5F5F7),
                          value: (100 - controller.wellnessScore).toDouble(),
                          radius: 16.r,
                          showTitle: false,
                        ),
                      ],
                    ),
                  ),

                  // Center Text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${controller.wellnessScore.toInt()}%',
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            16.verticalSpace,

            Text(
              '${controller.wellnessScore.toInt()}/100',
              style: getTextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),

            10.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildWellnessInsight(HomeController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.8, -0.6),
          end: Alignment(0.8, 0.6),
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.secondary.withValues(alpha: 0.04),
            Colors.white.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            offset: const Offset(0, 8),
            blurRadius: 24.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.2),
                        AppColors.secondary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.psychology_outlined,
                    size: 20.w,
                    color: AppColors.primary,
                  ),
                ),

                12.horizontalSpace,

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'wellness_insights'.tr,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      2.verticalSpace,

                      Text(
                        'ai_analysis'.tr,
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getInsightBadgeColor(controller.wellnessScore),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    _getInsightLevel(controller.wellnessScore),
                    style: getTextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            16.verticalSpace,

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  width: 1.w,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getInsightMessage(controller.wellnessScore),
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.left,
                  ),

                  12.verticalSpace,

                  Row(
                    children: [
                      Container(
                        width: 3.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),

                      8.horizontalSpace,

                      Expanded(
                        child: Text(
                          _getInsightRecommendation(controller.wellnessScore),
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            12.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInsightMetric(
                  icon: Icons.trending_up,
                  label: 'insight_progress'.tr,
                  value: _getProgressTrend(controller.wellnessScore),
                  color: _getProgressColor(controller.wellnessScore),
                ),

                Container(
                  width: 1.w,
                  height: 20.h,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),

                _buildInsightMetric(
                  icon: Icons.favorite_outline,
                  label: 'insight_status'.tr,
                  value: _getHealthStatus(controller.wellnessScore),
                  color: _getInsightBadgeColor(controller.wellnessScore),
                ),

                Container(
                  width: 1.w,
                  height: 20.h,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),

                _buildInsightMetric(
                  icon: Icons.visibility_outlined,
                  label: 'insight_focus'.tr,
                  value: _getFocusArea(controller.wellnessScore),
                  color: AppColors.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.w, color: color),
          ),

          8.verticalSpace,

          Text(
            label,
            style: getTextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),

          4.verticalSpace,

          Text(
            value,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSigns(HomeController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'vital_signs'.tr,
                    style: getTextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  12.horizontalSpace,

                  // Refresh icon for vital signs
                  GestureDetector(
                    onTap: controller.onVitalSignsRefresh,
                    child: Obx(
                      () => Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: controller.isHealthDataLoading
                            ? SizedBox(
                                width: 16.w,
                                height: 16.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              )
                            : Icon(
                                Icons.refresh,
                                size: 16.w,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Health sync status indicator
                  Obx(
                    () => controller.hasHealthPermissions
                        ? Icon(
                            Icons.health_and_safety,
                            size: 16.w,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.health_and_safety_outlined,
                            size: 16.w,
                            color: Colors.orange,
                          ),
                  ),

                  8.horizontalSpace,

                  GestureDetector(
                    onTap: controller.onVitalSignsTap,
                    child: Text(
                      'see_all'.tr,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          24.verticalSpace,

          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildVitalSignItem(
                  title: 'steps'.tr,
                  value: controller.vitalSigns['steps']['value'].toString(),
                  color: Color(controller.vitalSigns['steps']['color']),
                  icon: Icons.directions_walk,
                ),
                _buildVitalSignItem(
                  title: 'sleep'.tr,
                  value: controller.vitalSigns['sleep']['value'].toString(),
                  color: Color(controller.vitalSigns['sleep']['color']),
                  icon: Icons.nights_stay,
                ),
                _buildVitalSignItem(
                  title: 'heart'.tr,
                  value: controller.vitalSigns['heart']['value'].toString(),
                  color: Color(controller.vitalSigns['heart']['color']),
                  icon: Icons.favorite,
                ),
                _buildVitalSignItem(
                  title: 'calories'.tr,
                  value: controller.vitalSigns['calories']['value'].toString(),
                  color: Color(controller.vitalSigns['calories']['color']),
                  icon: Icons.local_fire_department,
                ),
              ],
            ),
          ),

          // Health permissions prompt (if needed)
          Obx(() {
            if (!controller.hasHealthPermissions &&
                controller.healthDataError.isNotEmpty) {
              return Container(
                margin: EdgeInsets.only(top: 16.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 16.w),
                    8.horizontalSpace,
                    Expanded(
                      child: Text(
                        controller.healthDataError,
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.orange[700]!,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.onVitalSignsRefresh,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Retry',
                          style: getTextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildVitalSignItem({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return SizedBox(
      width: 68.w, // Fixed width from Figma
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,s
        children: [
          // Icon at the very top
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(36.r),
              ),
              child: Icon(icon, size: 20.w, color: color),
            ),
          ),

          12.verticalSpace,

          // Title in the middle
          Text(
            title,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          8.verticalSpace,

          // Value at the bottom
          SizedBox(
            height: 24.h,
            child: Text(
              value,
              style: getTextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodDiary(HomeController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'food_diary'.tr,
                      style: getTextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      'today'.tr,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40.w,
                height: 40.h,
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.add,
                    size: 24.w,
                    color: AppColors.textSecondary,
                  ),
                  padding: EdgeInsets.zero,
                  iconSize: 24.w,
                  onSelected: (String value) {
                    switch (value) {
                      case 'add_new':
                        controller.onAddNewMeal();
                        break;
                      case 'add_existing':
                        controller.onAddExistingMeal();
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    final bool hasExistingMeals =
                        controller.foodDiaryRx.isNotEmpty;
                    return [
                      PopupMenuItem<String>(
                        value: 'add_new',
                        child: Text(
                          'add_new_meal'.tr,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'add_existing',
                        enabled: hasExistingMeals,
                        child: Text(
                          'add_existing_meal'.tr,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: hasExistingMeals
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ],
          ),

          Obx(
            () => controller.foodDiaryRx.isEmpty
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 24.h),
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFFE8E8E8),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.restaurant_menu_outlined,
                          size: 48.w,
                          color: AppColors.textSecondary,
                        ),
                        16.verticalSpace,
                        Text(
                          'no_meals_added_today'.tr,
                          style: getTextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          'tap_plus_icon_add_meal'.tr,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.foodDiaryRx.length,
                    itemBuilder: (context, index) {
                      return _buildFoodDiaryItem(
                        controller.foodDiaryRx[index],
                        index,
                        controller,
                      );
                    },
                  ),
          ),

          16.verticalSpace,

          GestureDetector(
            onTap: controller.onFoodDiaryTap,
            child: Text(
              'view_details'.tr,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodDiaryItem(
    Map<String, dynamic> item,
    int index,
    HomeController controller,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
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
              color: Color(item['color']).withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: _buildIcon(item['icon'], Color(item['color']), 24.w),
            ),
          ),

          12.horizontalSpace,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),

                6.verticalSpace,

                Text(
                  item['subtitle'],
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),

                4.verticalSpace,

                Text(
                  item['time'],
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Toggleable circular checkbox
          GestureDetector(
            onTap: () => controller.toggleFoodDiaryItem(index),
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(item['color']), width: 2.w),
                color: item['checked']
                    ? Color(item['color'])
                    : Colors.transparent,
              ),
              child: item['checked']
                  ? Icon(Icons.check, size: 16.w, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoals(HomeController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'your_goals'.tr,
                style: getTextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => const DailyNudgesScreen()),
                child: Text(
                  'view_all'.tr,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),

          16.verticalSpace,

          // Make goals reactive to nudges data
          GetBuilder<HomeController>(
            builder: (homeController) {
              final goals = homeController.goals;

              if (goals.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 48.w,
                        color: AppColors.textSecondary,
                      ),
                      16.verticalSpace,
                      Text(
                        'no_active_goals'.tr,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        'add_nudges_progress'.tr,
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

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return _buildGoalItem(goals[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(Map<String, dynamic> goal) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Color(goal['color']).withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: _buildIcon(goal['icon'], Color(goal['color']), 24.w),
            ),
          ),

          12.horizontalSpace,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goal['title'],
                      style: getTextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      goal['progress'],
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(goal['color']),
                      ),
                    ),
                  ],
                ),

                12.verticalSpace,

                Text(
                  goal['target'],
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),

                12.verticalSpace,

                // Progress bar
                Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Color(goal['color']).withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Unfilled background (full width) - transparent with border
                      Container(
                        width: double.infinity,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      // Filled progress
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: goal['progressValue'],
                        child: Container(
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: Color(goal['color']),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  goal['color'],
                                ).withValues(alpha: 0.3),
                                blurRadius: 4.r,
                                offset: Offset(0, 2.h),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                6.verticalSpace,

                Text(
                  goal['message'],
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(HomeController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'quick_actions'.tr,
            style: getTextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          24.verticalSpace,

          Obx(
            () => Column(
              children: controller.quickActions
                  .map((action) => _buildQuickActionItem(action, controller))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    Map<String, dynamic> action,
    HomeController controller,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(action['backgroundColor']),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Color(action['color']), width: 1.w),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Color(action['color']).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: _buildIcon(
                        action['icon'],
                        Color(action['color']),
                        24.w,
                      ),
                    ),
                  ),

                  12.horizontalSpace,

                  Text(
                    action['title'],
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              _buildIcon(action['trailingIcon'], Color(action['color']), 24.w),
            ],
          ),

          12.verticalSpace,

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'recent_result'.tr,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      action['recentResult'],
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(action['color']),
                      ),
                    ),
                  ),
                ],
              ),

              6.verticalSpace,

              Text(
                action['timestamp'],
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),

              8.verticalSpace,

              GestureDetector(
                onTap: () => controller.onQuickActionTap(action['title']),
                child: Text(
                  'view_all'.tr,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to handle both SVG and PNG icons
  Widget _buildIcon(String iconPath, Color color, double size) {
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

  // Helper method to build notification icon with badge
  Widget _buildNotificationIcon() {
    return GetBuilder<AllNotificationController>(
      builder: (notificationController) {
        final unreadCount = notificationController.unreadCount;

        // Determine the size of the badge based on unread count
        double badgeSize = unreadCount > 99
            ? 26.w
            : 24.w; // Adjust the size depending on unreadCount
        double fontSize = unreadCount > 99
            ? 8.sp
            : 10.sp; // Adjust text size for larger count

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2FF),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 16.w,
                color: AppColors.primary,
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                top: -8.h,
                right: -8.w,
                child: Container(
                  width: badgeSize, // Dynamic size based on unread count
                  height: badgeSize, // Maintain circular shape
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 244, 67, 54),
                    borderRadius: BorderRadius.circular(
                      badgeSize / 2,
                    ), // Half of the size for circle
                    border: Border.all(color: Colors.white, width: 1.w),
                  ),
                  alignment: Alignment.center, // Ensures the text is centered
                  child: Center(
                    child: Text(
                      // '99+',
                      notificationController.unreadCountDisplay,
                      style: getTextStyle(
                        fontSize: fontSize, // Dynamic font size
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ============================================================================
  // WELLNESS INSIGHT HELPER METHODS
  // ============================================================================

  Color _getInsightBadgeColor(double score) {
    if (score >= 85) return AppColors.green;
    if (score >= 70) return AppColors.primary;
    if (score >= 55) return const Color(0xFFFFA726);
    return const Color(0xFFFF6B6B);
  }

  String _getInsightLevel(double score) {
    if (score >= 85) return 'insight_excellent'.tr;
    if (score >= 70) return 'insight_good'.tr;
    if (score >= 55) return 'insight_fair'.tr;
    return 'needs_attention'.tr;
  }

  String _getInsightMessage(double score) {
    if (score >= 90) {
      return 'outstanding_wellness_message'.tr;
    } else if (score >= 85) {
      return 'excellent_wellness_message'.tr;
    } else if (score >= 75) {
      return 'good_wellness_message'.tr;
    } else if (score >= 65) {
      return 'moderate_wellness_message'.tr;
    } else if (score >= 55) {
      return 'fair_wellness_message'.tr;
    } else {
      return 'improvement_needed_message'.tr;
    }
  }

  String _getInsightRecommendation(double score) {
    if (score >= 85) {
      return 'excellent_recommendation'.tr;
    } else if (score >= 70) {
      return 'good_recommendation'.tr;
    } else if (score >= 55) {
      return 'moderate_recommendation'.tr;
    } else {
      return 'improvement_recommendation'.tr;
    }
  }

  String _getProgressTrend(double score) {
    if (score >= 85) return 'trending_up'.tr;
    if (score >= 70) return 'stable'.tr;
    if (score >= 55) return 'improving'.tr;
    return 'focus_needed'.tr;
  }

  Color _getProgressColor(double score) {
    if (score >= 85) return AppColors.green;
    if (score >= 70) return AppColors.primary;
    if (score >= 55) return const Color(0xFFFFA726);
    return const Color(0xFFFF6B6B);
  }

  String _getHealthStatus(double score) {
    if (score >= 85) return 'optimal'.tr;
    if (score >= 70) return 'insight_healthy'.tr;
    if (score >= 55) return 'insight_moderate'.tr;
    return 'low'.tr;
  }

  String _getFocusArea(double score) {
    if (score >= 85) return 'maintain'.tr;
    if (score >= 70) return 'insight_nutrition'.tr;
    if (score >= 55) return 'insight_activity'.tr;
    return 'sleep'.tr;
  }
}
