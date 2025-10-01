import 'package:flutter/material.dart';

class OutsideCurveContainer extends StatelessWidget {
  const OutsideCurveContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: CustomPaint(
          size: const Size(300, 200), // container size
          painter: OutsideCurvePainter(),
        ),
      ),
    );
  }
}

class OutsideCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start top-left
    path.moveTo(0, 0);

    // Top edge
    path.lineTo(size.width, 0);

    // Right edge
    path.lineTo(size.width, size.height - 50);

    // Bottom curve (outward)
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 50, // control point (outside bulge)
      0,
      size.height - 50, // end point
    );

    // Left edge
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() {
  runApp(const MaterialApp(home: OutsideCurveContainer()));
}
