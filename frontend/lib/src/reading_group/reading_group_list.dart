import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openbook/src/reading_group/reading_group_item.dart';
import 'package:openbook/src/reading_group/reading_group_vo.dart';

import 'reading_groups_test_data.dart';

class ReadingGroupList extends StatelessWidget {
  const ReadingGroupList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List readingGroupsList = jsonDecode(readingGroupsTestData);
    List<ReadingGroupVo> readingGroups =
        readingGroupsList.map((map) => ReadingGroupVo.fromJson(map)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "읽기 모임",
                style: Theme.of(context).textTheme.headline6,
              ),
              const Text("더 보기"),
            ],
          ),
        ),
        SizedBox(
          height: 260,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: readingGroups
                    .map((vo) => Center(
                          child: ReadingGroupItem(
                            readingGroup: vo,
                          ),
                        ))
                    .toList()),
          ),
        ),
      ],
    );
  }
}
