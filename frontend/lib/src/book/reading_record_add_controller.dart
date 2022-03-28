import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../wait_dialog.dart';
import 'book_vo.dart';
import 'reading_record_controller.dart';
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
    return await Get.find<ReadingRecordController>().addRecord(
      int.parse(startPageController.text),
      int.parse(endPageController.text),
    );
  }
}
