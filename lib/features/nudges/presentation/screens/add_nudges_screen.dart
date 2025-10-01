import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/common/widgets/custom_text_field.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import '../../controllers/add_nudges_controller.dart';
import '../../models/nudge_model.dart';

class AddNudgesScreen extends StatelessWidget {
  const AddNudgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNudgesController controller = Get.put(AddNudgesController());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              _buildHeader(),
              32.verticalSpace,
              _buildNudgeDetailsTitle(),
              24.verticalSpace,
              _buildNudgeForm(controller),
              32.verticalSpace,
              _buildActionButtons(controller),
              100.verticalSpace,
            ],
          ),
        ),
      ),
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
                color: AppColors.textPrimary,
                size: 20.w,
              ),
            ),
          ],
        ),
        24.verticalSpace,
        Text(
          'add_nudges_title'.tr,
          style: getTextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        Text(
          'add_nudges_subtitle'.tr,
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

  Widget _buildNudgeDetailsTitle() {
    return Text(
      'nudges_details_title'.tr,
      style: getTextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildNudgeForm(AddNudgesController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNudgeTitleField(controller),
        40.verticalSpace,
        _buildCategorySection(controller),
        24.verticalSpace,
        _buildQuickAddSection(controller),
        24.verticalSpace,
        _buildDateField(controller),
        24.verticalSpace,
      ],
    );
  }

  Widget _buildNudgeTitleField(AddNudgesController controller) {
    return CustomTextField(
      label: 'nudge_title_label'.tr,
      hintText: 'enter_nudge_title'.tr,
      controller: controller.titleController,
    );
  }

  Widget _buildCategorySection(AddNudgesController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'category_label'.tr,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        12.verticalSpace,
        Obx(
          () => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryCard(
                    NudgeCategory.hydration,
                    controller,
                    isSelected:
                        controller.selectedCategory == NudgeCategory.hydration,
                  ),
                  _buildCategoryCard(
                    NudgeCategory.sleep,
                    controller,
                    isSelected:
                        controller.selectedCategory == NudgeCategory.sleep,
                  ),
                ],
              ),
              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryCard(
                    NudgeCategory.weight,
                    controller,
                    isSelected:
                        controller.selectedCategory == NudgeCategory.weight,
                  ),
                  _buildCategoryCard(
                    NudgeCategory.movement,
                    controller,
                    isSelected:
                        controller.selectedCategory == NudgeCategory.movement,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    NudgeCategory category,
    AddNudgesController controller, {
    required bool isSelected,
  }) {
    Color backgroundColor;
    Color borderColor;
    IconData iconData;

    switch (category) {
      case NudgeCategory.hydration:
        backgroundColor = isSelected ? Color(0xFFE4EBFF) : Color(0xFFF5F5F7);
        borderColor = isSelected ? AppColors.primary : Color(0xFFE8E8E8);
        iconData = Icons.water_drop_outlined;
        break;
      case NudgeCategory.sleep:
        backgroundColor = isSelected ? Color(0xFFFFF9F2) : Color(0xFFF5F5F7);
        borderColor = isSelected
            ? Color(0xFFD46434).withValues(alpha: 0.5)
            : Color(0xFFE8E8E8);
        iconData = Icons.bedtime_outlined;
        break;
      case NudgeCategory.weight:
        backgroundColor = isSelected ? Color(0xFFEBF9EE) : Color(0xFFF5F5F7);
        borderColor = isSelected
            ? AppColors.secondary.withValues(alpha: 0.5)
            : Color(0xFFE8E8E8);
        iconData = Icons.monitor_weight_outlined;
        break;
      case NudgeCategory.movement:
        backgroundColor = isSelected ? Color(0xFFFFF9F2) : Color(0xFFF5F5F7);
        borderColor = isSelected
            ? Color(0xFFD46434).withValues(alpha: 0.5)
            : Color(0xFFE8E8E8);
        iconData = Icons.directions_walk_outlined;
        break;
    }

    return GestureDetector(
      onTap: () => controller.selectCategory(category),
      child: Container(
        width: 166.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          children: [
            Icon(iconData, color: _getCategoryColor(category), size: 24.w),
            12.verticalSpace,
            Text(
              _getCategoryLocalizedName(category),
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(NudgeCategory category) {
    switch (category) {
      case NudgeCategory.hydration:
        return AppColors.primary;
      case NudgeCategory.sleep:
        return Color(0xFFD46434);
      case NudgeCategory.weight:
        return AppColors.secondary;
      case NudgeCategory.movement:
        return Color(0xFFD46434);
    }
  }

  Widget _buildQuickAddSection(AddNudgesController controller) {
    return Obx(() {
      if (controller.selectedCategory == null) return SizedBox.shrink();

      final category = controller.selectedCategory!;
      final categoryConfig = _getCategoryConfiguration(category);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: categoryConfig['primaryColor'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  categoryConfig['icon'],
                  color: categoryConfig['primaryColor'],
                  size: 18.w,
                ),
              ),
              12.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'set_goal_title'.tr.replaceAll(
                      '{category}',
                      _getCategoryLocalizedName(category),
                    ),
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    categoryConfig['subtitle'],
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          20.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: categoryConfig['primaryColor'].withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: categoryConfig['primaryColor'].withOpacity(0.08),
                  offset: Offset(0, 4),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                // Value Display
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  decoration: BoxDecoration(
                    color: categoryConfig['primaryColor'].withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _formatDisplayValue(controller.quickAddValue),
                            style: getTextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: categoryConfig['primaryColor'],
                            ),
                          ),
                          8.horizontalSpace,
                          Text(
                            controller.selectedUnit,
                            style: getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: categoryConfig['primaryColor'].withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Text(
                        categoryConfig['goalText'],
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                24.verticalSpace,
                // Unit Selection (if multiple units available)
                if (category.defaultUnits.length > 1) ...[
                  Row(
                    children: [
                      Text(
                        'unit_label'.tr,
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      16.horizontalSpace,
                      ...category.defaultUnits
                          .map(
                            (unit) => Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: _buildUnitChip(
                                unit,
                                controller,
                                categoryConfig,
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                  20.verticalSpace,
                ],
                // Quick Adjustment Buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'quick_adjustments'.tr,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    16.verticalSpace,
                    Row(
                      children: categoryConfig['adjustments']
                          .map<Widget>(
                            (adj) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      adj == categoryConfig['adjustments'].last
                                      ? 0
                                      : 8.w,
                                ),
                                child: _buildAdjustmentChip(
                                  adj['label'],
                                  () => controller.adjustQuickAddValue(
                                    adj['value'],
                                  ),
                                  categoryConfig,
                                  isNegative: adj['value'] < 0,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    24.verticalSpace,
                    // Custom Input Section
                    Text(
                      'Or Enter Custom Value',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    12.verticalSpace,
                    _buildCustomInputField(controller, categoryConfig),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Map<String, dynamic> _getCategoryConfiguration(NudgeCategory category) {
    switch (category) {
      case NudgeCategory.hydration:
        return {
          'primaryColor': Color(0xFF4A7BFF),
          'icon': Icons.water_drop_outlined,
          'subtitle': 'hydration_subtitle'.tr,
          'goalText': 'hydration_goal_text'.tr,
          'adjustments': [
            {'label': '-250', 'value': -250.0},
            {'label': '-500', 'value': -500.0},
            {'label': '+250', 'value': 250.0},
            {'label': '+500', 'value': 500.0},
          ],
        };
      case NudgeCategory.movement:
        return {
          'primaryColor': Color(0xFFD46434),
          'icon': Icons.directions_walk_outlined,
          'subtitle': 'movement_subtitle'.tr,
          'goalText': 'movement_goal_text'.tr,
          'adjustments': [
            {'label': '-1K', 'value': -1000.0},
            {'label': '-2K', 'value': -2000.0},
            {'label': '+1K', 'value': 1000.0},
            {'label': '+2K', 'value': 2000.0},
          ],
        };
      case NudgeCategory.sleep:
        return {
          'primaryColor': Color(0xFF8B5CF6),
          'icon': Icons.bedtime_outlined,
          'subtitle': 'sleep_subtitle'.tr,
          'goalText': 'sleep_goal_text'.tr,
          'adjustments': [
            {'label': '-0.5', 'value': -0.5},
            {'label': '-1', 'value': -1.0},
            {'label': '+0.5', 'value': 0.5},
            {'label': '+1', 'value': 1.0},
          ],
        };
      case NudgeCategory.weight:
        return {
          'primaryColor': Color(0xFF10B981),
          'icon': Icons.monitor_weight_outlined,
          'subtitle': 'weight_subtitle'.tr,
          'goalText': 'weight_goal_text'.tr,
          'adjustments': [
            {'label': '-5', 'value': -5.0},
            {'label': '-1', 'value': -1.0},
            {'label': '+1', 'value': 1.0},
            {'label': '+5', 'value': 5.0},
          ],
        };
    }
  }

  Widget _buildUnitChip(
    String unit,
    AddNudgesController controller,
    Map<String, dynamic> config,
  ) {
    final isSelected = controller.selectedUnit == unit;
    return GestureDetector(
      onTap: () => controller.selectUnit(unit),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? config['primaryColor'] : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: config['primaryColor'], width: 1.5),
        ),
        child: Text(
          unit,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : config['primaryColor'],
          ),
        ),
      ),
    );
  }

  Widget _buildAdjustmentChip(
    String label,
    VoidCallback onTap,
    Map<String, dynamic> config, {
    required bool isNegative,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: isNegative
              ? Color(0xFFF3F4F6)
              : config['primaryColor'].withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isNegative
                ? Color(0xFFD1D5DB)
                : config['primaryColor'].withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isNegative ? Color(0xFF6B7280) : config['primaryColor'],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDisplayValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  Widget _buildCustomInputField(
    AddNudgesController controller,
    Map<String, dynamic> config,
  ) {
    final customController = TextEditingController();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomTextField(
            label: '',
            controller: customController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            hintText: 'Enter custom value',
            onSubmitted: (value) {
              final doubleValue = double.tryParse(value);
              if (doubleValue != null && doubleValue > 0) {
                controller.setQuickAddValue(doubleValue);
                customController.clear();
                FocusScope.of(Get.context!).unfocus();
              }
            },
          ),
        ),
        8.horizontalSpace,
        GestureDetector(
          onTap: () {
            final doubleValue = double.tryParse(customController.text);
            if (doubleValue != null && doubleValue > 0) {
              controller.setQuickAddValue(doubleValue);
              customController.clear();
              FocusScope.of(Get.context!).unfocus();
            } else {
              Get.snackbar(
                'Invalid Input',
                'Please enter a valid positive number',
                backgroundColor: Color(0xFFFF3B30),
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            }
          },
          child: Container(
            height: 48.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: config['primaryColor'],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(Icons.check, color: Colors.white, size: 20.w),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildDateField(AddNudgesController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'date_label'.tr,
        style: getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),
      12.verticalSpace,
      Obx(
        () => GestureDetector(
          onTap: controller.selectDate,
          child: Container(
            width: double.infinity,
            // height: 46.h,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Color(0xFFE8E8E8), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.selectedDate.isEmpty
                      ? 'select_date'.tr
                      : controller.selectedDate,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: controller.selectedDate.isEmpty
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.textSecondary,
                  size: 20.w,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildActionButtons(AddNudgesController controller) {
  return Obx(() {
    return Column(
      children: [
        CustomFilledButton(
          text: controller.isLoading ? 'saving'.tr : 'save_changes'.tr,
          onPressed: controller.isLoading ? () {} : controller.onSaveChanges,
          padding: EdgeInsets.zero,
        ),
        16.verticalSpace,
        GestureDetector(
          onTap: controller.onDeleteNudge,
          child: Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              color: Color(0xFFFF3B30),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'delete'.tr,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  });
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
