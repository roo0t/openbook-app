import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../backend_uris.dart';
import '../user/sign_in_page.dart';
import '../user/user_controller.dart';
import 'book_vo.dart';
import 'reading_record_vo.dart';

class ReadingRecordController extends GetxController {
  final BookVo book;
  RxList<ReadingRecordVo> readingRecords = RxList<ReadingRecordVo>();

  ReadingRecordController(this.book) : super() {
    _getRecords().then((records) {
      readingRecords(records);
    });
  }

  Future<List<ReadingRecordVo>> _getRecords() async {
    http.Response? response;
    try {
      response = await http.get(
        BackendUris.getReadingRecordsUri(book.isbn),
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
        return responseJson['_embedded']['readingRecordsList']
            .map<ReadingRecordVo>((record) {
          return ReadingRecordVo.fromJson(record);
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
