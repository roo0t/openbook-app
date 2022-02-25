import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../backend_uris.dart';

enum SignInResult {
  authenticated,
  badCredentials,
  unknownError,
}

enum SignUpResult {
  successful,
  duplicateUsername,
  unknownError,
}

class UserController extends GetxController {
  final GetStorage _authBox;

  bool isSignedIn = false;
  String? get token => _authBox.read('token');

  UserController() : _authBox = GetStorage('auth') {
    if (token != null) {
      isSignedIn = true;
    }
  }

  Future<SignInResult> signIn(String emailAddress, String password) async {
    final response = await http.post(BackendUris.SIGN_IN,
        body: jsonEncode({
          "emailAddress": emailAddress,
          "password": password,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    SignInResult result = SignInResult.unknownError;
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final String token = responseBody["token"] as String;
      _authBox.write('token', token);
      isSignedIn = true;
      result = SignInResult.authenticated;
    } else if (response.statusCode == HttpStatus.forbidden) {
      isSignedIn = false;
      result = SignInResult.badCredentials;
    } else {
      isSignedIn = false;
      result = SignInResult.unknownError;
    }

    update();
    return result;
  }

  signOut() {
    _authBox.remove('token');
    isSignedIn = false;
    print('signing out');
    update();
  }

  Future<SignUpResult> signUp(String emailAddress, String password) async {
    final response = await http.post(BackendUris.SIGN_UP,
        body: jsonEncode({
          "emailAddress": emailAddress,
          "password": password,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    SignUpResult result = SignUpResult.successful;
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final String token = responseBody["token"] as String;
      _authBox.write('token', token);
      isSignedIn = true;
      result = SignUpResult.successful;
    } else if (response.statusCode == HttpStatus.badRequest) {
      isSignedIn = false;
      result = SignUpResult.duplicateUsername;
    } else {
      isSignedIn = false;
      result = SignUpResult.unknownError;
    }

    update();
    return result;
  }
}
