import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reading_record_add_controller.dart';
import 'reading_record_controller.dart';

class ReadingRecordAddPage extends StatelessWidget {
  final ReadingRecordController controller;
  late final ReadingRecordAddController addController;

  ReadingRecordAddPage({Key? key, required this.controller})
      : addController = ReadingRecordAddController(controller),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('독서 기록 추가'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: NetworkImage(controller.book.coverImageUrl),
                      width: 150,
                      height: 140,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      controller.book.title,
                      style: Theme.of(context).textTheme.headline6?.merge(
                            const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => buildPageInputField(
                        addController.startPageController,
                        addController.startPageFocusNode,
                        '읽기 시작한 페이지',
                        '몇 쪽부터 읽었나요?',
                        addController.startPageErrorString.value,
                        addController.state.value ==
                            ReadingRecordAddState.startPage,
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        child: buildPageInputField(
                          addController.endPageController,
                          addController.endPageFocusNode,
                          '마지막으로 읽은 페이지',
                          '몇 쪽까지 읽었나요?',
                          null,
                          addController.state.value ==
                              ReadingRecordAddState.endPage,
                        ),
                        visible: addController.state.value ==
                            ReadingRecordAddState.endPage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () => addController.turnToNextState(context),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                  ),
                  child: Obx(
                    () => Text(
                      addController.state.value ==
                              ReadingRecordAddState.startPage
                          ? '다음'
                          : '기록 추가하기',
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPageInputField(
      TextEditingController controller,
      FocusNode focusNode,
      String labelText,
      String hintText,
      String? errorText,
      bool isFocused) {
    return Column(
      children: [
        SizedBox(
            width: double.infinity,
            child: Text(
              labelText,
              style: TextStyle(
                color: isFocused ? Colors.white : Colors.grey,
              ),
            )),
        TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          focusNode: focusNode,
          style: TextStyle(
            color: isFocused ? Colors.white : Colors.grey,
            fontSize: 24,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
