import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:openbook/src/timer/remaining_time_painter.dart';
import 'package:openbook/src/timer/timer_controller.dart';

class TimerWidget extends StatelessWidget {
  final int totalSeconds;

  const TimerWidget({Key? key, required this.totalSeconds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimerController>(
      builder: (controller) => CustomPaint(
        foregroundPainter: RemainingTimePainter(
          (controller.remainingTime?.inSeconds ?? 0) / totalSeconds,
        ),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.65,
            child: Lottie.asset('assets/animations/72929-reading-book.json'),
          ),
        ),
      ),
    );
  }
}
