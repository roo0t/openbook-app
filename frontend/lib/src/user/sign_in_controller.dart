import 'package:get/get.dart';
import 'package:openbook/src/user/user_controller.dart';

class SignInController extends GetxController {
  RxString emailAddress = "".obs;
  RxString password = "".obs;
  RxBool shouldShowSignInFailedMessage = false.obs;

  setEmailAddress(text) {
    emailAddress(text);
    shouldShowSignInFailedMessage(false);
  }

  setPassword(text) {
    password(text);
    shouldShowSignInFailedMessage(false);
  }

  Future<SignInResult?> signIn() async {
    var result = await Get.find<UserController>()
        .signIn(emailAddress.value, password.value);
    if (result == SignInResult.badCredentials) {
      shouldShowSignInFailedMessage(true);
    }
    return result;
  }
}
