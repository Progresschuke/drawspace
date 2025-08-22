import 'package:drawspace/core/enums/enums.dart';
import 'package:drawspace/core/providers/canvas_provider.dart';
import 'package:drawspace/presentation/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EraserPopupWidget extends StatelessWidget {
  const EraserPopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
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
    );
  }
}
