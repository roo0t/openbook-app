import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openbook/src/user/sign_up_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../white_logo_image.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SignUpController());
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
      child: GetBuilder<SignUpController>(
        builder: (controller) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // handled by BackButton
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const BackButton(),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
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
                          buildPasswordConfirmationField(controller),
                          const SizedBox(height: 10),
                          buildAgreementSection(controller, context),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('회원 가입'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Obx buildPasswordConfirmationField(SignUpController controller) {
    return Obx(
      () => TextField(
        onChanged: (text) => controller.setPasswordConfirmation(text),
        keyboardType: TextInputType.text,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: '비밀번호 확인',
          icon: const Icon(Icons.password_outlined),
          errorText: !controller.passwordAgreementVerificationStarted.value ||
                  controller.passwordsAgree.value
              ? null
              : '비밀번호가 일치하지 않습니다',
        ),
      ),
    );
  }

  Focus buildPasswordField(SignUpController controller) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          controller.startPasswordAgreementVerification();
        }
      },
      child: TextField(
        onChanged: (text) => controller.setPassword(text),
        keyboardType: TextInputType.text,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: const InputDecoration(
          labelText: '비밀번호',
          icon: Icon(Icons.password_outlined),
        ),
      ),
    );
  }

  TextField buildEmailAddressField(SignUpController controller) {
    return TextField(
      onChanged: (text) => controller.setEmailAddress(text),
      keyboardType: TextInputType.emailAddress,
      enableSuggestions: false,
      decoration: const InputDecoration(
        labelText: '이메일 주소',
        icon: Icon(Icons.email_rounded),
      ),
    );
  }

  Row buildAgreementSection(SignUpController controller, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Obx(
          () => Checkbox(
            value: controller.agreementChecked.value,
            onChanged: (bool? value) =>
                controller.setAgreementChecked(value ?? false),
          ),
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyText2?.merge(
                    const TextStyle(
                      height: 1.2,
                    ),
                  ),
              children: [
                TextSpan(
                  text: '이용약관',
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch(
                          'https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                    },
                ),
                const TextSpan(
                  text: ' 및 ',
                ),
                TextSpan(
                  text: '개인정보처리방침',
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch(
                          'https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                    },
                ),
                const TextSpan(
                  text: '을 읽었으며 동의합니다.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  handleOnTapForgotPassword(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('아직 계정 찾기 기능을 제공하지 않습니다. 조금만 기다려 주세요!'),
      ),
    );
  }
}
