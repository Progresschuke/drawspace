import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:drawspace/core/enums/enums.dart';
import 'package:drawspace/core/models/brush_model.dart';
import 'package:drawspace/core/models/sketch_model.dart';
import 'package:drawspace/presentation/styles/app_colors.dart';

final canvasProvider = StateNotifierProvider<CanvasProvider, CanvasState>((
  ref,
) {
  return CanvasProvider();
});

class CanvasProvider extends StateNotifier<CanvasState> {
  CanvasProvider() : super(CanvasState());

  void reset() {
    state = CanvasState();
  }

  void setCurrentSketch(SketchModel sketch) {
    state = state.copyWith(currentCanvasSketch: sketch);
  }

  void updateBrushSettings({Color? color, double? strokeWidth}) {
    if (state.selectedCanvasTool == CanvasTools.eraser) {
      state = state.copyWith(
        eraserBrush: BrushModel(
          color: AppColors.white,
          strokeWidth: strokeWidth,
        ),
      );
      return;
    }

    state = state.copyWith(
      selectedBrush: BrushModel(color: color, strokeWidth: strokeWidth),
    );
  }

  void updateCanvasToolSettings({CanvasTools? canvasTool}) {
    state = state.copyWith(selectedCanvasTool: canvasTool);
  }

  void updateCanvasSketchMode({CanvasSketchMode? sketchMode}) {
    state = state.copyWith(selectedSketchMode: sketchMode);
  }

  void updateEraserSettings({EraserType? eraser}) {
    state = state.copyWith(selectedEraserType: eraser);
    switch (eraser) {
      case EraserType.area:
        updateBrushSettings(color: AppColors.white, strokeWidth: 90.0);
        break;
      case EraserType.stroke:
        updateBrushSettings(color: AppColors.white, strokeWidth: 20.0);
        break;

      case null:
        return;
    }
  }

  void eraseAllCanvasSketch() {
    state = state.copyWith(
      allCanvasSketch: [],
      // currentCanvasSketch: SketchModel(points: [Offset.zero]),
    );
  }

  void eraseCurrentSketch() {
    state = state.copyWith(
      currentCanvasSketch: SketchModel(points: [Offset.zero]),
    );
  }

  void undoSketch() {
    if (state.allCanvasSketch != null && state.allCanvasSketch!.isNotEmpty) {
      final sketches = List<SketchModel>.from(state.allCanvasSketch!);

      final redoSketches = List<SketchModel>.from(
        state.redoCanvasSketchList ?? [],
      );
      redoSketches.add(sketches.elementAt(sketches.length - 1));
      sketches.removeLast();
      state = state.copyWith(
        allCanvasSketch: sketches,
        redoCanvasSketchList: redoSketches,
      );
    }
  }

  void redoSketch() {
    if (state.redoCanvasSketchList != null &&
        state.redoCanvasSketchList!.isNotEmpty) {
      state = state.copyWith(
        allCanvasSketch: List<SketchModel>.from(state.allCanvasSketch ?? [])
          ..add(state.redoCanvasSketchList!.last),
        redoCanvasSketchList: List<SketchModel>.from(
          state.redoCanvasSketchList!..removeLast(),
        ),
      );
    }
  }

  void updateBrush(BrushModel brush) {
    state = state.copyWith(selectedBrush: brush);
  }

  void buildAllCanvasSketch(List<SketchModel> sketches) {
    state = state.copyWith(allCanvasSketch: sketches);
  }
}

class CanvasState {
  final SketchModel? currentCanvasSketch;
  final List<SketchModel>? allCanvasSketch;
  final List<SketchModel>? redoCanvasSketchList;
  final BrushModel selectedBrush;
  final BrushModel eraserBrush;
  final EraserType selectedEraserType;
  final CanvasSketchMode selectedSketchMode;
  final CanvasTools selectedCanvasTool;

  CanvasState({
    EraserType? selectedEraserType,
    BrushModel? selectedBrush,
    BrushModel? eraserBrush,
    CanvasSketchMode? selectedSketchMode,
    CanvasTools? selectedCanvasTool,
    this.currentCanvasSketch,
    this.allCanvasSketch,
    this.redoCanvasSketchList,
  }) : selectedBrush =
           selectedBrush ?? BrushModel(color: Colors.black, strokeWidth: 5.0),
       eraserBrush =
           eraserBrush ?? BrushModel(color: Colors.white, strokeWidth: 20.0),
       selectedEraserType = selectedEraserType ?? EraserType.stroke,
       selectedSketchMode = selectedSketchMode ?? CanvasSketchMode.draw,
       selectedCanvasTool = selectedCanvasTool ?? CanvasTools.brush;

  CanvasState copyWith({
    SketchModel? currentCanvasSketch,
    List<SketchModel>? allCanvasSketch,
    List<SketchModel>? redoCanvasSketchList,
    BrushModel? selectedBrush,
    BrushModel? eraserBrush,
    EraserType? selectedEraserType,
    CanvasSketchMode? selectedSketchMode,
    CanvasTools? selectedCanvasTool,
  }) {
    return CanvasState(
      currentCanvasSketch: currentCanvasSketch ?? this.currentCanvasSketch,
      allCanvasSketch: allCanvasSketch ?? this.allCanvasSketch,
      redoCanvasSketchList: redoCanvasSketchList ?? this.redoCanvasSketchList,
      selectedBrush: selectedBrush ?? this.selectedBrush,
      eraserBrush: eraserBrush ?? this.eraserBrush,
      selectedEraserType: selectedEraserType ?? this.selectedEraserType,
      selectedSketchMode: selectedSketchMode ?? this.selectedSketchMode,
      selectedCanvasTool: selectedCanvasTool ?? this.selectedCanvasTool,
    );
  }

  @override
  String toString() {
    return 'CanvasState(currentCanvasSketch: $currentCanvasSketch, allCanvasSketch: $allCanvasSketch, redoCanvasSketchList: $redoCanvasSketchList, selectedBrush: $selectedBrush, eraserBrush: $eraserBrush, selectedEraserType: $selectedEraserType, selectedSketchMode: $selectedSketchMode, selectedCanvasTool: $selectedCanvasTool)';
  }

  @override
  bool operator ==(covariant CanvasState other) {
    if (identical(this, other)) return true;

    return other.currentCanvasSketch == currentCanvasSketch &&
        listEquals(other.allCanvasSketch, allCanvasSketch) &&
        listEquals(other.redoCanvasSketchList, redoCanvasSketchList) &&
        other.selectedBrush == selectedBrush &&
        other.eraserBrush == eraserBrush &&
        other.selectedEraserType == selectedEraserType &&
        other.selectedSketchMode == selectedSketchMode &&
        other.selectedCanvasTool == selectedCanvasTool;
  }

  @override
  int get hashCode {
    return currentCanvasSketch.hashCode ^
        allCanvasSketch.hashCode ^
        redoCanvasSketchList.hashCode ^
        selectedBrush.hashCode ^
        eraserBrush.hashCode ^
        selectedEraserType.hashCode ^
        selectedSketchMode.hashCode ^
        selectedCanvasTool.hashCode;
  }
}
