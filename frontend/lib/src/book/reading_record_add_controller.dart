import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  turnToNextState() {
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
        break;
    }
  }
}
