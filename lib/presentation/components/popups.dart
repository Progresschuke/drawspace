import 'package:drawspace/core/enums/enums.dart';
import 'package:drawspace/core/painters/doodle_painter.dart';
import 'package:drawspace/core/providers/canvas_provider.dart';
import 'package:drawspace/presentation/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopUps {
  static Future showCanvasPopUp<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = false,
    Color? backgroundColor,
    double fullScreenWidthRatio = 0.8,
    Alignment alignment = Alignment.center,
    EdgeInsets? padding,
    double? borderRadius,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      builder: (innerContext) => Align(
        alignment: alignment,
        child: Card(
          color: backgroundColor ?? (AppColors.darkGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 32),
          ),
          child: Container(
            padding: padding ?? EdgeInsets.all(24),
            width: MediaQuery.sizeOf(context).width * fullScreenWidthRatio,
            child: child,
          ),
        ),
      ),
    );
  }

  static Future<bool?> showBrushPopUp({required BuildContext context}) async {
    double strokeWidth = 2.0;
    final colorPalette = List.from([AppColors.black, AppColors.white])
      ..addAll(Colors.accents);
    return await showCanvasPopUp(
      context: context,
      barrierDismissible: true,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      fullScreenWidthRatio: 0.85,
      alignment: Alignment(0, 0.5),
      child: Consumer(
        builder: (context, ref, child) {
          final canvasState = ref.watch(canvasProvider);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Brush Settings',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.close, color: AppColors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Container(
                height: 150,
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.blueAccent, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 160,
                      child: CustomPaint(
                        size: Size(50, 30),
                        painter: DoodlePainter(
                          color:
                              canvasState.selectedBrush.color ??
                              AppColors.black,
                          strokeWidth:
                              canvasState.selectedBrush.strokeWidth ?? 5.0,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Image.asset(
                        'assets/images/art_pen.png',
                        color: AppColors.white,
                        height: 120,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.remove, color: AppColors.white),
                  ),
                  Slider(
                    value: canvasState.selectedBrush.strokeWidth ?? strokeWidth,
                    min: 1.0,
                    max: 15.0,
                    activeColor: AppColors.blueAccent,
                    onChanged: (value) {
                      ref
                          .read(canvasProvider.notifier)
                          .updateBrushSettings(
                            strokeWidth: value,
                            color: canvasState.selectedBrush.color,
                          );
                    },
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add, color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Wrap(
                runSpacing: 10,
                spacing: 5,
                children: colorPalette
                    .map(
                      (color) => GestureDetector(
                        onTap: () {
                          ref
                              .read(canvasProvider.notifier)
                              .updateBrushSettings(
                                color: color,
                                strokeWidth:
                                    canvasState.selectedBrush.strokeWidth,
                              );
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: canvasState.selectedBrush.color == color
                                  ? AppColors.white
                                  : AppColors.transparent,
                              width: 2.0,
                            ),
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Pick a color!',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor:
                                canvasState.selectedBrush.color ??
                                AppColors.black,
                            onColorChanged: (color) {
                              ref
                                  .read(canvasProvider.notifier)
                                  .updateBrushSettings(
                                    color: color,
                                    strokeWidth:
                                        canvasState.selectedBrush.strokeWidth,
                                  );
                            },
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                    context: context,
                  );
                },

                child: Image.asset('assets/icons/color-wheel.png', height: 70),
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<bool?> showEraserPopUp({required BuildContext context}) async {
    return await showCanvasPopUp(
      context: context,
      barrierDismissible: true,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      fullScreenWidthRatio: 0.85,
      alignment: Alignment(0, 0.6),
      child: Consumer(
        builder: (context, ref, child) {
          EraserType selectedOption = ref
              .watch(canvasProvider)
              .selectedEraserType;
          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Canvas Eraser',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: const Color.fromARGB(
                            167,
                            158,
                            158,
                            158,
                          ),
                          child: Icon(Icons.close, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: EraserType.values.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) => RadioListTile(
                      value: EraserType.values[index],
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        EraserType.values[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: AppColors.white,
                        ),
                      ),
                      dense: true,
                      selected: selectedOption == EraserType.values[index],

                      groupValue: selectedOption,
                      activeColor: AppColors.blueAccent,
                      controlAffinity: ListTileControlAffinity.trailing,
                      onChanged: (value) {
                        ref
                            .read(canvasProvider.notifier)
                            .updateEraserSettings(eraser: value);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(canvasProvider.notifier).eraseAllCanvasSketch();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      fixedSize: Size.fromWidth(
                        MediaQuery.sizeOf(context).width * 0.8,
                      ),
                    ),
                    child: Text('Erase all drawings'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
