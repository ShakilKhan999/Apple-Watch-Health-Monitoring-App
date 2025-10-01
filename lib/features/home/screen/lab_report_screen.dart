import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/common_background.dart';
import 'package:surajashray/core/models/lab_report_model.dart';
import 'package:surajashray/core/utils/constants/colors.dart';
import 'package:surajashray/core/utils/formatters/app_formatters.dart';
import 'package:surajashray/features/home/controllers/lab_report_controller.dart';

class LabReportScreen extends StatelessWidget {
  const LabReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LabReportController controller = Get.put(LabReportController());

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
              // Scrollable area starts here
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildUpReportSection(controller),
                        16.verticalSpace,
                        _buildGuideSection(),
                        12.verticalSpace,
                        _buildRecentUpSection(controller),
                        16.verticalSpace,
                      ],
                    ),
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
        "upload_lab_reports".tr,
        style: getTextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      4.verticalSpace,
      Text(
        "upload_latest_medical_results".tr,
        style: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );

  Widget _buildUpReportSection(LabReportController controller) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(12.r),
      dashPattern: const [6, 6],
      strokeWidth: 1,
      color: AppColors.primary,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.cloud_upload_outlined,
                size: 28.sp,
                color: Colors.white,
              ),
            ),
            12.h.verticalSpace,
            Text(
              "upload_new_report".tr,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            4.h.verticalSpace,
            Text(
              "tap_select_files_photo".tr,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            16.h.verticalSpace,

            Obx(() {
              final uploading = controller.isUploading.value;
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 140.w,
                      maxWidth: 200.w,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: uploading
                          ? null
                          : () => controller.pickFiles(),
                      icon: const Icon(Icons.folder_open),
                      label: uploading
                          ? SizedBox(
                              height: 16.h,
                              width: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text("choose_files".tr),
                      style:
                          ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 16.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ).copyWith(
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            side: WidgetStateProperty.all(BorderSide.none),
                          ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 140.w,
                      maxWidth: 200.w,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: uploading
                          ? null
                          : () => controller.takePhoto(),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: uploading
                          ? SizedBox(
                              height: 16.h,
                              width: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text("take_photo".tr),
                      style:
                          ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 16.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ).copyWith(
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            side: WidgetStateProperty.all(BorderSide.none),
                          ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 10.r,
              backgroundColor: AppColors.primary,
              child: Text(
                'i',
                style: getTextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            8.horizontalSpace,
            Text(
              "upload_guidelines".tr,
              style: getTextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
        8.verticalSpace,
        Padding(
          padding: EdgeInsets.only(left: 14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bulletText("supported_formats_pdf_jpg_png".tr),
              _bulletText("maximum_file_size_10mb".tr),
              _bulletText("ensure_reports_clear_readable".tr),
              _bulletText("multiple_files_uploaded_once".tr),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bulletText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•  ",
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentUpSection(LabReportController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "recent_uploads".tr,
              style: getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            Obx(() {
              final expanded = controller.isExpanded.value;
              return GestureDetector(
                onTap: () => controller.isExpanded.toggle(),
                child: Text(
                  expanded ? "view_less".tr : "view_all".tr,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              );
            }),
          ],
        ),
        12.verticalSpace,
        Obx(() {
          final list = controller.recentReports;
          if (list.isEmpty) {
            return Center(
              child: Text("no_uploads_yet".tr, style: getTextStyle()),
            );
          }

          // show either 2 items or full list depending on isExpanded
          final showList = controller.isExpanded.value
              ? list
              : list.take(2).toList();

          return ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: showList.length,
            separatorBuilder: (_, __) => SizedBox(height: 5.h),
            itemBuilder: (context, index) {
              final r = showList[index];
              return _recentCard(r, controller);
            },
          );
        }),
      ],
    );
  }

  Widget _recentCard(LabReportModel report, LabReportController controller) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 12.h, right: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Icon + Title
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: report.extension.toLowerCase() == 'pdf'
                        ? Color(0xFFC7D6FF)
                        : const Color.fromARGB(255, 243, 229, 245),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Center(
                    child: Icon(
                      report.extension.toLowerCase() == 'pdf'
                          ? Icons.picture_as_pdf
                          : Icons.image,
                      color: report.extension.toLowerCase() == 'pdf'
                          ? AppColors.primary
                          : const Color.fromARGB(255, 151, 37, 171),
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    report.title,
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text(
                "${"uploaded_on".tr} ${AppForMatters.formatDateTimeVerbose(report.uploadedAt)} \n${report.extension.toUpperCase()} • ${AppForMatters.formatFileSize(report.sizeInBytes)}",
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => controller.viewReport(report),
                  // onPressed: () => controller.viewReport(report),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "view".tr,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => controller.deleteReport(report),
                  child: Text(
                    "delete".tr,
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 244, 67, 54),
                    ),
                  ),
                ),
                // SizedBox(
                //   // height: 30.h,
                //   child: ElevatedButton(
                //     onPressed: () => controller.viewReport(report),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.green,
                //       foregroundColor: Colors.white,
                //       padding: EdgeInsets.symmetric(horizontal: 20.w),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8.r),
                //       ),
                //       textStyle: getTextStyle(
                //         fontSize: 12.sp,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //     child: const Text("View"),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
