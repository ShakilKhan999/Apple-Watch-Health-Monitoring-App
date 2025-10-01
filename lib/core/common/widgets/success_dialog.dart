import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/core/common/styles/global_text_style.dart';
import 'package:surajashray/core/common/widgets/customize_filled_button.dart';
import 'package:surajashray/core/utils/constants/colors.dart';

class SuccessDialog extends StatefulWidget {
  final String title;
  final String message;
  final String? animationPath;
  final VoidCallback? onConfirm;
  final String confirmText;
  final Duration? autoCloseDelay;
  final DialogType type;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.animationPath,
    this.onConfirm,
    this.confirmText = 'Continue',
    this.autoCloseDelay,
    this.type = DialogType.success,
  });

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

enum DialogType { success, error, info }

class _SuccessDialogState extends State<SuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _scaleController.forward();
    });

    // Auto close if delay is specified
    if (widget.autoCloseDelay != null) {
      Future.delayed(widget.autoCloseDelay!, () {
        if (mounted) {
          _closeDialog();
        }
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _closeDialog() {
    _scaleController.reverse().then((_) {
      _fadeController.reverse().then((_) {
        if (mounted) {
          Get.back();
          widget.onConfirm?.call();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Blurred background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),

            // Dialog content
            Center(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 32.w),
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
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
                          // Animation/Icon
                          _buildSuccessIcon(),

                          20.verticalSpace,

                          // Title
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.title,
                              style: getTextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          12.verticalSpace,

                          // Message
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.message,
                              style: getTextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          32.verticalSpace,

                          // Action button
                          _buildActionButton(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSuccessIcon() {
    if (widget.animationPath != null) {
      return Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: _getIconBackgroundColor().withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Center(
          child: Image.asset(
            widget.animationPath!,
            width: 60.w,
            height: 60.h,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Center(
        child: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: _getIconBackgroundColor(),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Icon(_getIcon(), color: Colors.white, size: 28.w),
        ),
      ),
    );
  }

  Color _getIconBackgroundColor() {
    switch (widget.type) {
      case DialogType.success:
        return const Color(0xFF34C759);
      case DialogType.error:
        return const Color(0xFFFF3B30);
      case DialogType.info:
        return const Color(0xFF007AFF);
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case DialogType.success:
        return Icons.check;
      case DialogType.error:
        return Icons.close;
      case DialogType.info:
        return Icons.info;
    }
  }

  Widget _buildActionButton() {
    return CustomFilledButton(
      text: widget.confirmText,
      onPressed: _closeDialog,
      // height: 30.h,
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
    );
  }
}

// Helper function to show the success dialog
void showSuccessDialog({
  required String title,
  required String message,
  String? animationPath,
  VoidCallback? onConfirm,
  String confirmText = 'Continue',
  Duration? autoCloseDelay,
  DialogType type = DialogType.success,
}) {
  Get.dialog(
    SuccessDialog(
      title: title,
      message: message,
      animationPath: animationPath,
      onConfirm: onConfirm,
      confirmText: confirmText,
      autoCloseDelay: autoCloseDelay,
      type: type,
    ),
    barrierDismissible: false,
    barrierColor: Colors.transparent,
  );
}

// Helper functions for specific dialog types
void showErrorDialog({
  required String title,
  required String message,
  VoidCallback? onConfirm,
  String confirmText = 'Try Again',
}) {
  showSuccessDialog(
    title: title,
    message: message,
    onConfirm: onConfirm,
    confirmText: confirmText,
    type: DialogType.error,
  );
}

void showInfoDialog({
  required String title,
  required String message,
  VoidCallback? onConfirm,
  String confirmText = 'OK',
}) {
  showSuccessDialog(
    title: title,
    message: message,
    onConfirm: onConfirm,
    confirmText: confirmText,
    type: DialogType.info,
  );
}
