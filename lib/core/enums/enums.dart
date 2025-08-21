import 'package:flutter/material.dart';

enum CanvasTools {
  brush(title: "Brush", icon: Icons.draw_outlined),
  eraser(title: "Eraser", icon: Icons.style),
  line(title: "Line", icon: Icons.horizontal_rule),
  rect(title: "Rect", icon: Icons.crop_din),
  // angle(title: "Angle", icon: Icons.change_history),
  undo(title: "Undo", icon: Icons.undo),
  redo(title: "Redo", icon: Icons.redo);

  final String title;
  final IconData icon;
  const CanvasTools({required this.title, required this.icon});
}

enum EraserType {
  stroke(title: "Stroke Eraser"),
  area(title: "Area Eraser");

  final String title;
  const EraserType({required this.title});
}

enum CanvasSketchMode {
  draw(title: "Draw"),
  line(title: "Line"),
  rect(title: "Rect"),
  angle(title: "Angle");

  final String title;
  const CanvasSketchMode({required this.title});
}
