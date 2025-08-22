import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MascotWidget extends StatefulWidget {
  const MascotWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget> {
  late RiveAnimation anim;
  late StateMachineController _stateMachineController;

  @override
  void initState() {
    super.initState();

    anim = RiveAnimation.asset(
      'assets/animations/riveintro.riv',
      fit: BoxFit.contain,
      artboard: 'fullbody',
      onInit: _onRiveInit,
    );
  }

  void _onRiveInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      'fullbody',
    )!;
    artboard.addController(_stateMachineController);
  }

  @override
  Widget build(BuildContext context) {
    return anim;
  }
}
