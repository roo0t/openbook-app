import 'package:flutter/material.dart';
import 'package:openbook/src/reading_group/member_vo.dart';
import 'package:openbook/src/reading_group/reading_group_vo.dart';

class ReadingGroupDetailPage extends StatelessWidget {
  final ReadingGroupVo readingGroup;

  const ReadingGroupDetailPage({Key? key, required this.readingGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildAppBar(),
          buildTitle(context),
        ],
      ),
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: true,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          readingGroup.name,
        ),
        background: Hero(
          tag: readingGroup.id,
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(readingGroup.imageUrl),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter buildTitle(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "모임 정보",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  readingGroup.occurringAt,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text(
                    "함께 읽는 사람들",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: SizedBox(
                    width: double.infinity,
                    height: 110,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: readingGroup.members
                            .map((member) => buildMemberProfile(member))
                            .toList()),
                  ),
                )
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget buildMemberProfile(MemberVo member) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      child: Column(
        children: [
          SizedBox(
            width: 82,
            height: 82,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x32000000),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: Image.network(member.profilePictureUrl),
                ),
              ),
            ),
          ),
          Text(member.name),
        ],
      ),
    );
  }
}
