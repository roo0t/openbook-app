import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  final GetStorage _authBox;

  bool isSignedIn = false;
  String? get token => _authBox.read('token');

  UserController() : _authBox = GetStorage('auth') {
    if (token != null) {
      isSignedIn = true;
    }
  }

  bool signIn(String emailAddress, String password) {
    if (emailAddress == 'test@glowingreaders.club' && password == 'abcd') {
      const String generatedToken = 'somerandomstring';
      _authBox.write('token', generatedToken);
      isSignedIn = true;
    } else {
      isSignedIn = false;
    }
    update();
    return isSignedIn;
  }

  signOut() {
    _authBox.remove('token');
    isSignedIn = false;
    print('signing out');
    update();
  }
}
