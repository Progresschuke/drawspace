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
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: DrawingCanvas(),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                color: AppColors.darkGrey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: CanvasTools.values.map((tool) {
                    return GestureDetector(
                      onTap: () async {
                        print(tool);
                        ref
                            .read(canvasProvider.notifier)
                            .updateCanvasToolSettings(canvasTool: tool);

                        switch (tool) {
                          case CanvasTools.brush:
                            ref
                                .read(canvasProvider.notifier)
                                .updateCanvasSketchMode(
                                  sketchMode: CanvasSketchMode.draw,
                                );
                            await PopUps.showBrushPopUp(context: context);

                            break;
                          case CanvasTools.eraser:
                            print(selectedTool);
                            await PopUps.showEraserPopUp(context: context);
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
            ),
          ],
        ),
      ),
    );
  }
}
