import 'dart:math';

import 'package:flutter/material.dart';

import 'reading_record_controller.dart';

class ReadingRecordListPage extends StatelessWidget {
  final ReadingRecordController controller;

  const ReadingRecordListPage(
    this.controller, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    controller.book.title,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
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
              }
              return Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.readingRecords[index].startPage}-${controller.readingRecords[index].endPage}',
                      style: const TextStyle(fontSize: 26),
                    ),
                    const Text('3일 전'),
                  ],
                ),
              );
            },
            childCount: max(controller.readingRecords.length, 1),
          ),
        ),
      ],
    ));
  }
}
