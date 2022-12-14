import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openbook/src/user/sign_in_controller.dart';
import 'package:openbook/src/user/sign_up_page.dart';

import '../home_page.dart';
import '../wait_dialog.dart';
import '../white_logo_image.dart';
import 'user_controller.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SignInController());
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: GetBuilder<SignInController>(builder: (controller) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(30.0),
                      child: WhiteLogoImage(),
                    ),
                    Container(
                      padding: const EdgeInsets.all(30),
                      margin: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: const Color(0xFFFAFAFA),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildEmailAddressField(controller),
                          buildPasswordField(controller),
                          const SizedBox(height: 15),
                          buildSignInFailedMessage(controller),
                          const SizedBox(height: 15),
                          buildSignInButton(context, controller),
                          const SizedBox(height: 5),
                          buildForgotPasswordButton(context),
                        ],
                      ),
                    ),
                    buildSignUpText(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Obx buildSignInFailedMessage(SignInController controller) {
    return Obx(() {
      if (controller.shouldShowSignInFailedMessage.value) {
        return Text(
          '???????????? ??????????????????.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red.shade800),
        );
      } else {
        return Container();
      }
    });
  }

  TextField buildEmailAddressField(controller) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      enableSuggestions: false,
      onChanged: (text) => controller.setEmailAddress(text),
      decoration: const InputDecoration(
          labelText: '????????? ??????', icon: Icon(Icons.email_rounded)),
    );
  }

  TextField buildPasswordField(controller) {
    return TextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      onChanged: (text) => controller.setPassword(text),
      decoration: const InputDecoration(
          labelText: '????????????', icon: Icon(Icons.password_outlined)),
    );
  }

  ElevatedButton buildSignInButton(context, controller) {
    return ElevatedButton(
      onPressed: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WaitDialog(),
        );
        var result = await controller.signIn();
        Navigator.pop(context); // Hide loading dialog

        if (result == SignInResult.authenticated) {
          Get.offAll(() => const HomePage());
        } else if (result == SignInResult.unknownError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('??? ??? ?????? ????????? ?????????????????????.'),
            ),
          );
        }
      },
      child: const Text('?????????'),
    );
  }

  Widget buildForgotPasswordButton(BuildContext context) {
    return InkWell(
      onTap: () => handleOnTapForgotPassword(context),
      child: const Text(
        '????????? ???????????????',
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Row buildSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '?????? ????????? ???????????????? ',
          maxLines: 1,
          style: TextStyle(color: Colors.white),
        ),
        InkWell(
          onTap: () => Get.to(
            () => const SignUpPage(),
            transition: Transition.fadeIn,
          ),
          child: const Text(
            '?????? ?????????',
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  handleOnTapForgotPassword(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('?????? ?????? ?????? ????????? ???????????? ????????????. ????????? ????????? ?????????!'),
      ),
    );
  }
}
