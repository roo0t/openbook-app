import 'package:get/get.dart';
import 'package:openbook/src/user/user_controller.dart';

import '../home_page.dart';

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

  signIn() {
    var result =
        Get.find<UserController>().signIn(emailAddress.value, password.value);

    if (result) {
      Get.offAll(() => const HomePage());
    } else {
      shouldShowSignInFailedMessage(true);
    }
  }
}
