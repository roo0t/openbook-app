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
  final ReadingRecordController _controller;
  final TextEditingController startPageController = TextEditingController();
  final TextEditingController endPageController = TextEditingController();
  final ScrollController scrollViewController = ScrollController();
  final FocusNode startPageFocusNode = FocusNode();
  final FocusNode endPageFocusNode = FocusNode();

  Rx<ReadingRecordAddState> state = ReadingRecordAddState.startPage.obs;
  Rx<String?> startPageErrorString = "".obs;
  Rx<String?> endPageErrorString = "".obs;

  final BookVo book;

  ReadingRecordAddController(this._controller) : book = _controller.book;

  @override
  void onInit() {
    startPageController.addListener(() {
      startPageErrorString(null);
    });
    startPageFocusNode.addListener(() {
      if (startPageFocusNode.hasFocus) {
        state(ReadingRecordAddState.startPage);
        startPageController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: startPageController.text.length,
          ),
        );
      }
    });
    super.onInit();
  }

  @override
  onClose() {
    startPageFocusNode.dispose();
    endPageFocusNode.dispose();
    super.onClose();
  }

  turnToNextState(BuildContext context) async {
    switch (state.value) {
      case ReadingRecordAddState.startPage:
        if (startPageController.text.isEmpty) {
          startPageErrorString('시작 페이지를 입력해주세요.');
        } else {
          int? startPage = int.tryParse(startPageController.text);
          if (startPage == null) {
            startPageErrorString('숫자만 입력해주세요.');
          } else if (startPage <= 0) {
            startPageErrorString('0보다 큰 수를 입력해주세요.');
          } else if (startPage > _controller.book.totalPages) {
            startPageErrorString('시작 페이지는 총 페이지 수보다 작아야 합니다.');
          } else {
            startPageErrorString('');
            state(ReadingRecordAddState.endPage);
            endPageFocusNode.requestFocus();
            Future.delayed(
              const Duration(milliseconds: 100),
              () => scrollViewController.animateTo(
                scrollViewController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 100),
                curve: Curves.ease,
              ),
            );
          }
        }
        break;
      case ReadingRecordAddState.endPage:
        if (endPageController.text.isEmpty) {
          endPageErrorString('끝 페이지를 입력해 주세요.');
        } else {
          int startPage = int.parse(startPageController.text);
          int? endPage = int.tryParse(endPageController.text);
          if (endPage == null) {
            endPageErrorString('숫자만 입력해주세요.');
          } else if (startPage <= 0) {
            endPageErrorString('0보다 큰 수를 입력해주세요.');
          } else if (endPage > _controller.book.totalPages) {
            endPageErrorString('끝 페이지는 총 페이지 수보다 작아야 합니다.');
          } else if (endPage < startPage) {
            endPageErrorString('끝 페이지는 시작 페이지보다 클 수 없어요.');
          } else {
            endPageErrorString('');
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
                  content: Text('오류가 발생했습니다.'),
                ),
              );
            }
          }
        }
        break;
    }
  }

  Future<ReadingRecordVo?> addReadingRecord() async {
    return await _controller.addRecord(
      int.parse(startPageController.text),
      int.parse(endPageController.text),
    );
  }
}
