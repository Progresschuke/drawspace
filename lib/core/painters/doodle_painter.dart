import 'package:flutter/material.dart';

class DoodlePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DoodlePainter({required this.color, this.strokeWidth = 4.0});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Path path = Path()
      ..moveTo(size.width / 2, 88)
      ..quadraticBezierTo(size.width / 2 + 17, 65, size.width / 2 + 20, 100)
      ..quadraticBezierTo(size.width / 2 + 20, 150, size.width / 2 + 38, 130)
      ..quadraticBezierTo(size.width / 2 + 47, 110, size.width / 2 + 50, 110)
      ..quadraticBezierTo(size.width / 2 + 60, 110, size.width / 2 + 60, 130);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
