import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../backend_uris.dart';

class UserController extends GetxController {
  final GetStorage _authBox;

  bool isSignedIn = false;
  String? get token => _authBox.read('token');

  UserController() : _authBox = GetStorage('auth') {
    if (token != null) {
      isSignedIn = true;
    }
  }

  Future<bool> signIn(String emailAddress, String password) async {
    final response = await http.post(BackendUris.SIGN_IN, body: {
      "emailAddress": emailAddress,
      "password": password,
    });
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final String token = responseBody["token"] as String;
      _authBox.write('token', token);
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
