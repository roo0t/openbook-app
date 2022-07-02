import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import 'note_vo.dart';

class PageSliderController extends GetxController {
  final int totalPages;
  final List<NoteVo> notes;
  final RxInt nearestPageWithNote = 0.obs;
  final RxBool showHint = false.obs;
  RxInt page = 0.obs;
  final void Function(PageTurnDetails)? onPageTurn;
  Rxn<ui.Image> coverImage = Rxn<ui.Image>();
  List<int> _pagesWithNotes = [];

  PageSliderController({
    required this.totalPages,
    required this.notes,
    required this.onPageTurn,
  }) {
    setNotes(notes);
  }

  void to(int page) {
    this.page(page);
    nearestPageWithNote(_findNearestPageWithNote(page));
  }

  void confirmTurn() {
    page(nearestPageWithNote.value);
    onPageTurn?.call(PageTurnDetails(page.value));
  }

  void setShowHint(bool show) {
    showHint(show);
  }

  loadCoverImage(String url) async {
    if (coverImage.value == null) {
      var completer = Completer<ImageInfo>();
      var img = NetworkImage(url);
      img.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener(
              (info, _) => completer.complete(info),
            ),
          );
      ImageInfo imageInfo = await completer.future;
      ui.Image imageData = imageInfo.image;
      coverImage(imageData);
    }
  }

  int? _findNearestPageWithNote(int currentPage) {
    if (currentPage <= 0) return currentPage;
    if (_pagesWithNotes.isEmpty) return null;
    int start = 0;
    int end = _pagesWithNotes.length;
    while (start < end - 1) {
      int mid = ((start + end) / 2).floor();
      if (_pagesWithNotes[mid] <= currentPage) {
        start = mid;
      } else {
        end = mid;
      }
    }

    if (_pagesWithNotes[start] == currentPage ||
        start == _pagesWithNotes.length - 1) {
      return currentPage;
    } else if (currentPage - _pagesWithNotes[start] <
        _pagesWithNotes[start + 1] - currentPage) {
      return _pagesWithNotes[start];
    } else {
      return _pagesWithNotes[start + 1];
    }
  }

  void setNotes(List<NoteVo> notes) {
    _pagesWithNotes = notes.map((note) => note.page).toSet().toList();
    _pagesWithNotes.sort();
  }
}

class PageTurnDetails {
  final int currentPage;

  PageTurnDetails(this.currentPage);
}

class PageSlider extends StatelessWidget {
  final String coverImageUrl;
  final int totalPages;
  final List<NoteVo> notes;
  final void Function(PageTurnDetails)? onPageTurn;

  const PageSlider({
    Key? key,
    required this.coverImageUrl,
    required this.totalPages,
    required this.notes,
    this.onPageTurn,
  }) : super(key: key);

  int getPageFromX(double x, Rect sliderRect) {
    if (x < sliderRect.left) {
      return 0;
    } else if (x < sliderRect.right) {
      return ((x - sliderRect.left) / sliderRect.width * totalPages).toInt();
    } else {
      return -1;
    }
  }

  void _handleTap(double x, Rect sliderRect, PageSliderController controller) {
    controller.to(getPageFromX(x, sliderRect));
    controller.confirmTurn();
  }

  _handleDrag(double x, Rect sliderRect, PageSliderController controller) {
    int page = getPageFromX(x, sliderRect);
    controller.to(page);
    controller.setShowHint(page > 0);
  }

  _handleDragEnd(PageSliderController controller) {
    controller.setShowHint(false);
    controller.confirmTurn();
  }

  @override
  Widget build(BuildContext context) {
    PageSliderController controller = Get.put(PageSliderController(
      totalPages: totalPages,
      notes: notes,
      onPageTurn: onPageTurn,
    ));
    controller.setNotes(notes);
    controller.loadCoverImage(coverImageUrl);
    return LayoutBuilder(builder: (context, constraints) {
      final double widgetWidth = constraints.maxWidth;
      final double widgetHeight = constraints.maxHeight;

      final double coverHeight = widgetHeight;
      final double coverWidth = coverHeight * (2.0 / 3.0);
      final Rect frontCoverRect = Rect.fromLTWH(0, 0, coverWidth, coverHeight);
      final Rect backCoverRect = Rect.fromLTWH(
        widgetWidth - coverWidth,
        0,
        coverWidth,
        coverHeight,
      );
      const double coverSliderSpacing = 8;
      final Rect sliderRect = Rect.fromLTWH(
        coverWidth + coverSliderSpacing,
        0,
        widgetWidth -
            frontCoverRect.width -
            backCoverRect.width -
            2 * coverSliderSpacing,
        widgetHeight,
      );

      return SizedBox(
        width: widgetWidth,
        child: Obx(
          () => GestureDetector(
            onPanStart: (DragStartDetails details) =>
                _handleDrag(details.localPosition.dx, sliderRect, controller),
            onPanUpdate: (DragUpdateDetails details) =>
                _handleDrag(details.localPosition.dx, sliderRect, controller),
            onPanEnd: (DragEndDetails details) => _handleDragEnd(controller),
            onTapDown: (TapDownDetails details) =>
                _handleDrag(details.localPosition.dx, sliderRect, controller),
            onTapUp: (TapUpDetails details) =>
                _handleTap(details.localPosition.dx, sliderRect, controller),
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
              child: CustomPaint(
                painter: PageSliderPainter(
                  context,
                  coverImage: controller.coverImage.value,
                  page: controller.page.value,
                  hintPage: controller.showHint.value
                      ? controller.nearestPageWithNote.value
                      : null,
                  totalPages: totalPages,
                  frontCoverRect: frontCoverRect,
                  backCoverRect: backCoverRect,
                  sliderRect: sliderRect,
                  notePositions: notes
                      .map<NotePosition>(
                          (note) => NotePosition(page: note.page))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class NotePosition {
  final int page;

  NotePosition({required this.page});
}

class PageSliderPainter extends CustomPainter {
  final int? hintPage;
  final int page;
  final ui.Image? coverImage;
  final int totalPages;
  final List<NotePosition> notePositions;
  final Color noteColor = const Color(0xFF228822);
  final Rect sliderRect;
  final Rect frontCoverRect;
  final Rect backCoverRect;
  final BuildContext context;

  PageSliderPainter(
    this.context, {
    required this.coverImage,
    required this.hintPage,
    required this.page,
    required this.totalPages,
    required this.notePositions,
    required this.sliderRect,
    required this.frontCoverRect,
    required this.backCoverRect,
  });

  double calculateHorizontalPosition(Rect rect, int page) {
    return rect.left + rect.width * (page - 1) / (totalPages - 1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawCovers(canvas);
    drawTickers(size, canvas);
    drawCurrentPage(canvas, size);
    drawNotePositions(canvas);
    drawPageHint(canvas, size);
  }

  void drawNotePositions(Canvas canvas) {
    Paint notePositionPaint = Paint()
      ..color = noteColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;
    for (NotePosition notePosition in notePositions) {
      var x = calculateHorizontalPosition(sliderRect, notePosition.page);
      const double y = 10;
      const double triangleWidth = 4;
      final Path path = Path()
        ..moveTo(x, y)
        ..lineTo(x - triangleWidth / 2, y - triangleWidth / cos(pi / 6))
        ..lineTo(x + triangleWidth / 2, y - triangleWidth / cos(pi / 6))
        ..close();
      canvas.drawPath(path, notePositionPaint);
    }
  }

  void drawCurrentPage(Canvas canvas, Size size) {
    final Paint currentPagePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    if (0 < page && page < totalPages) {
      var currentPageX = calculateHorizontalPosition(sliderRect, page);
      canvas.drawLine(
        Offset(currentPageX, 0),
        Offset(currentPageX, size.height),
        currentPagePaint,
      );
    }
  }

  void drawTickers(Size size, Canvas canvas) {
    const double tickerInterval = 1;
    final Paint tickerPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.5;
    const double tickerYStart = 10;
    final double tickerYEnd = size.height - 10;
    double previousX = -double.infinity;
    for (int page = 1; page < totalPages; ++page) {
      final double x = calculateHorizontalPosition(sliderRect, page);
      if (page == 1 ||
          (x / tickerInterval).floor() !=
              (previousX / tickerInterval).floor()) {
        canvas.drawLine(
          Offset(x, tickerYStart),
          Offset(x, tickerYEnd),
          tickerPaint,
        );
      }
      previousX = x;
    }
  }

  void drawCovers(Canvas canvas) {
    // Draw cover image
    if (coverImage != null) {
      paintImage(
          canvas: canvas,
          rect: frontCoverRect,
          image: coverImage!,
          fit: BoxFit.scaleDown,
          repeat: ImageRepeat.noRepeat,
          alignment: Alignment.center,
          flipHorizontally: false,
          filterQuality: FilterQuality.high);
    }
    Paint unselectedCoverImageBoundaryPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    Paint selectedCoverImageBoundaryPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(
        frontCoverRect,
        page == 0
            ? selectedCoverImageBoundaryPaint
            : unselectedCoverImageBoundaryPaint);

    // Draw back cover
    canvas.drawRect(
        backCoverRect,
        page == totalPages
            ? selectedCoverImageBoundaryPaint
            : unselectedCoverImageBoundaryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as PageSliderPainter).page != page;
  }

  void drawPageHint(Canvas canvas, Size size) {
    if (hintPage != null) {
      final double x = calculateHorizontalPosition(sliderRect, hintPage!);
      const double y = -9;
      const double boxWidth = 40;
      const double boxHeight = 25;
      final Paint draggingPagePaint = Paint()
        ..color = Theme.of(context).primaryColor
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, y),
            width: boxWidth,
            height: boxHeight,
          ),
          const Radius.circular(2),
        ),
        draggingPagePaint,
      );
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${hintPage!}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: boxWidth, maxWidth: boxWidth);
      textPainter.paint(canvas, Offset(x - boxWidth / 2, y - 8));
    }
  }
}
