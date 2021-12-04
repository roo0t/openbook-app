import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openbook/src/timer/timer_controller.dart';
import 'package:openbook/src/timer/timer_widget.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  final int totalSeconds = 60 * 1;

  @override
  Widget build(BuildContext context) {
    Get.put(TimerController());
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF86B347),
            Color(0xFFB34E36),
          ],
        ),
      ),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.back(),
            child: const Icon(Icons.pause),
            mini: true,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.find<TimerController>().start(
                          Duration(seconds: totalSeconds),
                        );
                      },
                      child: const Icon(Icons.play_arrow),
                    ),
                  ],
                ),
              ),
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: TimerWidget(
                      totalSeconds: totalSeconds,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GetBuilder(builder: (TimerController controller) {
                      if (controller.remainingTime == null) {
                        return const Text("");
                      }
                      final int remainingMinutes =
                          controller.remainingTime!.inMinutes.floor();
                      final int remainingSeconds =
                          controller.remainingTime!.inSeconds -
                              remainingMinutes * 60;
                      if (remainingMinutes > 0) {
                        return Text(
                            "목표 시간까지 $remainingMinutes분 $remainingSeconds초");
                      } else {
                        return Text("목표 시간까지 $remainingSeconds초");
                      }
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
