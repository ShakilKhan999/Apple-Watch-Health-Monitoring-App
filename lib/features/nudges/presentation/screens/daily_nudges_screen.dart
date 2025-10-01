import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import '../../controllers/daily_nudges_controller.dart';
import '../../models/nudge_model.dart';

class DailyNudgesScreen extends StatelessWidget {
  const DailyNudgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DailyNudgesController controller = Get.put(DailyNudgesController());

    return CommonBackgroundScaffold(
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,

                _buildHeader(),
                32.verticalSpace,
                _buildTodayProgressCard(controller),
                32.verticalSpace,
                _buildNudgesSection(controller),
                32.verticalSpace,
                _buildUpcomingTodaySection(controller),
                24.verticalSpace,
                _buildTipsCard(),
                100.verticalSpace, // Bottom navigation space
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.textSecondary,
                size: 20.w,
              ),
            ),
          ],
        ),
        Text(
          'daily_nudges_title'.tr,
          style: getTextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        Text(
          'daily_nudges_subtitle'.tr,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTodayProgressCard(DailyNudgesController controller) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'todays_progress'.tr,
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      12.verticalSpace,
                      Text(
                        'completed_nudges_text'.tr
                            .replaceAll(
                              '{completed}',
                              '${controller.completedNudges}',
                            )
                            .replaceAll('{total}', '${controller.totalNudges}'),
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                16.horizontalSpace,
                _buildProgressCircle(controller.todayProgress),
              ],
            ),
            24.verticalSpace,
            _buildProgressBar(controller.todayProgress),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCircle(double progress) {
    return Container(
      width: 62.w,
      height: 62.w,
      child: Stack(
        children: [
          SizedBox(
            width: 62.w,
            height: 62.w,
            child: CircularProgressIndicator(
              value: progress / 100,
              strokeWidth: 6.w,
              backgroundColor: Color(0xFFE3E3E3),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                '${progress.toInt()}%',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      width: double.infinity,
      height: 12.h,
      decoration: BoxDecoration(
        color: Color(0xFFE3E3E3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress / 100,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }

  Widget _buildNudgesSection(DailyNudgesController controller) {
    return Obx(
      () => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'nudges'.tr,
                style: getTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: controller.onAddNudgePressed,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 16.w),
                ),
              ),
            ],
          ),
          24.verticalSpace,
          controller.nudges.isEmpty
              ? _buildEmptyNudgesState(controller)
              : Column(
                  children: controller.nudges
                      .map(
                        (nudge) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildNudgeCard(nudge, controller),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyNudgesState(DailyNudgesController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFFE8E8E8), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 28.w,
            ),
          ),
          16.verticalSpace,
          Text(
            'no_nudges_yet'.tr,
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          8.verticalSpace,
          Text(
            'create_first_nudge_message'.tr,
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          24.verticalSpace,
          GestureDetector(
            onTap: controller.onAddNudgePressed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'create_nudge'.tr,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNudgeCard(NudgeModel nudge, DailyNudgesController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFFE8E8E8), width: 1),
      ),
      child: Row(
        children: [
          _buildCategoryIcon(nudge.category),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryChip(nudge.category),
                    GestureDetector(
                      onTap: () =>
                          controller.onLogNudge(nudge.id, nudge.category),
                      child: Text(
                        _getLogButtonText(nudge.category),
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                Text(
                  nudge.dynamicTitle,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                8.verticalSpace,
                Text(
                  nudge.dynamicDescription,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (nudge.category == NudgeCategory.movement) ...[
                  16.verticalSpace,
                  _buildProgressSection(nudge),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(NudgeCategory category) {
    Color backgroundColor;
    IconData iconData;

    switch (category) {
      case NudgeCategory.hydration:
        backgroundColor = Color(0xFFC7D6FF);
        iconData = Icons.water_drop_outlined;
        break;
      case NudgeCategory.movement:
        backgroundColor = Color(0xFFFFE8D9);
        iconData = Icons.directions_walk_outlined;
        break;
      case NudgeCategory.sleep:
        backgroundColor = Color(0xFFFFF9F2);
        iconData = Icons.bedtime_outlined;
        break;
      case NudgeCategory.weight:
        backgroundColor = Color(0xFFEBF9EE);
        iconData = Icons.monitor_weight_outlined;
        break;
    }

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Icon(iconData, color: _getCategoryColor(category), size: 24.w),
    );
  }

  Color _getCategoryColor(NudgeCategory category) {
    switch (category) {
      case NudgeCategory.hydration:
        return AppColors.primary;
      case NudgeCategory.movement:
        return Color(0xFFD46434);
      case NudgeCategory.sleep:
        return Color(0xFFD46434);
      case NudgeCategory.weight:
        return AppColors.secondary;
    }
  }

  Widget _buildCategoryChip(NudgeCategory category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _getCategoryChipColor(category),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        _getCategoryLocalizedName(category),
        style: getTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _getCategoryColor(category),
        ),
      ),
    );
  }

  Color _getCategoryChipColor(NudgeCategory category) {
    switch (category) {
      case NudgeCategory.hydration:
        return Color(0xFFE4EBFF);
      case NudgeCategory.movement:
        return Color(0xFFFFE8D9);
      case NudgeCategory.sleep:
        return Color(0xFFFFF9F2);
      case NudgeCategory.weight:
        return Color(0xFFEBF9EE);
    }
  }

  Widget _buildProgressSection(NudgeModel nudge) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'progress'.tr,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${nudge.progressPercentage.toInt()}%',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Container(
          width: double.infinity,
          height: 12.h,
          decoration: BoxDecoration(
            color: Color(0xFFE3E3E3),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: nudge.progressPercentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFD46434),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingTodaySection(DailyNudgesController controller) {
    return Obx(
      () => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'upcoming_today'.tr,
                style: getTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (controller.upcomingNudges.isNotEmpty)
                GestureDetector(
                  onTap: controller.onViewAllUpcomingPressed,
                  child: Text(
                    'view_all'.tr,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
            ],
          ),
          24.verticalSpace,
          controller.upcomingNudges.isEmpty
              ? _buildEmptyUpcomingState()
              : Column(
                  children: controller.upcomingNudges
                      .map(
                        (upcoming) => Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: _buildUpcomingCard(upcoming),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyUpcomingState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          Icon(
            Icons.schedule_outlined,
            color: AppColors.textSecondary,
            size: 48.w,
          ),
          16.verticalSpace,
          Text(
            'no_upcoming_nudges'.tr,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          8.verticalSpace,
          Text(
            'scheduled_nudges_message'.tr,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(UpcomingNudge upcoming) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFFE8E8E8), width: 1),
      ),
      child: Row(
        children: [
          _buildCategoryIcon(upcoming.category),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  upcoming.title,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                4.verticalSpace,
                Text(
                  upcoming.time,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          _buildCategoryChip(upcoming.category),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Color(0xFFCA8C46).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: Color(0xFFCA8C46), size: 24.w),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'great_progress'.tr,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                24.verticalSpace,
                Text(
                  'progress_tip_message'.tr,
                  style: getTextStyle(
                    fontSize: 16,
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

  String _getCategoryLocalizedName(NudgeCategory category) {
    switch (category) {
      case NudgeCategory.hydration:
        return 'hydration'.tr;
      case NudgeCategory.sleep:
        return 'sleep'.tr;
      case NudgeCategory.weight:
        return 'weight'.tr;
      case NudgeCategory.movement:
        return 'movement'.tr;
    }
  }

  String _getLogButtonText(NudgeCategory category) {
    switch (category) {
      case NudgeCategory.hydration:
        return 'log_water'.tr;
      case NudgeCategory.movement:
        return 'log_steps'.tr;
      case NudgeCategory.weight:
        return 'log_weight'.tr;
      case NudgeCategory.sleep:
        return 'log_sleep'.tr;
    }
  }
}
