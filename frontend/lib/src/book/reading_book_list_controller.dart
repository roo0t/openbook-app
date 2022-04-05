import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../backend_uris.dart';
import '../user/sign_in_page.dart';
import '../user/user_controller.dart';
import 'book_vo.dart';

class ReadingBookListController extends GetxController {
  RxBool loaded = false.obs;
  RxList<BookVo> books = RxList<BookVo>();

  ReadingBookListController() : super() {
    updateReadingBookList().then((_) {
      loaded(true);
    });
  }

  Future<void> updateReadingBookList() async {
    List<BookVo> books = await _getReadingBookList();
    this.books(books);
  }

  Future<List<BookVo>> _getReadingBookList() async {
    http.Response? response;
    try {
      response = await http.get(
        BackendUris.READING_BOOK_LIST,
        headers: {
          'Content-Type': 'application/json',
          'X-AUTH-TOKEN': Get.find<UserController>().token!
        },
      );
    } catch (e) {
      return List.empty();
    }
    if (response.statusCode == HttpStatus.ok) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['_embedded'] != null) {
        return responseJson['_embedded']['bookList'].map<BookVo>((book) {
          return BookVo.fromJson(book);
        }).toList();
      } else {
        return List.empty();
      }
    } else if (response.statusCode == HttpStatus.forbidden) {
      Get.find<UserController>().signOut();
      Get.offAll(() => const SignInPage());
    }
    return List.empty();
  }
}
