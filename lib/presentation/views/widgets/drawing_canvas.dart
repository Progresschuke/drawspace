import 'package:drawspace/core/enums/enums.dart';
import 'package:drawspace/presentation/views/widgets/all_sketch_canvas.dart';
import 'package:drawspace/presentation/views/widgets/current_sketch_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawingCanvas extends ConsumerStatefulWidget {
  const DrawingCanvas({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends ConsumerState<DrawingCanvas> {
  CanvasTools selectedTool = CanvasTools.brush;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: AllSketchesCanvas()),
        Positioned.fill(child: CurrentSketchCanvas()),
      ],
    );
  }
}
