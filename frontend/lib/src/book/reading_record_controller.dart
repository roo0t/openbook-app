import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:openbook/src/book/reading_book_list_controller.dart';

import '../backend_uris.dart';
import '../time_util.dart';
import '../user/sign_in_page.dart';
import '../user/user_controller.dart';
import 'book_vo.dart';
import 'reading_record_vo.dart';

class ReadingRecordController extends GetxController {
  final BookVo book;
  RxList<ReadingRecordVo> readingRecords = RxList<ReadingRecordVo>();
  RxInt totalReadPages = 0.obs;
  RxString latestReadingRecordDate = ''.obs;

  ReadingRecordController(this.book) : super() {
    _getRecords().then((records) {
      readingRecords(records);
      _handleRecordsUpdated();
    });
  }

  _handleRecordsUpdated() {
    totalReadPages(calculateTotalReadPageCount());
    latestReadingRecordDate(getLatestReadingRecordDate());
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
      return [];
    }
    if (response.statusCode == HttpStatus.ok) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['_embedded'] != null) {
        return responseJson['_embedded']['readingRecordList']
            .map<ReadingRecordVo>((record) {
          return ReadingRecordVo.fromJson(record);
        }).toList();
      } else {
        return [];
      }
    } else if (response.statusCode == HttpStatus.forbidden) {
      Get.find<UserController>().signOut();
      Get.offAll(() => const SignInPage());
    }
    return [];
  }

  Future<ReadingRecordVo?> addRecord(int startPage, int endPage) async {
    final ReadingRecordVo? addedRecord = await _addRecord(startPage, endPage);
    if (addedRecord != null) {
      readingRecords.add(addedRecord);
      _handleRecordsUpdated();
      Get.find<ReadingBookListController>().updateReadingBookList();
    }
    return addedRecord;
  }

  Future<ReadingRecordVo?> _addRecord(int startPage, int endPage) async {
    try {
      final response =
          await http.put(BackendUris.getReadingRecordsUri(book.isbn),
              body: jsonEncode({
                "startPage": startPage,
                "endPage": endPage,
              }),
              headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'X-AUTH-TOKEN': Get.find<UserController>().token!
          });
      if (response.statusCode == HttpStatus.ok) {
        final responseBody =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return ReadingRecordVo.fromJson(responseBody);
      } else if (response.statusCode == HttpStatus.forbidden) {
        Get.find<UserController>().signOut();
        Get.offAll(() => const SignInPage());
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  int calculateTotalReadPageCount() {
    List<bool> readPages = List.filled(book.totalPages, false);
    for (final record in readingRecords) {
      for (int i = record.startPage; i <= record.endPage; i++) {
        readPages[i] = true;
      }
    }
    return readPages.where((read) => read).length;
  }

  String? getLatestReadingRecordDate() {
    if (readingRecords.isEmpty) {
      return '';
    }
    return '${TimeUtil.relativeTime(
      readingRecords
          .reduce(
            (cur, next) =>
                cur.recordedAt.isBefore(next.recordedAt) ? next : cur,
          )
          .recordedAt,
      DateTime.now(),
    )} 전';
  }
}
