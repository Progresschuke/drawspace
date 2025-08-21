import 'package:drawspace/presentation/styles/app_colors.dart';
import 'package:flutter/material.dart';

class BrushModel {
  final double? strokeWidth;
  final Color? color;

  BrushModel({this.strokeWidth = 5.0, this.color = AppColors.black});

  BrushModel copyWith({double? strokeWidth, Color? color}) {
    return BrushModel(
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
    );
  }
}
