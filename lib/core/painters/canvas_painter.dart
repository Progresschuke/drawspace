import 'package:drawspace/core/enums/enums.dart';
import 'package:drawspace/core/models/sketch_model.dart';
import 'package:flutter/material.dart';

class CanvasPainter extends CustomPainter {
  final List<SketchModel> sketches;
  final Color color;
  final double strokeWidth;

  CanvasPainter({
    required this.sketches,
    required this.color,
    this.strokeWidth = 4.0,
  });
  @override
  void paint(Canvas canvas, Size size) {
    for (SketchModel sketch in sketches) {
      final paint = Paint()
        ..color = sketch.color
        ..strokeWidth = sketch.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      Path path = Path();
      final points = sketch.points;
      path.moveTo(points.first.dx, points.first.dy);

      if (sketch.sketchMode == CanvasSketchMode.line) {
        Offset firstPoint = points.first;
        Offset lastPoint = points.last;
        canvas.drawLine(firstPoint, lastPoint, paint);
      } else if (sketch.sketchMode == CanvasSketchMode.draw) {
        for (int i = 1; i < points.length - 1; ++i) {
          final p0 = points[i];
          final p1 = points[i + 1];

          path.quadraticBezierTo(
            p0.dx,
            p0.dy,
            (p0.dx + p1.dx) / 2,
            (p0.dy + p1.dy) / 2,
          );
        }
        canvas.drawPath(path, paint);
      } else if (sketch.sketchMode == CanvasSketchMode.rect) {
        if (points.length >= 2) {
          final rect = Rect.fromPoints(points.first, points.last);
          canvas.drawRect(rect, paint);
        }
      } else if (sketch.sketchMode == CanvasSketchMode.angle) {
        if (points.length >= 2) {
          final center = points.first;
          final radius = (points.last - center).distance;
          canvas.drawCircle(center, radius, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//----Using "LineTo" to draw-----//
// class CanvasPainter extends CustomPainter {
//   final SketchModel sketch;
//   final Color color;
//   final double strokeWidth;

//   CanvasPainter({
//     required this.sketch,
//     required this.color,
//     this.strokeWidth = 4.0,
//   });
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;
//     Path path = Path();

//     final points = sketch.points;
//     path.moveTo(points.first.dx, points.first.dy);

//     for (int i = 1; i < points.length - 1; ++i) {
//       final p0 = points[i];
//       final p1 = points[i + 1];
//       path.lineTo((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
//     }

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
