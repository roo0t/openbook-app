import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openbook/src/user/sign_up_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home_page.dart';
import '../wait_dialog.dart';
import '../white_logo_image.dart';
import 'user_controller.dart';

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
                child: Form(
                  key: controller.signUpFormKey,
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
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) =>
                                      const WaitDialog(),
                                );
                                var result = await controller.signUp();
                                Navigator.pop(context); // Hide loading dialog
                                if (result == SignUpResult.successful) {
                                  Get.offAll(() => const HomePage());
                                } else if (result ==
                                    SignUpResult.unknownError) {
                                  Get.snackbar('실패', '알 수 없는 오류가 발생하였습니다.');
                                }
                              },
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
      ),
    );
  }

  Widget buildPasswordConfirmationField(SignUpController controller) {
    return TextFormField(
      controller: controller.passwordConfirmationController,
      validator: controller.validatePasswordConfirmation,
      keyboardType: TextInputType.text,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: '비밀번호 확인',
        icon: Icon(Icons.password_outlined),
      ),
    );
  }

  Widget buildPasswordField(SignUpController controller) {
    return TextFormField(
      controller: controller.passwordController,
      validator: controller.validatePassword,
      keyboardType: TextInputType.text,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: '비밀번호',
        icon: Icon(Icons.password_outlined),
      ),
    );
  }

  Widget buildEmailAddressField(SignUpController controller) {
    return TextFormField(
      controller: controller.emailAddressController,
      validator: controller.validateEmailAddress,
      keyboardType: TextInputType.emailAddress,
      enableSuggestions: false,
      decoration: const InputDecoration(
        labelText: '이메일 주소',
        icon: Icon(Icons.email_rounded),
      ),
    );
  }

  Widget buildAgreementSection(
      SignUpController controller, BuildContext context) {
    return Column(
      children: [
        Row(
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
              child: Column(
                children: [
                  RichText(
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
                ],
              ),
            ),
          ],
        ),
        Obx(() {
          if (controller.shouldShowAgreementRequiredMessage.isTrue) {
            return Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                '회원 가입을 위해서는 동의가 필요합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade800, fontSize: 12),
              ),
            );
          } else {
            return Container();
          }
        })
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
