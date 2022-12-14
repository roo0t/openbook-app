import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:openbook/src/book/book_detail_page.dart';
import 'package:openbook/src/book/book_vo.dart';
import 'package:openbook/src/user/sign_in_page.dart';
import 'package:openbook/src/user/user_controller.dart';

import '../backend_uris.dart';

class BookSearchController extends GetxController {
  RxString searchText = "".obs;
  RxList<BookVo> searchResults = RxList<BookVo>();
  final TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    debounce(
      searchText,
      (text) async {
        List<BookVo>? result = await _search(text);
        if (result != null) {
          searchResults(result);
        }
      },
      time: const Duration(milliseconds: 200),
    );
    super.onInit();
  }

  void search(text) {
    searchText(text);
  }

  void searchIsbn(isbn) async {
    final books = await _search(isbn);
    if (books != null && books.isNotEmpty) {
      Get.to(() => BookDetailPage(book: books[0]));
    }
  }

  Future<List<BookVo>?> _search(searchText) async {
    http.Response? response;
    try {
      response = await http.get(
        BackendUris.BOOK_SEARCH.replace(queryParameters: {'query': searchText}),
        headers: {
          'Content-Type': 'application/json',
          'X-AUTH-TOKEN': Get.find<UserController>().token!
        },
      );
    } catch (e) {
      return null;
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
    } else {
      return null;
    }
  }

  clearSearchText() {
    searchTextController.text = "";
    searchResults.clear();
  }
}
