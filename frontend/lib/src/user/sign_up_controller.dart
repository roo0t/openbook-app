import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_page.dart';
import 'user_controller.dart';

class SignUpController extends GetxController {
  final signUpFormKey = GlobalKey<FormState>();
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  RxBool agreementChecked = false.obs;
  RxString emailAddress = "".obs;
  RxString password = "".obs;
  RxString passwordConfirmation = "".obs;
  RxBool passwordsAgree = true.obs;
  RxBool passwordAgreementVerificationStarted = false.obs;
  RxBool shouldShowDuplicateEmailAddressMessage = false.obs;
  RxBool shouldShowAgreementRequiredMessage = false.obs;

  String? validateEmailAddress(String? emailAddress) {
    final RegExp regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    if (emailAddress == null || !regExp.hasMatch(emailAddress)) {
      return "이메일 주소가 잘못되었습니다.";
    } else if (shouldShowDuplicateEmailAddressMessage.isTrue) {
      return "이미 가입된 이메일 주소입니다.";
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "비밀번호를 입력해 주세요.";
    } else if (password.length < 8) {
      return "비밀번호는 8자 이상이어야 합니다.";
    } else if (password.length > 20) {
      return "비밀번호는 20자 이하여야 합니다.";
    } else {
      final RegExp regExp =
          RegExp(r"^[a-zA-Z0-9.,'" '"' r"!@#$%^&*()-_+=\\]+$");
      if (!regExp.hasMatch(password)) {
        return "비밀번호에 허용되지 않는 문자가 있습니다.";
      } else {
        return null;
      }
    }
  }

  String? validatePasswordConfirmation(String? password) {
    if (password == null || password.isEmpty) {
      return "비밀번호를 한 번 더 입력해 주세요.";
    } else if (password != passwordController.text) {
      return "비밀번호가 일치하지 않습니다.";
    } else {
      return null;
    }
  }

  setAgreementChecked(bool checked) {
    agreementChecked(checked);
    shouldShowAgreementRequiredMessage(false);
  }

  validateAgreementChecked() {
    if (agreementChecked.isFalse) {
      shouldShowAgreementRequiredMessage(true);
    }
    return agreementChecked.isTrue;
  }

  signUp() async {
    shouldShowDuplicateEmailAddressMessage(false);
    final bool? formValidationResult = signUpFormKey.currentState?.validate();
    final bool agreementValidationResult = validateAgreementChecked();
    if (formValidationResult == true && agreementValidationResult) {
      var result = await Get.find<UserController>()
          .signUp(emailAddressController.text, password.value);

      switch (result) {
        case SignUpResult.successful:
          Get.offAll(() => const HomePage());
          break;
        case SignUpResult.duplicateUsername:
          shouldShowDuplicateEmailAddressMessage(true);
          signUpFormKey.currentState?.validate();
          break;
        case SignUpResult.unknownError:
          Get.snackbar('실패', '알 수 없는 오류가 발생하였습니다.');
          break;
      }
    }
  }
}
