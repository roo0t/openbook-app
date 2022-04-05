import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openbook/src/reading_group/reading_group_list.dart';
import 'package:openbook/src/timer/timer_page.dart';
import 'package:openbook/src/white_logo_image.dart';

import 'book/reading_book_list.dart';
import 'book/reading_book_list_controller.dart';
import 'book_search/book_search_page.dart';
import 'user/sign_in_page.dart';
import 'user/user_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: WhiteLogoImage(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: '검색',
            onPressed: () => Get.to(
              () => const BookSearchPage(),
            ),
          ),
        ],
      ),
      drawer: buildDrawer(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: const ReadingGroupList(),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: GetBuilder<ReadingBookListController>(
              init: ReadingBookListController(),
              builder: (_) => const ReadingBookList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(
          () => const TimerPage(),
          transition: Transition.zoom,
        ),
        tooltip: 'Timer',
        child: const Icon(Icons.access_alarm_outlined),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: Image.network('https://picsum.photos/60'),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 3),
                  child: Text(
                    'Austin',
                    style: Theme.of(context).textTheme.headline5?.merge(
                          const TextStyle(
                            color: Color(0xFFFAFAFA),
                          ),
                        ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 7, left: 3),
                  child: Text(
                    'test@glowingreaders.club',
                    style: Theme.of(context).textTheme.bodyText1?.merge(
                          const TextStyle(
                            color: Color(0xFFBBBBBB),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('로그아웃'),
            onTap: () {
              Get.find<UserController>().signOut();
              Get.offAll(() => const SignInPage());
            },
          ),
        ],
      ),
    );
  }
}
