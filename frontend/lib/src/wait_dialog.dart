import 'package:flutter/material.dart';

class WaitDialog extends StatelessWidget {
  const WaitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            Text("잠시 기다려 주세요"),
          ],
        ),
      ),
    );
  }
}
