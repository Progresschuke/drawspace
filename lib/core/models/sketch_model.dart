import 'package:drawspace/core/enums/enums.dart';
import 'package:drawspace/presentation/styles/app_colors.dart';
import 'package:flutter/widgets.dart';

class SketchModel {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final CanvasSketchMode sketchMode;

  SketchModel({
    required this.points,
    this.color = AppColors.primary,
    this.strokeWidth = 5,
    this.sketchMode = CanvasSketchMode.draw,
  });

  toMap() {}

  static fromMap(Map<String, dynamic> map) {}
}
