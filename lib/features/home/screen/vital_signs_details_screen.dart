import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/home/controllers/vital_signs_details_controller.dart';

class VitalSignsDetailsScreen extends StatelessWidget {
  const VitalSignsDetailsScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    Get.put(VitalSignsDetailsController());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackButton(),
            _buildHeader(),
            24.verticalSpace,
            _buildHeartRateCard(),
            24.verticalSpace,
            _buildStepsCard(),
            24.verticalSpace,
            _buildSleepAnalysisCard(),
            24.verticalSpace,
            _buildBloodOxygenCard(),
            24.verticalSpace,
            _buildAdditionalMetrics(),
            24.verticalSpace,
            _buildWeeklyTrends(),
            100.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    if (!showBackButton) {
      return SizedBox(height: 32.h); // Just spacing when no back button
    }

    final controller = Get.find<VitalSignsDetailsController>();

    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 24.h),
      child: GestureDetector(
        onTap: controller.onBackPressed,
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20.w,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "todays_vitals".tr,
            style: getTextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF161618),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'jan_15_2024_apple_watch'.tr,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateCard() {
    final controller = Get.find<VitalSignsDetailsController>();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC2BF),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: SvgPicture.asset(
                      IconPath.lessStress,
                      fit: BoxFit.none,
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'heart_rate'.tr,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF161618),
                        ),
                      ),
                      Text(
                        'last_updated_2_min_ago'.tr,
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '72',
                    style: getTextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF3B30),
                    ),
                  ),
                  Text(
                    'bpm'.tr,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // Heart Rate Chart
          Obx(
            () => SizedBox(
              height: 163.h,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFE8E8E8),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 12,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = Text('six_am'.tr, style: style);
                              break;
                            case 1:
                              text = Text('nine_am'.tr, style: style);
                              break;
                            case 2:
                              text = Text('twelve_pm'.tr, style: style);
                              break;
                            case 3:
                              text = Text('three_pm'.tr, style: style);
                              break;
                            case 4:
                              text = Text('six_pm'.tr, style: style);
                              break;
                            case 5:
                              text = Text('nine_pm'.tr, style: style);
                              break;
                            default:
                              text = const Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: text,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 32,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 10,
                          );
                          return Text('${value.toInt()}', style: style);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 5,
                  minY: 60,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.heartRateData
                          .asMap()
                          .entries
                          .map(
                            (entry) => FlSpot(
                              entry.key.toDouble(),
                              entry.value['bpm'].toDouble(),
                            ),
                          )
                          .toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFF3B30),
                          const Color(0xFFFF3B30).withValues(alpha: 0.8),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: const Color(0xFFFF3B30),
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFF3B30).withValues(alpha: 0.3),
                            const Color(0xFFFF3B30).withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      // tooltipBgColor: const Color(0xFF161618),
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                            '${barSpot.y.toInt()} bpm',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Stats Row
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0x338E8E93))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('resting'.tr, '65'),
                _buildStatItem('average'.tr, '72'),
                _buildStatItem('peak'.tr, '145'),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Health Insight
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF9EE),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0x8034C759)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF34C759),
                  size: 16,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'normal_range_heart_rate_healthy'.tr,
                    style: getTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF34C759),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard() {
    final controller = Get.find<VitalSignsDetailsController>();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFDEDEDE)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF9EE),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Image.asset(
                      'assets/icons/steps.png',
                      fit: BoxFit.cover,
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'steps'.tr,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF161618),
                        ),
                      ),
                      Obx(() {
                        final stepsData =
                            controller.detailedVitalSigns['steps'];
                        return Text(
                          'goal_steps'.tr.replaceAll(
                            '{targetValue}',
                            stepsData['targetValue'],
                          ),
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8E8E93),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() {
                    final stepsData = controller.detailedVitalSigns['steps'];
                    return Text(
                      stepsData['currentValue'],
                      style: getTextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF34C759),
                      ),
                    );
                  }),
                  Obx(() {
                    final stepsData = controller.detailedVitalSigns['steps'];
                    final currentSteps = int.parse(
                      stepsData['currentValue'].replaceAll(',', ''),
                    );
                    final goalSteps = int.parse(
                      stepsData['targetValue'].replaceAll(',', ''),
                    );
                    final progress = (currentSteps / goalSteps).clamp(0.0, 1.0);
                    final progressPercentage = (progress * 100).toInt();

                    return Text(
                      'percent_of_goal'.tr.replaceAll(
                        '{progressPercentage}',
                        progressPercentage.toString(),
                      ),
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8E8E93),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Progress Bar
          Column(
            children: [
              Obx(() {
                final stepsData = controller.detailedVitalSigns['steps'];
                final currentSteps = int.parse(
                  stepsData['currentValue'].replaceAll(',', ''),
                );
                final goalSteps = int.parse(
                  stepsData['targetValue'].replaceAll(',', ''),
                );
                final progress = (currentSteps / goalSteps).clamp(0.0, 1.0);
                final progressPercentage = (progress * 100).toInt();

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'progress'.tr,
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF161618),
                          ),
                        ),
                        Text(
                          '$progressPercentage%',
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF34C759),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFF34C759),
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

                          FractionallySizedBox(
                            widthFactor: progress,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 12.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF34C759),
                                    const Color(0xFF17B26A),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF34C759,
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
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                        Text(
                          '${stepsData['currentValue']} / ${stepsData['targetValue']} steps',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF161618),
                          ),
                        ),
                        Text(
                          '${stepsData['targetValue']}',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
          SizedBox(height: 32.h),

          // Steps Bar Chart
          Obx(
            () => SizedBox(
              height: 163.h,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 120,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      // tooltipBgColor: const Color(0xFF161618),
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()}%\nof hourly goal',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 12,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = const Text('6AM', style: style);
                              break;
                            case 1:
                              text = const Text('9AM', style: style);
                              break;
                            case 2:
                              text = const Text('12PM', style: style);
                              break;
                            case 3:
                              text = const Text('3PM', style: style);
                              break;
                            case 4:
                              text = const Text('6PM', style: style);
                              break;
                            case 5:
                              text = const Text('9PM', style: style);
                              break;
                            default:
                              text = const Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: text,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 32,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 10,
                          );
                          return Text('${value.toInt()}', style: style);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFE8E8E8),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: controller.stepsData
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value['steps'].toDouble(),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF34C759),
                                  const Color(0xFF17B26A),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Stats Row
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0x338E8E93))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('distance'.tr, '2.3 mi'),
                _buildStatItem('calories'.tr, '180'),
                _buildStatItem('active_min'.tr, '45'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepAnalysisCard() {
    final controller = Get.find<VitalSignsDetailsController>();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7D6FF),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: const Icon(
                      Icons.bedtime_outlined,
                      color: Color(0xFF4A7BFF),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'sleep_analysis'.tr,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF161618),
                        ),
                      ),
                      Obx(() {
                        final sleepData = controller.sleepData;
                        return Text(
                          '${sleepData['sleepTime']} - ${sleepData['wakeTime']}',
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8E8E93),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() {
                    final sleepData = controller.sleepData;
                    return Text(
                      sleepData['totalSleep'],
                      style: getTextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A7BFF),
                      ),
                    );
                  }),
                  Text(
                    'total_sleep'.tr,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // Sleep Stages Chart
          SizedBox(
            height: 163.h,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFE8E8E8),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 10,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('10:30PM', style: style);
                            break;
                          case 1:
                            text = const Text('12PM', style: style);
                            break;
                          case 2:
                            text = const Text('3PM', style: style);
                            break;
                          case 3:
                            text = const Text('4PM', style: style);
                            break;
                          case 4:
                            text = const Text('6PM', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: text,
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 4,
                minY: 0,
                maxY: 4,
                lineBarsData: [
                  // Deep Sleep Area
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 0),
                      FlSpot(0.5, 3.5),
                      FlSpot(1, 3.8),
                      FlSpot(1.5, 3.2),
                      FlSpot(2, 3.6),
                      FlSpot(2.5, 2.8),
                      FlSpot(3, 2.0),
                      FlSpot(3.5, 1.0),
                      FlSpot(4, 0),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4A7BFF).withValues(alpha: 0.8),
                        const Color(0xFF4A7BFF).withValues(alpha: 0.3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    barWidth: 0,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4A7BFF).withValues(alpha: 0.6),
                          const Color(0xFF4A7BFF).withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // REM Sleep Area (on top of deep sleep)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 0),
                      FlSpot(0.5, 2.5),
                      FlSpot(1, 2.8),
                      FlSpot(1.5, 2.2),
                      FlSpot(2, 2.6),
                      FlSpot(2.5, 2.0),
                      FlSpot(3, 1.4),
                      FlSpot(3.5, 0.7),
                      FlSpot(4, 0),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFB8C5FF).withValues(alpha: 0.8),
                        const Color(0xFFB8C5FF).withValues(alpha: 0.3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    barWidth: 0,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFB8C5FF).withValues(alpha: 0.4),
                          const Color(0xFFB8C5FF).withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Light Sleep Area (topmost layer)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 0),
                      FlSpot(0.5, 1.5),
                      FlSpot(1, 1.8),
                      FlSpot(1.5, 1.3),
                      FlSpot(2, 1.7),
                      FlSpot(2.5, 1.2),
                      FlSpot(3, 0.8),
                      FlSpot(3.5, 0.4),
                      FlSpot(4, 0),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFE3EAFF).withValues(alpha: 0.9),
                        const Color(0xFFE3EAFF).withValues(alpha: 0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    barWidth: 0,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE3EAFF).withValues(alpha: 0.3),
                          const Color(0xFFE3EAFF).withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        String sleepStage = '';
                        switch (barSpot.barIndex) {
                          case 0:
                            sleepStage = 'Deep Sleep';
                            break;
                          case 1:
                            sleepStage = 'REM Sleep';
                            break;
                          case 2:
                            sleepStage = 'Light Sleep';
                            break;
                        }
                        return LineTooltipItem(
                          sleepStage,
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Sleep Phases
          Obx(() {
            final sleepData = controller.sleepData;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0x338E8E93))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSleepPhase(
                    'Deep',
                    sleepData['deepSleep']['duration'],
                    const Color(0xFF4A7BFF),
                  ),
                  _buildSleepPhase(
                    'REM',
                    sleepData['remSleep']['duration'],
                    const Color(0xFFB8C5FF),
                  ),
                  _buildSleepPhase(
                    'Light',
                    sleepData['lightSleep']['duration'],
                    const Color(0xFFE3EAFF),
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 16.h),

          // Sleep Goal Achievement
          Obx(() {
            final sleepData = controller.sleepData;
            final goalMet = sleepData['goalMet'] as bool;

            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: goalMet
                    ? const Color(0xFFEBF9EE)
                    : const Color(0xFFFFF2E6),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: goalMet
                      ? const Color(0x8034C759)
                      : const Color(0x80FF9500),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    goalMet ? Icons.check_circle : Icons.info,
                    color: goalMet
                        ? const Color(0xFF34C759)
                        : const Color(0xFFFF9500),
                    size: 16,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      goalMet
                          ? 'You met your sleep goal!'
                          : 'Try to get more sleep tonight',
                      style: getTextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: goalMet
                            ? const Color(0xFF34C759)
                            : const Color(0xFFFF9500),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBloodOxygenCard() {
    final controller = Get.find<VitalSignsDetailsController>();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0x335ECFBC),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Image.asset(
                      'assets/icons/spO2.png',
                      height: 24.h,
                      width: 24.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'blood_oxygen'.tr,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF161618),
                        ),
                      ),
                      Text(
                        'spo2_levels'.tr,
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() {
                    final bloodOxygenData = controller.bloodOxygenData;
                    return Text(
                      '${bloodOxygenData['currentLevel']}%',
                      style: getTextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5ECFBC),
                      ),
                    );
                  }),
                  Text(
                    'current'.tr,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // Circular Chart with Center Text
          Obx(() {
            final bloodOxygenData = controller.bloodOxygenData;
            final currentLevel = bloodOxygenData['currentLevel'] as int;
            final percentage = currentLevel / 100.0;

            return SizedBox(
              height: 160.h,
              width: 160.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular Chart
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 50.w,
                      startDegreeOffset: -90,
                      sections: [
                        // Current oxygen level section
                        PieChartSectionData(
                          color: const Color(0xFF5ECFBC),
                          value: percentage * 100,
                          title: '',
                          radius: 25.w,
                          badgeWidget: null,
                        ),
                        // Remaining section
                        PieChartSectionData(
                          color: const Color(0xFFF0F0F0),
                          value: (1 - percentage) * 100,
                          title: '',
                          radius: 25.w,
                          badgeWidget: null,
                        ),
                      ],
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 800),
                    swapAnimationCurve: Curves.easeInOut,
                  ),
                  // Center Text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${bloodOxygenData['currentLevel']}%',
                        style: getTextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5ECFBC),
                        ),
                      ),
                      Text(
                        'SpO2',
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 32.h),

          // Stats Row
          Obx(() {
            final bloodOxygenData = controller.bloodOxygenData;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0x338E8E93))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Average',
                    '${bloodOxygenData['averageLevel']}%',
                  ),
                  _buildStatItem(
                    'Range',
                    '${bloodOxygenData['minLevel']}-${bloodOxygenData['maxLevel']}%',
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 16.h),

          // Health Status Indicator
          Obx(() {
            final bloodOxygenData = controller.bloodOxygenData;
            final isHealthy = bloodOxygenData['isHealthy'] as bool;

            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isHealthy
                    ? const Color(0xFFEBF9EE)
                    : const Color(0xFFFFF2E6),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isHealthy
                      ? const Color(0x8034C759)
                      : const Color(0x80FF9500),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isHealthy ? Icons.check_circle : Icons.warning,
                    color: isHealthy
                        ? const Color(0xFF34C759)
                        : const Color(0xFFFF9500),
                    size: 16,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      isHealthy
                          ? 'Normal range - Your oxygen levels are healthy'
                          : 'Below normal - Consider consulting a healthcare provider',
                      style: getTextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: isHealthy
                            ? const Color(0xFF34C759)
                            : const Color(0xFFFF9500),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAdditionalMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'additional_metrics'.tr,
          style: getTextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF161618),
          ),
        ),
        SizedBox(height: 24.h),
        _buildMetricRow(
          'heart_rate_variability'.tr,
          'assets/icons/spO2.png', // Correct asset path
          '42 ms',
          'recovery_indicator'.tr,
          'good'.tr,
          const Color(0xFF5ECFBC),
          const Color(0x335ECFBC),
        ),
        SizedBox(height: 12.h),
        _buildMetricRow(
          'body_temperature'.tr,
          'assets/icons/temperature.png', // Correct asset path
          '98.6 F',
          'skin_temperature'.tr,
          'normal'.tr,
          const Color(0xFFD46434),
          const Color(0x33D46434),
        ),
        SizedBox(height: 12.h),
        _buildMetricRow(
          'respiratory_rate'.tr,
          'assets/icons/respiratory.png', // Correct asset path
          '16 bpm',
          'breaths_per_minute'.tr,
          'normal'.tr,
          const Color(0xFF6F3FC3),
          const Color(0x336F3FC3),
        ),
      ],
    );
  }

  Widget _buildWeeklyTrends() {
    final controller = Get.find<VitalSignsDetailsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trends',
              style: getTextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF161618),
              ),
            ),
            Text(
              'view_all'.tr,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF34C759),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),

        // Dropdowns row for period and vital sign selection
        Row(
          children: [
            Expanded(child: _buildTrendPeriodDropdown(controller)),
            SizedBox(width: 12.w),
            Expanded(child: _buildVitalSignDropdown(controller)),
          ],
        ),
        SizedBox(height: 24.h),

        // Trend Chart
        _buildTrendChart(controller),
        SizedBox(height: 24.h),

        // Existing trend rows
        _buildTrendRow(
          'avg_heart_rate'.tr,
          'assets/icons/heart_rate.png',
          '74 bpm',
          'vs_last_week'.tr,
          '-2 bpm',
          const Color(0xFFFFC2BF),
          Icons.favorite,
        ),
        SizedBox(height: 12.h),
        _buildTrendRow(
          'daily_steps'.tr,
          'assets/icons/steps.png',
          '7,250',
          'vs_last_week'.tr,
          '+850',
          const Color(0xFFEBF9EE),
          Icons.directions_walk,
        ),
        SizedBox(height: 12.h),
        _buildTrendRow(
          'sleep_quality'.tr,
          'assets/icons/sleep.png',
          '7h 15m',
          'vs_last_week'.tr,
          '+30m',
          const Color(0xFFC7D6FF),
          Icons.bedtime,
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E8E93),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: getTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF161618),
          ),
        ),
      ],
    );
  }

  Widget _buildSleepPhase(String phase, String duration, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 8.w),
            Text(
              phase,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF8E8E93),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          duration,
          style: getTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF161618),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(
    String title,
    String iconsPath,
    String value,
    String subtitle,
    String status,
    Color valueColor,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Center(
              child: Image.asset(
                iconsPath,
                height: 24.h,
                width: 24.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF161618),
                  ),
                ),
                Text(
                  subtitle,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: getTextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              Text(
                status,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF34C759),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendPeriodDropdown(VitalSignsDetailsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedTrendPeriod,
            isExpanded: true,
            dropdownColor: Colors.white, // ✅ force white dropdown background
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF8E8E93),
            ),
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF161618),
            ),
            items: controller.trendPeriods.map((String period) {
              return DropdownMenuItem<String>(
                value: period,
                child: Text(
                  period,
                  style: getTextStyle(
                    // ✅ ensure black text
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF161618),
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.changeTrendPeriod(newValue);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVitalSignDropdown(VitalSignsDetailsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedVitalSign,
            isExpanded: true,
            dropdownColor: Colors.white, // ✅ force white dropdown background
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF8E8E93),
            ),
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF161618),
            ),
            items: controller.vitalSigns.map((String vitalSign) {
              return DropdownMenuItem<String>(
                value: vitalSign,
                child: Text(
                  vitalSign,
                  style: getTextStyle(
                    // ✅ ensure black text
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF161618),
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.changeVitalSign(newValue);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTrendChart(VitalSignsDetailsController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  '${controller.selectedVitalSign} Trend',
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF161618),
                  ),
                ),
              ),
              Obx(
                () => Text(
                  controller.selectedTrendPeriod,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Obx(
            () => SizedBox(
              height: 180.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFE8E8E8),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30.h,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final labels = _getTrendChartLabels(
                            controller.selectedTrendPeriod,
                          );
                          final index = value.toInt();
                          if (index >= 0 && index < labels.length) {
                            return Text(
                              labels[index],
                              style: getTextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF8E8E93),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _getYAxisInterval(
                          controller.selectedVitalSign,
                        ),
                        reservedSize: 50.w,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _getYAxisLabel(controller.selectedVitalSign, value),
                            style: getTextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF8E8E93),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: _getMinY(controller.selectedVitalSign),
                  maxY: _getMaxY(controller.selectedVitalSign),
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.currentTrendChartData,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A7BFF), Color(0xFF7B68EE)],
                      ),
                      barWidth: 3.w,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4.r,
                            color: const Color(0xFF4A7BFF),
                            strokeWidth: 2.w,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF4A7BFF).withValues(alpha: 0.3),
                            const Color(0xFF4A7BFF).withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipRoundedRadius: 8.r,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((LineBarSpot touchedSpot) {
                          return LineTooltipItem(
                            _getTooltipText(
                              controller.selectedVitalSign,
                              touchedSpot.y,
                            ),
                            getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getTrendChartLabels(String period) {
    switch (period) {
      case 'Daily':
        return ['6AM', '9AM', '12PM', '3PM', '6PM', '9PM', '12AM'];
      case 'Weekly':
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'Monthly':
        return ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'];
      case 'Yearly':
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
      default:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }
  }

  double _getMinY(String vitalSign) {
    switch (vitalSign) {
      case 'Heart Rate':
        return 65;
      case 'Steps':
        return 0;
      case 'Sleep':
        return 6;
      case 'Blood Oxygen':
        return 95;
      default:
        return 0;
    }
  }

  double _getMaxY(String vitalSign) {
    switch (vitalSign) {
      case 'Heart Rate':
        return 85;
      case 'Steps':
        return 10000;
      case 'Sleep':
        return 9;
      case 'Blood Oxygen':
        return 100;
      default:
        return 100;
    }
  }

  String _getTooltipText(String vitalSign, double value) {
    switch (vitalSign) {
      case 'Heart Rate':
        return '${value.toInt()} BPM';
      case 'Steps':
        return '${value.toInt()} steps';
      case 'Sleep':
        return '${value.toStringAsFixed(1)}h';
      case 'Blood Oxygen':
        return '${value.toInt()}%';
      default:
        return '${value.toInt()}';
    }
  }

  double _getYAxisInterval(String vitalSign) {
    switch (vitalSign) {
      case 'Heart Rate':
        return 5;
      case 'Steps':
        return 2000;
      case 'Sleep':
        return 1;
      case 'Blood Oxygen':
        return 1;
      default:
        return 5;
    }
  }

  String _getYAxisLabel(String vitalSign, double value) {
    switch (vitalSign) {
      case 'Heart Rate':
        return '${value.toInt()}';
      case 'Steps':
        return '${(value / 1000).toInt()}k';
      case 'Sleep':
        return '${value.toInt()}h';
      case 'Blood Oxygen':
        return '${value.toInt()}%';
      default:
        return '${value.toInt()}';
    }
  }

  Widget _buildTrendRow(
    String title,
    String iconsPath,
    String value,
    String subtitle,
    String change,
    Color bgColor,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Center(
              child: Image.asset(
                iconsPath,
                height: 24.h,
                width: 24.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF161618),
                  ),
                ),
                Text(
                  subtitle,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: getTextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF161618),
                ),
              ),
              Text(
                change,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF34C759),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
