import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openbook/src/reading_group/reading_group_detail_page.dart';
import 'package:openbook/src/reading_group/reading_group_vo.dart';

class ReadingGroupItem extends StatelessWidget {
  final ReadingGroupVo readingGroup;

  const ReadingGroupItem({Key? key, required this.readingGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
        () => ReadingGroupDetailPage(readingGroup: readingGroup),
        transition: Transition.fadeIn,
      ),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 4,
                color: Color(0x11000000),
              )
            ]),
        child: SizedBox(
          width: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Hero(
                    tag: readingGroup.id,
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        readingGroup.imageUrl,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      readingGroup.name,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      readingGroup.occurringAt,
                      style: const TextStyle(height: 1.5),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
