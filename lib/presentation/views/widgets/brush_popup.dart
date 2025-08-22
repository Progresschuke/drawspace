import 'package:drawspace/core/painters/doodle_painter.dart';
import 'package:drawspace/core/providers/canvas_provider.dart';
import 'package:drawspace/presentation/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrushPopupWidget extends StatelessWidget {
  const BrushPopupWidget({
    super.key,
    required this.strokeWidth,
    required this.colorPalette,
  });

  final double strokeWidth;
  final List colorPalette;

  @override
  Widget build(BuildContext context) {
    return Consumer(
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
                            canvasState.selectedBrush.color ?? AppColors.black,
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
                  max: 10.0,
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
                        Navigator.pop(context);
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
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Could not find a color you like?',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Pick a color!',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    await showDialog(
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: AppColors.darkGrey,
                          title: const Text(
                            'Pick a color!',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              displayThumbColor: false,
                              showLabel: false,
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
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                      context: context,
                    );
                  },

                  child: Image.asset('assets/icons/color-wheel.png', scale: 10),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
