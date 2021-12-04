import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'book_detail_page.dart';
import 'book_vo.dart';
import 'reading_books_test_data.dart';

class ReadingBookList extends StatelessWidget {
  const ReadingBookList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List readingBooksJson = jsonDecode(readingBooksTestData);
    List<BookVo> readingBooks =
        readingBooksJson.map((json) => BookVo.fromJson(json)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Text(
            "읽고 있는 책",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(
            height: 240,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  readingBooks.map((book) => buildListItem(book)).toList(),
            ))
      ],
    );
  }

  Widget buildListItem(BookVo book) {
    return InkWell(
      onTap: () => Get.to(
        () => BookDetailPage(book: book),
        transition: Transition.fadeIn,
      ),
      child: Container(
        width: 140,
        padding: const EdgeInsets.only(left: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: book.isbn,
              child: Image.network(
                book.coverImageUrl,
                height: 180,
              ),
            ),
            Text(
              book.title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
