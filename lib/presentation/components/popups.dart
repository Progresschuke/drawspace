import 'package:drawspace/presentation/styles/app_colors.dart';
import 'package:drawspace/presentation/views/widgets/brush_popup.dart';
import 'package:drawspace/presentation/views/widgets/eraser_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    final deviceWidth = MediaQuery.sizeOf(context).width;
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      builder: (innerContext) => Align(
        alignment: alignment,
        child:
            Card(
                  color: backgroundColor ?? AppColors.darkGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 32),
                  ),
                  child: Container(
                    padding: padding ?? const EdgeInsets.all(24),
                    width: deviceWidth * fullScreenWidthRatio,
                    child: child,
                  ),
                )
                .animate(target: deviceWidth >= 500 ? 1 : 0)
                .slideY(
                  begin: deviceWidth >= 500 ? 0.9 : 0.0,
                  end: deviceWidth >= 500 ? 0.4 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
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
      alignment: Alignment(0, 0.3),
      child: BrushPopupWidget(
        strokeWidth: strokeWidth,
        colorPalette: colorPalette,
      ),
    );
  }

  static Future<bool?> showEraserPopUp({required BuildContext context}) async {
    return await showCanvasPopUp(
      context: context,
      barrierDismissible: true,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      fullScreenWidthRatio: 0.85,
      alignment: Alignment(0, 0.7),
      child: EraserPopupWidget(),
    );
  }
}
