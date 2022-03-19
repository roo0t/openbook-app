import 'dart:math';

import 'package:flutter/material.dart';

import '../expandable_text_widget.dart';
import 'book_vo.dart';
import 'note_photo_gallery.dart';
import 'note_vo.dart';
import 'page_slider.dart';

class BookDetailPage extends StatelessWidget {
  final BookVo book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                buildAppBar(),
                buildTagList(),
                buildInformationSection(),
                buildDivider(),
                buildRecordSummarySection(),
                buildDivider(),
                buildNoteList(),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: PageSlider(
              totalPages: book.totalPages,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: const Icon(Icons.create)),
    );
  }

  SliverList buildNoteList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          NoteVo note = book.notes[index];
          return SizedBox(
            width: double.infinity,
            child: Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: Image.network("https://picsum.photos/40"),
                          ),
                        ),
                        Text(note.author),
                        const Spacer(),
                        const Icon(Icons.more_horiz_outlined),
                      ],
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: NotePhotoGallery(photoUrls: note.pictureUrls),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ExpandableText(note.text),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: book.notes.length,
      ),
    );
  }

  SliverToBoxAdapter buildDivider() =>
      const SliverToBoxAdapter(child: Divider());

  SliverToBoxAdapter buildInformationSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Text(book.authors.map((authoring) {
            return authoring.name +
                (authoring.role == null ? "" : "(${authoring.role})");
          }).join(', ')),
          Text('${book.publisher} (${book.publishedOn})'),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: ExpandableText(
                book.description,
                textAlign: TextAlign.justify,
                maxLines: 5,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildTagList() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: book.tags.map(
              (tag) {
                Color backgroundColor =
                    Colors.primaries[Random().nextInt(Colors.primaries.length)];
                Color textColor = backgroundColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white;
                return Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Chip(
                    label: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1,
                        color: textColor,
                      ),
                    ),
                    backgroundColor: backgroundColor,
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          book.title,
        ),
        background: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Opacity(
                opacity: 0.2,
                child: Image.network(
                  book.coverImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Hero(
                tag: book.isbn,
                child: Image.network(
                  book.coverImageUrl,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildRecordSummarySection() {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 10.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      '45%',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '365쪽 중 164쪽 읽었습니다.',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '3일 전',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
