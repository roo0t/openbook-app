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

  signIn() async {
    var result = await Get.find<UserController>()
        .signIn(emailAddress.value, password.value);

    switch (result) {
      case SignInResult.authenticated:
        Get.offAll(() => const HomePage());
        break;
      case SignInResult.badCredentials:
        shouldShowSignInFailedMessage(true);
        break;
      case SignInResult.unknownError:
        // TODO: Handle this case.
        break;
    }
  }
}
