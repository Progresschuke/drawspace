import 'dart:async';

import 'package:drawspace/presentation/views/ui/drawing_homepage.dart';
import 'package:drawspace/presentation/views/widgets/mascot.dart';
import 'package:drawspace/presentation/views/widgets/mascot_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration(seconds: 6), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DrawingHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 100, right: 0, left: 0, child: MascotTitle())
              .animate()
              .fadeIn(duration: 1.seconds, curve: Curves.easeInOut)
              .scaleXY(
                alignment: Alignment.topCenter,
                begin: 0.5,
                end: 1.0,
                duration: 1.seconds,
                curve: Curves.easeInOut,
              ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            bottom: -MediaQuery.of(context).size.height * 0.07,
            right: 0,
            left: 0,
            child: Transform.scale(scale: 1.2, child: MascotWidget()).animate(
              effects: [
                FadeEffect(duration: 1.seconds, delay: 0.seconds),
                SlideEffect(
                  begin: Offset(0, 0.45),
                  end: Offset.zero,
                  duration: 1.5.seconds,
                  curve: Curves.easeInOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
