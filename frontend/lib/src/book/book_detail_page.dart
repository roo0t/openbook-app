import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../expandable_text_widget.dart';
import '../time_util.dart';
import 'add_note_page.dart';
import 'book_detail_controller.dart';
import 'reading_record_list_page.dart';
import 'book_vo.dart';
import 'note_photo_gallery.dart';
import 'note_vo.dart';
import 'page_slider.dart';
import 'reading_record_controller.dart';

class BookDetailPage extends StatelessWidget {
  final BookVo book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookDetailController>(
        init: BookDetailController(),
        builder: (controller) {
          controller.loadNotes(book);

          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      controller: controller.scrollController,
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
                  Obx(
                    () => SizedBox(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PageSlider(
                          coverImageUrl: book.coverImageUrl,
                          totalPages: book.totalPages,
                          notes: controller.notes[book.isbn] ?? [],
                          onPageTurn: (pageTurnDetails) {
                            var pages =
                                (controller.noteKeys[book.isbn]?.keys ?? [])
                                    .toList();
                            pages.sort();
                            int? nearestPage = findNearestPage(
                                pages, pageTurnDetails.currentPage);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  NoteVo note = await Get.to(() => AddNotePage(book: book));
                  controller.addNote(book, note);
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
          );
        });
  }

  Widget buildNoteList() {
    BookDetailController controller = Get.find<BookDetailController>();
    return Obx(
      () {
        List<int> pages =
            controller.notes[book.isbn]?.map((note) => note.page).toList() ??
                [];
        List<int> indices = [];
        int uniquePageCount = 0;
        for (int i = 0; i < pages.length; i++) {
          if (i == 0 || pages[i] != pages[i - 1]) {
            indices.add(-pages[i]);
            uniquePageCount++;
          }
          indices.add(i);
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (indices[index] < 0) {
                return buildNoteListPageHeader(context, -indices[index],
                    controller.noteKeys[book.isbn]![-indices[index]]!);
              } else {
                NoteVo note = controller.notes[book.isbn]![indices[index]];
                return SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child:
                                      Image.network("https://picsum.photos/40"),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(note.authorNickname),
                                  Text(
                                    '${TimeUtil.relativeTime(
                                      note.createdAt,
                                      DateTime.now(),
                                    )} 전',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('${note.page}쪽'),
                              ),
                              const Icon(Icons.more_horiz_outlined),
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: NotePhotoGallery(photoUrls: note.imageUris),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ExpandableText(note.content),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            childCount:
                (controller.notes[book.isbn]?.length ?? 0) + uniquePageCount,
          ),
        );
      },
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
      child: GetBuilder<ReadingRecordController>(
          init: ReadingRecordController(book),
          builder: (readingRecordController) {
            return InkWell(
              onTap: () => Get.to(
                () => const ReadingRecordListPage(),
              ),
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
                          child: Obx(
                            () => Text(
                              '${(readingRecordController.totalReadPages / book.totalPages * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                '${book.totalPages}쪽 중 ${readingRecordController.totalReadPages}쪽 읽었습니다.',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Obx(
                              () => Text(
                                readingRecordController
                                    .latestReadingRecordDate.value,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
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
            );
          }),
    );
  }

  Widget buildNoteListPageHeader(
      BuildContext context, int page, GlobalKey key) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        key: key,
        margin: const EdgeInsets.only(bottom: 10, left: 2, right: 2),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Text(
            '$page쪽',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }

  Map<int, GlobalKey> generateNoteKeys(List<NoteVo> notes) {
    Map<int, GlobalKey> noteKeys = {};
    notes.map((note) => note.page).toSet().forEach((page) {
      noteKeys[page] = GlobalKey(debugLabel: page.toString());
    });
    return noteKeys;
  }

  int? findNearestPage(List<int> pages, int currentPage) {
    if (pages.isEmpty) return null;
    int start = 0;
    int end = pages.length;
    while (start < end - 1) {
      int mid = ((start + end) / 2).floor();
      if (pages[mid] <= currentPage) {
        start = mid;
      } else {
        end = mid;
      }
    }

    if (pages[start] == currentPage || start == pages.length - 1) {
      return currentPage;
    } else if (currentPage - pages[start] < pages[start + 1] - currentPage) {
      return pages[start];
    } else {
      return pages[start + 1];
    }
  }
}
