import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/constants/icon_path.dart';
import 'package:surajashray/features/home/controllers/lab_report_analysis_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabReportAnalysisScreen extends StatelessWidget {
  final String reportId;
  const LabReportAnalysisScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final LabReportAnalysisController controller = Get.put(
      LabReportAnalysisController(reportId: reportId),
    );

    return CommonBackgroundScaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              10.h.verticalSpace,
              _buildHeaderSection(),
              _buildTitleSection(),
              16.verticalSpace,
              _buildStatusSection(), // Removed the padding here
              16.verticalSpace,
              // Scrollable area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHealthSummarySection(controller),
                      25.verticalSpace,
                      _buildDetailedAnalysisSection(controller),
                      25.verticalSpace,
                      _buildHealthTrendSection(controller),
                      25.verticalSpace,
                      _buildRecommendationsSection(controller),
                      25.verticalSpace,
                      _buildRiskAssessmentSection(controller),
                      25.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() => Align(
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      onTap: () => Get.back(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 24.w,
          color: AppColors.textSecondary,
        ),
      ),
    ),
  );

  Widget _buildTitleSection() => Column(
    children: [
      Text(
        'lab_report_analysis'.tr,
        style: getTextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      4.verticalSpace,
      Text(
        'comprehensive_health_overview'.tr,
        style: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),
    ],
  );

  Widget _buildStatusSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(color: AppColors.primary),
      child: Row(
        children: [
          Text(
            'status_label'.tr,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          Text(
            'complete'.tr,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            'updated_label'.tr,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          Text(
            "Sep 12, 2025",
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSummarySection(LabReportAnalysisController c) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.r), // only top corners rounded
        ),
      ),
      child: Column(
        children: [
          // Thin blue top border line
          Container(
            height: 6.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(100.r)),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text(
                  'your_health_summary'.tr,
                  style: getTextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                20.h.verticalSpace,

                Obx(
                  () => Text(
                    c.summaryText.value,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                40.h.verticalSpace,
                Text(
                  'overall_health_score'.tr,
                  style: getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                20.verticalSpace,

                Obx(
                  () => Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 100.w,
                        width: 100.w,
                        child: CircularProgressIndicator(
                          value: c.healthScore.value / 100,
                          strokeWidth: 25.w,
                          color: AppColors.primary,
                          backgroundColor: Color.fromARGB(255, 189, 205, 255),
                        ),
                      ),
                      Text(
                        "${c.healthScore.value}%",
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                20.verticalSpace,
                Text(
                  'good_health_improvement'.tr,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedAnalysisSection(LabReportAnalysisController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('detailed_analysis'.tr),
        8.verticalSpace,

        // Obx(
        //   () => Column(
        //     children: c.detailedAnalysis
        //         .map(
        //           (item) => Card(
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(12.r),
        //             ),
        //             child: ListTile(
        //               title: Text(
        //                 item["title"]!,
        //                 style: getTextStyle(
        //                   fontWeight: FontWeight.w500,
        //                   fontSize: 18.sp,
        //                   color: Colors.black,
        //                 ),
        //               ),
        //               subtitle: Text(
        //                 item["condition"]!,
        //                 style: getTextStyle(
        //                   color: Colors.black,
        //                   fontSize: 14.sp,
        //                   fontWeight: FontWeight.w400,
        //                 ),
        //               ),
        //               trailing: Text(
        //                 item["value"]!,
        //                 style: getTextStyle(
        //                   fontSize: 14.sp,
        //                   fontWeight: FontWeight.w700,
        //                   color: AppColors.primary,
        //                 ),
        //               ),

        //             ),
        //           ),
        //         )
        //         .toList(),
        //   ),
        // ),
        Obx(
          () => Column(
            children: c.detailedAnalysis.map((item) {
              final title = item["title"] ?? 'unknown_title'.tr;
              final condition = item["condition"] ?? "";
              final value = item["value"] ?? "";
              final note = item["note"] ?? "";

              return Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Title
                      Text(
                        title,
                        style: getTextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: Colors.black,
                        ),
                      ),
                      6.verticalSpace,

                      // Row 2: Condition + Spacer + Value
                      Row(
                        children: [
                          Text(
                            condition,
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            value,
                            style: getTextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      6.verticalSpace,

                      // Row 3: Note
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (note.isNotEmpty)
                            Text(
                              "•",
                              style: getTextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFFF3B30),
                              ),
                            ),
                          if (note.isNotEmpty) 5.w.horizontalSpace,
                          Text(
                            note,
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFFF3B30),
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthTrendSection(LabReportAnalysisController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('health_trends'.tr),
        8.verticalSpace,
        Obx(
          () => Column(
            children: c.healthTrends
                .map(
                  (item) => Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.trending_up,
                        color: item["status"] == "Increasing"
                            ? const Color.fromARGB(255, 244, 67, 54)
                            : item["status"] == "Stable"
                            ? const Color.fromARGB(255, 76, 175, 80)
                            : const Color.fromARGB(255, 255, 152, 0),
                      ),
                      title: Text(
                        item["title"]!,
                        style: getTextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                      subtitle: Text(
                        item["note"]!,
                        style: getTextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: Text(
                        item["status"]!,
                        style: getTextStyle(
                          fontWeight: FontWeight.w700,
                          color: item["status"] == "Increasing"
                              ? const Color.fromARGB(255, 244, 67, 54)
                              : AppColors.green,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  // Widget _buildRecommendationsSection(LabReportAnalysisController c) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _sectionHeader("Personalized Recommendations"),
  //       8.verticalSpace,
  //       Obx(
  //         () => Card(
  //           color: Colors.orange.shade50,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //           ),
  //           child: Padding(
  //             padding: EdgeInsets.all(16.w),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: c.recommendations
  //                   .map(
  //                     (r) => Padding(
  //                       padding: EdgeInsets.only(bottom: 8.h),
  //                       child: Text(
  //                         "• $r",
  //                         style: getTextStyle(
  //                           fontSize: 14.sp,
  //                           color: AppColors.textSecondary,
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                   .toList(),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildRecommendationsSection(LabReportAnalysisController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.verticalSpace,
        Obx(
          () => Card(
            color: Color(0xFFFFF9F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(color: Color(0xFFD46434)),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Icon + Title
                  Row(
                    children: [
                      SvgPicture.asset(
                        IconPath.recommendation,
                        width: 24.w,
                        height: 24.w,
                        // color: AppColors.primary,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Text(
                          'personalized_recommendations'.tr,
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,

                  // Row 2: Subtitle
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      'recommendation_subtitle'.tr,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        lineHeight: 19.sp,
                      ),
                    ),
                  ),
                  12.verticalSpace,

                  // Row 3: Recommendation items
                  ...c.recommendations.map((r) {
                    return Padding(
                      padding: EdgeInsets.only(left: 25.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppColors.grey,
                          ),
                          8.horizontalSpace,

                          Expanded(
                            child: Text(
                              r,
                              style: getTextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskAssessmentSection(LabReportAnalysisController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('health_risk_assessment'.tr),
        8.verticalSpace,
        Obx(
          () => Column(
            children: c.riskAssessment
                .map(
                  (risk) => Card(
                    elevation: 0,
                    color: risk["level"] == "Moderate"
                        ? Color(0xFFFFF5F5)
                        : Color(0xFFEFF9F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: risk["level"] == "Moderate"
                            ? Color(0xFFFF3B30)
                            : Color(0xFF34C759),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            risk["title"]!,
                            style: getTextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          6.verticalSpace,
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              risk["description"]!,
                              style: getTextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w400,
                                lineHeight: 19.sp,
                              ),
                            ),
                          ),
                          8.verticalSpace,
                          Row(
                            children: [
                              Text(
                                'risk_level_label'.tr,
                                style: getTextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                              ),
                              7.w.horizontalSpace,
                              ..._buildRiskDots(risk["level"]),
                              7.w.horizontalSpace,
                              Text(
                                "${risk["level"]}",
                                style: getTextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRiskDots(String? level) {
    Color activeColor = AppColors.green;
    int activeCount = 1;

    if (level == "Moderate") {
      activeColor = Colors.red;
      activeCount = 2;
    }

    return List.generate(3, (i) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Text(
          "•",
          style: getTextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
            color: i < activeCount ? activeColor : AppColors.grey,
          ),
        ),
      );
    });
  }

  Widget _sectionHeader(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        8.w.horizontalSpace,
        Text(
          'view_all'.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.green,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
