import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:openbook/src/book/book_vo.dart';

class BookSearchController extends GetxController {
  RxString searchText = "".obs;
  RxList<BookVo> searchResults = RxList<BookVo>();

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

  Future<List<BookVo>?> _search(searchText) async {
    var response = await http.get(
      Uri.http(
        'localhost:8080',
        '/book',
        {'query': searchText},
      ),
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['statusMessage'] == 'SUCCESS') {
        return responseJson['data']
            .map<BookVo>(
              (bookJson) => BookVo.fromJson(bookJson),
            )
            .toList();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}