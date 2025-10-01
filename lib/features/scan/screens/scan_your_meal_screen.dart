import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/features/scan/controllers/scan_screen_controller.dart';

class ScanYourMealScreen extends StatefulWidget {
  const ScanYourMealScreen({super.key});

  @override
  State<ScanYourMealScreen> createState() => _ScanYourMealScreenState();
}

class _ScanYourMealScreenState extends State<ScanYourMealScreen>
    with WidgetsBindingObserver {
  late ScanScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ScanScreenController());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.isCameraInitialized) return;

    switch (state) {
      case AppLifecycleState.inactive:
        controller.pauseCamera();
        break;
      case AppLifecycleState.resumed:
        controller.resumeCamera();
        break;
      case AppLifecycleState.paused:
        controller.pauseCamera();
        break;
      case AppLifecycleState.detached:
        controller.pauseCamera();
        break;
      case AppLifecycleState.hidden:
        controller.pauseCamera();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(controller),

            // Title
            _buildTitle(),

            // Camera Preview Area
            Expanded(child: _buildCameraArea(controller)),
            24.verticalSpace,
            // Bottom Action Buttons
            _buildBottomActions(controller),

            124.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ScanScreenController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          const Spacer(),
          // Resolution settings button
          GestureDetector(
            onTap: () => _showResolutionSelector(controller),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFF8E8E93).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.settings,
                    size: 16.w,
                    color: const Color(0xFF8E8E93),
                  ),
                  4.horizontalSpace,
                  Obx(
                    () => Text(
                      controller.resolutionDisplayName,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF8E8E93),
                      ),
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

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          16.verticalSpace,
          Text(
            'scan_your_meal'.tr,
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

  Widget _buildCameraArea(ScanScreenController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.grey.shade300,
        ),
        child: Stack(
          children: [
            // Live camera preview or loading indicator
            Obx(() => _buildCameraPreview(controller)),

            // Corner frames (matching Figma design)
            _buildCornerFrame(top: 21.h, left: 15.w, isTopLeft: true),
            _buildCornerFrame(top: 21.h, right: 15.w, isTopRight: true),
            _buildCornerFrame(bottom: 21.h, left: 15.w, isBottomLeft: true),
            _buildCornerFrame(bottom: 21.h, right: 15.w, isBottomRight: true),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview(ScanScreenController controller) {
    if (controller.isLoading && !controller.isCameraInitialized) {
      // Show loading indicator while camera is initializing
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.black,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF34C759)),
              16.verticalSpace,
              Text(
                'initializing_camera'.tr,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!controller.isCameraInitialized ||
        controller.cameraController == null) {
      // Show fallback option if camera is not available
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.grey.shade200,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 48.w,
                color: Colors.grey.shade600,
              ),
              16.verticalSpace,
              Text(
                'camera_preview_not_available'.tr,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                'use_camera_or_gallery_buttons'.tr,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Show live camera preview
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.cameraController!.value.previewSize?.height ?? 1,
            height: controller.cameraController!.value.previewSize?.width ?? 1,
            child: CameraPreview(controller.cameraController!),
          ),
        ),
      ),
    );
  }

  Widget _buildCornerFrame({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool isTopLeft = false,
    bool isTopRight = false,
    bool isBottomLeft = false,
    bool isBottomRight = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: SizedBox(
        width: 50.w,
        height: 50.w,
        child: CustomPaint(
          painter: CornerFramePainter(
            isTopLeft: isTopLeft,
            isTopRight: isTopRight,
            isBottomLeft: isBottomLeft,
            isBottomRight: isBottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(ScanScreenController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gallery button
          _buildActionButton(
            icon: Icons.photo_library_outlined,
            onTap: controller.onPickFromGalleryPressed,
            backgroundColor: const Color(0xFF8E8E93).withValues(alpha: 0.1),
            iconColor: const Color(0xFF8E8E93),
          ),

          30.horizontalSpace, // Space between buttons
          // Camera capture button (main action)
          Obx(() => _buildMainCaptureButton(controller)),

          30.horizontalSpace, // Space between buttons
          // Switch camera button
          _buildActionButton(
            icon: Icons.flip_camera_ios_outlined,
            onTap: controller.onSwitchCameraPressed,
            backgroundColor: const Color(0xFF8E8E93).withValues(alpha: 0.1),
            iconColor: const Color(0xFF8E8E93),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return Container(
      width: 70.w, // Touch area - larger than visual
      height: 70.w, // Touch area - larger than visual
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Add haptic feedback
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(35.r),
          splashColor: const Color(0xFF8E8E93).withValues(alpha: 0.3),
          highlightColor: const Color(0xFF8E8E93).withValues(alpha: 0.2),
          splashFactory: InkSparkle.splashFactory,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 60.w, // Original visual size
              height: 60.w, // Original visual size
              decoration: BoxDecoration(
                color:
                    backgroundColor ??
                    const Color(0xFF8E8E93).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withValues(alpha: 0.1),
                    blurRadius: 4.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 20.w, // Original icon size
                  color: iconColor ?? const Color(0xFF8E8E93),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCaptureButton(ScanScreenController controller) {
    return Container(
      width: 110.w, // Touch area - slightly larger than visual
      height: 110.w, // Touch area - slightly larger than visual
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.isLoading
              ? null
              : () {
                  // Add strong haptic feedback for main action
                  HapticFeedback.mediumImpact();
                  controller.onTakePhotoPressed();
                },
          borderRadius: BorderRadius.circular(55.r),
          splashColor: const Color(0xFF34C759).withValues(alpha: 0.3),
          highlightColor: const Color(0xFF34C759).withValues(alpha: 0.2),
          splashFactory: InkSparkle.splashFactory,
          child: Center(
            child: AnimatedScale(
              scale: controller.isLoading ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: 100.w, // Original visual size
                height: 100.w, // Original visual size
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF34C759),
                    width: 8.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF34C759).withValues(alpha: 0.25),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                    BoxShadow(
                      color: const Color(0xFF000000).withValues(alpha: 0.1),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Center(
                  child: controller.isLoading
                      ? SizedBox(
                          width: 28.w,
                          height: 28.w,
                          child: const CircularProgressIndicator(
                            color: Color(0xFF34C759),
                            strokeWidth: 3,
                          ),
                        )
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.camera_alt,
                            size: 36.w, // Original icon size
                            color: const Color(0xFF34C759),
                            key: ValueKey(controller.isLoading),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showResolutionSelector(ScanScreenController controller) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Title
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Text(
                'camera_resolution'.tr,
                style: getTextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF161618),
                ),
              ),
            ),

            // Current resolution info
            if (controller.isCameraInitialized)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34C759).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'current_preview_size'.tr,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF34C759),
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        controller.getCurrentResolutionInfo(),
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF34C759),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            16.verticalSpace,

            // Resolution options
            ...controller.availableResolutions
                .map((option) => _buildResolutionOption(controller, option))
                .toList(),

            24.verticalSpace,
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildResolutionOption(
    ScanScreenController controller,
    dynamic option,
  ) {
    final isSelected = controller.currentResolution == option.preset;

    return GestureDetector(
      onTap: () {
        controller.changeResolution(option.preset);
        Get.back();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF34C759).withValues(alpha: 0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF34C759) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.displayName,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF34C759)
                          : const Color(0xFF161618),
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    option.resolution,
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: isSelected
                          ? const Color(0xFF34C759)
                          : const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFF34C759),
                size: 20.w,
              ),
          ],
        ),
      ),
    );
  }
}

class CornerFramePainter extends CustomPainter {
  final bool isTopLeft;
  final bool isTopRight;
  final bool isBottomLeft;
  final bool isBottomRight;

  CornerFramePainter({
    this.isTopLeft = false,
    this.isTopRight = false,
    this.isBottomLeft = false,
    this.isBottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5F5F7)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cornerLength = size.width * 0.6;

    if (isTopLeft) {
      // Top horizontal line
      canvas.drawLine(const Offset(0, 0), Offset(cornerLength, 0), paint);
      // Left vertical line
      canvas.drawLine(const Offset(0, 0), Offset(0, cornerLength), paint);
    }

    if (isTopRight) {
      // Top horizontal line
      canvas.drawLine(
        Offset(size.width - cornerLength, 0),
        Offset(size.width, 0),
        paint,
      );
      // Right vertical line
      canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width, cornerLength),
        paint,
      );
    }

    if (isBottomLeft) {
      // Bottom horizontal line
      canvas.drawLine(
        Offset(0, size.height),
        Offset(cornerLength, size.height),
        paint,
      );
      // Left vertical line
      canvas.drawLine(
        Offset(0, size.height - cornerLength),
        Offset(0, size.height),
        paint,
      );
    }

    if (isBottomRight) {
      // Bottom horizontal line
      canvas.drawLine(
        Offset(size.width - cornerLength, size.height),
        Offset(size.width, size.height),
        paint,
      );
      // Right vertical line
      canvas.drawLine(
        Offset(size.width, size.height - cornerLength),
        Offset(size.width, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
