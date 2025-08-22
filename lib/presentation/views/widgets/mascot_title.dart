import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MascotTitle extends StatefulWidget {
  const MascotTitle({super.key});

  @override
  State<StatefulWidget> createState() => _MascotTitleState();
}

class _MascotTitleState extends State<MascotTitle> {
  late RiveAnimation anim;
  late StateMachineController _stateMachineController;

  @override
  void initState() {
    super.initState();

    anim = RiveAnimation.asset(
      'assets/animations/riveintro.riv',
      fit: BoxFit.contain,
      artboard: 'drawSpace',
      onInit: _onRiveInit,
    );
  }

  void _onRiveInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      'bubbleText',
    )!;
    artboard.addController(_stateMachineController);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 200, child: anim);
  }
}
