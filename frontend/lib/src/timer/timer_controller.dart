import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController{
  Duration? remainingTime;
  Timer? _timer;

  bool get isStarted => _timer != null;

  void start(Duration duration) {
    remainingTime = duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) => tick());
    update();
  }

  void tick() {
    if (remainingTime == null || remainingTime!.inSeconds <= 0) {
      stop();
    } else {
      remainingTime = Duration(seconds: remainingTime!.inSeconds - 1);
    }
    update();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    update();
  }
}