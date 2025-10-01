// Sleep Analysis Card - Using Controller Data
import 'dart:math';
import 'package:flutter/material.dart';

// Custom painter for functional semi-circular progress indicator
class SemiCircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  SemiCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = (size.width / 2) - (strokeWidth / 2);

    // Background arc (full semicircle)
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(center: center, width: radius * 2, height: radius * 2),
      3.14159, // Start from left (π radians = 180°)
      3.14159, // Sweep 180 degrees (π radians)
      false,
      backgroundPaint,
    );

    // Progress arc (filled portion)
    final progressPaint = Paint()
      ..shader =
          LinearGradient(
            colors: [progressColor.withValues(alpha: 0.7), progressColor],
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
          ).createShader(
            Rect.fromCenter(
              center: center,
              width: radius * 2,
              height: radius * 2,
            ),
          )
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Calculate progress angle (max 180°)
    final progressAngle = 3.14159 * progress;

    canvas.drawArc(
      Rect.fromCenter(center: center, width: radius * 2, height: radius * 2),
      3.14159, // Start from left (π radians = 180°)
      progressAngle, // Progress amount
      false,
      progressPaint,
    );

    // Draw progress indicator dot
    if (progress > 0) {
      final indicatorAngle = 3.14159 + progressAngle;
      final indicatorX = center.dx + radius * cos(indicatorAngle);
      final indicatorY = center.dy + radius * sin(indicatorAngle);

      final indicatorPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(indicatorX, indicatorY),
        strokeWidth / 2 + 2,
        indicatorPaint,
      );

      // White center for indicator dot
      final indicatorCenterPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(indicatorX, indicatorY),
        strokeWidth / 2 - 2,
        indicatorCenterPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
