import 'package:drawspace/core/enums/enums.dart';
import 'package:drawspace/core/providers/canvas_provider.dart';
import 'package:drawspace/presentation/components/popups.dart';
import 'package:drawspace/presentation/styles/app_colors.dart';
import 'package:drawspace/presentation/views/widgets/drawing_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawingHomePage extends ConsumerStatefulWidget {
  const DrawingHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DrawingHomePageState();
}

class _DrawingHomePageState extends ConsumerState<DrawingHomePage> {
  @override
  Widget build(BuildContext context) {
    final canvaState = ref.watch(canvasProvider);
    CanvasTools selectedTool = canvaState.selectedCanvasTool;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            toolbar({
              required BoxDecoration decoration,
              required double bottom,
              required double left,
              required double right,
            }) => Positioned(
              bottom: bottom,
              left: left,
              right: right,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: decoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: CanvasTools.values.map((tool) {
                    return GestureDetector(
                      onTap: () async {
                        ref
                            .read(canvasProvider.notifier)
                            .updateCanvasToolSettings(canvasTool: tool);
                        switch (tool) {
                          case CanvasTools.brush:
                            if (canvaState.selectedCanvasTool == tool) {
                              await PopUps.showBrushPopUp(context: context);
                            } else {
                              ref
                                  .read(canvasProvider.notifier)
                                  .updateBrushSettings(
                                    color: canvaState.selectedBrush.color,
                                    strokeWidth:
                                        canvaState.selectedBrush.strokeWidth,
                                  );
                            }
                            ref
                                .read(canvasProvider.notifier)
                                .updateCanvasSketchMode(
                                  sketchMode: CanvasSketchMode.draw,
                                );
                            break;
                          case CanvasTools.eraser:
                            if (canvaState.selectedCanvasTool == tool) {
                              await PopUps.showEraserPopUp(context: context);
                            }
                            ref
                                .read(canvasProvider.notifier)
                                .updateCanvasSketchMode(
                                  sketchMode: CanvasSketchMode.draw,
                                );
                            break;
                          case CanvasTools.line:
                            ref
                                .read(canvasProvider.notifier)
                                .updateCanvasSketchMode(
                                  sketchMode: CanvasSketchMode.line,
                                );
                            break;
                          case CanvasTools.rect:
                            ref
                                .read(canvasProvider.notifier)
                                .updateCanvasSketchMode(
                                  sketchMode: CanvasSketchMode.rect,
                                );
                            break;
                          case CanvasTools.undo:
                            ref.read(canvasProvider.notifier).undoSketch();
                            break;
                          case CanvasTools.redo:
                            ref.read(canvasProvider.notifier).redoSketch();
                            break;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedTool == tool
                              ? AppColors.blueAccent
                              : AppColors.transparent,
                        ),
                        child: Icon(
                          tool.icon,
                          color: AppColors.white,
                          size: 28,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );

            if (width < 500) {
              return Stack(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: DrawingCanvas(),
                  ),
                  toolbar(
                    decoration: const BoxDecoration(color: AppColors.darkGrey),
                    bottom: 0,
                    left: 0,
                    right: 0,
                  ),
                ],
              );
            }
            return Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: DrawingCanvas(),
                ),
                toolbar(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.darkGrey,
                  ),
                  bottom: 50,
                  left: 100,
                  right: 100,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
