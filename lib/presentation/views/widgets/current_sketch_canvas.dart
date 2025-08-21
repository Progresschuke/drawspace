import 'package:drawspace/core/models/sketch_model.dart';
import 'package:drawspace/core/painters/canvas_painter.dart';
import 'package:drawspace/core/providers/canvas_provider.dart';
import 'package:drawspace/presentation/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentSketchCanvas extends ConsumerStatefulWidget {
  const CurrentSketchCanvas({super.key});

  @override
  ConsumerState<CurrentSketchCanvas> createState() =>
      _CurrentSketchCanvasState();
}

class _CurrentSketchCanvasState extends ConsumerState<CurrentSketchCanvas> {
  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    return Listener(
      onPointerDown: (eventDetails) {
        RenderBox box = context.findRenderObject() as RenderBox;
        final offset = box.globalToLocal(eventDetails.position);
        final sketch = SketchModel(
          points: [offset],
          sketchMode: canvasState.selectedSketchMode,
        );
        ref.read(canvasProvider.notifier).setCurrentSketch(sketch);
      },
      onPointerMove: (eventDetails) {
        RenderBox box = context.findRenderObject() as RenderBox;
        final offset = box.globalToLocal(eventDetails.position);
        List<Offset> points = List.from(
          canvasState.currentCanvasSketch?.points ?? [],
        )..add(offset);
        final sketch = SketchModel(
          points: points,
          color: canvasState.selectedBrush.color ?? AppColors.primary,
          strokeWidth: canvasState.selectedBrush.strokeWidth ?? 5.0,
          sketchMode: canvasState.selectedSketchMode,
        );

        ref.read(canvasProvider.notifier).setCurrentSketch(sketch);
      },
      onPointerUp: (event) {
        ref
            .read(canvasProvider.notifier)
            .buildAllCanvasSketch(
              List.from(canvasState.allCanvasSketch ?? [])
                ..add(canvasState.currentCanvasSketch!),
            );
        ref.read(canvasProvider.notifier).eraseCurrentSketch();
      },
      child: RepaintBoundary(
        child: CustomPaint(
          painter: CanvasPainter(
            sketches: canvasState.currentCanvasSketch != null
                ? [canvasState.currentCanvasSketch!]
                : [],
            color: AppColors.blueAccent,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}
