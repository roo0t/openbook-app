import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../backend_uris.dart';
import '../user/sign_in_page.dart';
import '../user/user_controller.dart';
import '../wait_dialog.dart';
import 'book_vo.dart';
import 'reading_record_vo.dart';

enum ReadingRecordAddState {
  startPage,
  endPage,
}

class ReadingRecordAddController extends GetxController {
  final TextEditingController startPageController = TextEditingController();
  final TextEditingController endPageController = TextEditingController();
  final FocusNode startPageFocusNode = FocusNode();
  final FocusNode endPageFocusNode = FocusNode();

  Rx<ReadingRecordAddState> state = ReadingRecordAddState.startPage.obs;
  Rx<String?> startPageErrorString = "".obs;

  final BookVo book;

  ReadingRecordAddController(this.book);

  @override
  onInit() {
    startPageController.addListener(() {
      startPageErrorString(null);
    });
    startPageFocusNode.addListener(() {
      if (startPageFocusNode.hasFocus) {
        state(ReadingRecordAddState.startPage);
      }
    });
    super.onInit();
  }

  turnToNextState(BuildContext context) async {
    switch (state.value) {
      case ReadingRecordAddState.startPage:
        if (startPageController.text.isEmpty) {
          startPageErrorString('시작 페이지를 입력해주세요.');
        } else {
          state(ReadingRecordAddState.endPage);
          endPageFocusNode.requestFocus();
        }
        break;
      case ReadingRecordAddState.endPage:
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WaitDialog(),
        );
        ReadingRecordVo? addedReadingRecord = await addReadingRecord();
        Navigator.pop(context); // Hide loading dialog
        if (addedReadingRecord != null) {
          Get.back();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('오류가 발생하였습니다.'),
            ),
          );
        }
        break;
    }
  }

  Future<ReadingRecordVo?> addReadingRecord() async {
    try {
      final response =
          await http.put(BackendUris.getReadingRecordsUri(book.isbn),
              body: jsonEncode({
                "startPage": startPageController.text,
                "endPage": endPageController.text,
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
}
