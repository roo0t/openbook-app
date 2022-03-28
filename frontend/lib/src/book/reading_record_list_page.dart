import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reading_record_add_page.dart';
import 'reading_record_controller.dart';

class ReadingRecordListPage extends StatelessWidget {
  const ReadingRecordListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Get.to(
            () => ReadingRecordAddPage(),
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              collapsedHeight: 65,
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '독서 기록',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        Get.find<ReadingRecordController>().book.title,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final controller = Get.find<ReadingRecordController>();
                    if (controller.readingRecords.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            '독서 기록이 없습니다. 이제 읽어볼까요?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    } else {
                      if (index % 2 == 0) {
                        final int itemIndex = index ~/ 2;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${controller.readingRecords[itemIndex].startPage} - ${controller.readingRecords[itemIndex].endPage}쪽',
                                style: const TextStyle(fontSize: 26),
                              ),
                              const Text('3일 전'),
                            ],
                          ),
                        );
                      } else {
                        return const Divider(color: Colors.grey);
                      }
                    }
                  },
                  childCount: max(
                    Get.find<ReadingRecordController>().readingRecords.length *
                            2 -
                        1,
                    1,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
