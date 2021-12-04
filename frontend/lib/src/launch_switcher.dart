import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openbook/src/user/sign_in_page.dart';
import 'package:openbook/src/user/user_controller.dart';
import 'package:openbook/src/white_logo_image.dart';

import 'home_page.dart';

class LaunchSwitcher extends StatelessWidget {
  const LaunchSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    Future.microtask(
      () => {
        if (Get.find<UserController>().isSignedIn)
          Get.offAll(() => const HomePage())
        else
          Get.offAll(() => const SignInPage())
      },
    );
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).backgroundColor,
            Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: WhiteLogoImage(),
            ),
          ),
        ),
      ),
    );
  }
}
