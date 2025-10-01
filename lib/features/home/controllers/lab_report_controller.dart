import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/models/lab_report_model.dart';
import 'package:surajashray/routes/app_routes.dart';

class LabReportController extends GetxController {
  final recentReports = <LabReportModel>[].obs;
  final isUploading = false.obs;
  final isLoading = false.obs;
  final isExpanded = false.obs;

  // validation rules
  final int maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB
  final List<String> allowedExt = ['pdf', 'jpg', 'jpeg', 'png'];

  @override
  void onInit() {
    super.onInit();
    _loadFakeReports();
  }

  void _loadFakeReports() {
    // add a couple of fake items for the UI
    recentReports.assignAll([
      LabReportModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "lab_complete_blood_count".tr,
        filename: "cbc_report.pdf",
        sizeInBytes: 2 * 1024 * 1024,
        uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
        filePath: "", // no local path for fake
        extension: "pdf",
      ),
      LabReportModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        title: "lab_chest_xray".tr,
        filename: "chest_xray.jpg",
        sizeInBytes: 5 * 1024 * 1024,
        uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
        filePath: "",
        extension: "jpg",
      ),
    ]);
  }

  Future<void> pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: allowedExt,
      );

      if (result == null || result.files.isEmpty) return;

      for (final picked in result.files) {
        if (picked.path == null) continue;
        final file = File(picked.path!);
        final ok = _validateFile(file);
        if (!ok) continue;
        await uploadFile(file);
      }
    } catch (e) {
      Get.snackbar("error".tr, "lab_failed_pick_files".tr + ": $e");
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo == null) return;
      final file = File(photo.path);
      final ok = _validateFile(file);
      if (!ok) return;
      await uploadFile(file);
    } catch (e) {
      Get.snackbar("error".tr, "lab_camera_error".tr + ": $e");
    }
  }

  bool _validateFile(File file) {
    final ext = p.extension(file.path).replaceFirst('.', '').toLowerCase();
    final size = file.lengthSync();
    if (!allowedExt.contains(ext)) {
      Get.snackbar(
        "lab_unsupported_format".tr,
        "lab_allowed_formats".tr + ": ${allowedExt.join(', ')}",
      );
      return false;
    }
    if (size > maxFileSizeBytes) {
      Get.snackbar("lab_file_too_large".tr, "lab_max_file_size".tr);
      return false;
    }
    return true;
  }

  Future<void> uploadFile(File file) async {
    try {
      isUploading.value = true;

      // simulate network/upload latency
      await Future.delayed(const Duration(seconds: 1));

      // create model
      final ext = p.extension(file.path).replaceFirst('.', '').toLowerCase();
      final filename = p.basename(file.path);
      final title = _titleFromFileName(filename);
      final model = LabReportModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        filename: filename,
        sizeInBytes: file.lengthSync(),
        uploadedAt: DateTime.now(),
        filePath: file.path,
        extension: ext,
      );

      // insert at top of list
      recentReports.insert(0, model);

      Get.snackbar(
        "lab_uploaded".tr,
        "$filename " + "lab_uploaded_successfully".tr,
      );
    } catch (e) {
      Get.snackbar("lab_upload_failed".tr, e.toString());
    } finally {
      isUploading.value = false;
    }
  }

  String _titleFromFileName(String filename) {
    final name = filename.split('.').first;
    // simple: replace underscores with spaces and capitalize
    return name
        .replaceAll('_', ' ')
        .splitMapJoin(
          RegExp(r'\b\w'),
          onMatch: (m) => m.group(0)!.toUpperCase(),
          onNonMatch: (n) => n,
        );
  }

  Future<void> deleteReport(LabReportModel report) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "lab_delete_report".tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          "lab_delete_confirmation".tr.replaceAll("{title}", report.title),
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              "cancel".tr,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              "delete".tr,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 244, 67, 54),
              ),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      recentReports.removeWhere((r) => r.id == report.id);
      Get.snackbar("Deleted", "${report.title} removed");
    }
  }

  Future<void> viewReport(LabReportModel report) async {
    // For now, we just show a simple preview dialog.
    // Later: open file with open_file_plus or navigate to a PDF/Image viewer.
    // Get.dialog(
    //   AlertDialog(
    //     backgroundColor: Colors.white,
    //     title: Text(report.title),
    //     content: SizedBox(
    //       width: double.maxFinite,
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Text(report.filename),
    //           const SizedBox(height: 8),
    //           Text("Size: ${AppForMatters.formatFileSize(report.sizeInBytes)}"),
    //           const SizedBox(height: 8),
    //           Text("Uploaded: ${report.uploadedAt}"),
    //         ],
    //       ),
    //     ),
    //     actions: [
    //       TextButton(onPressed: () => Get.back(), child: const Text("Close")),
    //     ],
    //   ),
    // );

    // Get.to(LabReportAnalysisScreen(reportId: report.id));
    Get.toNamed(
      AppRoute.labReportAnalysisScreen,
      arguments: {"reportId": report.id},
    );
  }
}
