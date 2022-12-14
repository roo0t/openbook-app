import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openbook/src/book/book_detail_page.dart';
import 'package:openbook/src/book/book_vo.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import 'book_search_controller.dart';

class BookSearchPage extends StatelessWidget {
  const BookSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BookSearchController controller = Get.put(BookSearchController());

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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.center_focus_weak_outlined),
          onPressed: () async {
            final scanResult = await BarcodeScanner.scan(
              options: const ScanOptions(
                strings: {
                  "cancel": "취소",
                  "flash_on": "플래시 켜기",
                  "flash_off": "플래시 끄기",
                },
              ),
            );
            if (scanResult.type == ResultType.Barcode) {
              final isbn = scanResult.rawContent;
              controller.searchIsbn(isbn);
            }
          },
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: controller.searchTextController,
                      autofocus: true,
                      style: const TextStyle(
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText: '책 제목이나 저자, 출판사로 검색하세요',
                        border: InputBorder.none,
                        icon: const Padding(
                          padding: EdgeInsets.only(left: 13),
                          child: Icon(Icons.search),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: controller.clearSearchText,
                        ),
                      ),
                      onChanged: (text) => controller.search(text),
                    ),
                  ),
                ],
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
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            book.authors.map((authoring) {
                              if (authoring.role == null) {
                                return authoring.name;
                              } else {
                                return '${authoring.name} (${authoring.role})';
                              }
                            }).join(', '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(book.publisher),
                        ],
                      ),
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
