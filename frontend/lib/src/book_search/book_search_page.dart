import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openbook/src/book/book_detail_page.dart';
import 'package:openbook/src/book/book_vo.dart';

import 'book_search_controller.dart';

class BookSearchPage extends StatelessWidget {
  const BookSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BookSearchController());

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("책 검색"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Get.back(),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: '책 제목이나 저자, 출판사로 검색하세요',
                    border: InputBorder.none,
                    icon: Padding(
                        padding: EdgeInsets.only(left: 13),
                        child: Icon(Icons.search))),
                onChanged: (text) =>
                    Get.find<BookSearchController>().search(text),
              ),
              Expanded(
                child: Obx(
                  () => ListView(
                      children: Get.find<BookSearchController>()
                          .searchResults
                          .map(
                            (book) => buildSearchResultCard(book),
                          )
                          .toList()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchResultCard(BookVo book) {
    return Card(
      child: InkWell(
        onTap: () => Get.to(() => BookDetailPage(book: book)),
        child: SizedBox(
          width: double.infinity,
          height: 150,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Image.network(book.coverImageUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(book.authors.map((authoring) {
                        if (authoring.role == null) {
                          return authoring.name;
                        } else {
                          return '${authoring.name} (${authoring.role})';
                        }
                      }).join(', ')),
                      Text(book.publisher),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.favorite_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
