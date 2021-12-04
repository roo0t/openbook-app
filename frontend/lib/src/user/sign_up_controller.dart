import 'package:get/get.dart';

class SignUpController extends GetxController {
  RxBool agreementChecked = false.obs;
  RxString emailAddress = "".obs;
  RxString password = "".obs;
  RxString passwordConfirmation = "".obs;
  RxBool passwordsAgree = true.obs;
  RxBool passwordAgreementVerificationStarted = false.obs;

  setAgreementChecked(bool checked) {
    agreementChecked(checked);
  }

  setEmailAddress(String text) {
    emailAddress(text);
  }

  setPassword(String text) {
    password(text);
    passwordsAgree(password.value == passwordConfirmation.value);
  }

  startPasswordAgreementVerification() {
    passwordAgreementVerificationStarted(true);
  }

  setPasswordConfirmation(String text) {
    passwordConfirmation(text);
    passwordsAgree(password.value == passwordConfirmation.value);
  }
}
