import 'package:drawspace/core/painters/canvas_painter.dart';
import 'package:drawspace/core/providers/canvas_provider.dart';
import 'package:drawspace/presentation/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllSketchesCanvas extends ConsumerStatefulWidget {
  const AllSketchesCanvas({super.key});

  @override
  ConsumerState<AllSketchesCanvas> createState() => _AllSketchesCanvasState();
}

class _AllSketchesCanvasState extends ConsumerState<AllSketchesCanvas> {
  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    return RepaintBoundary(
      child: CustomPaint(
        painter: CanvasPainter(
          sketches: canvasState.allCanvasSketch != null
              ? canvasState.allCanvasSketch!
              : [],
          color: AppColors.blueAccent,
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
