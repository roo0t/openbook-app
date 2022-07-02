import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import 'note_vo.dart';

class PageSliderController extends GetxController {
  final int totalPages;
  final List<NoteVo> notes;
  RxInt page = 0.obs;
  final void Function(PageTurnDetails)? onPageTurn;
  Rxn<ui.Image> coverImage = Rxn<ui.Image>();

  PageSliderController({
    required this.totalPages,
    required this.notes,
    required this.onPageTurn,
  });

  void to(int page) {
    this.page(page);
    onPageTurn?.call(PageTurnDetails(page));
  }

  loadCoverImage(String url) async {
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

class PageTurnDetails {
  final int currentPage;

  PageTurnDetails(this.currentPage);
}

class PageSlider extends StatelessWidget {
  final String coverImageUrl;
  final int totalPages;
  final List<NoteVo> notes;
  late final List<int> _pagesWithNotes;
  final void Function(PageTurnDetails)? onPageTurn;

  PageSlider({
    Key? key,
    required this.coverImageUrl,
    required this.totalPages,
    required this.notes,
    this.onPageTurn,
  }) : super(key: key) {
    _pagesWithNotes = notes.map((note) => note.page).toSet().toList();
    _pagesWithNotes.sort();
  }

  void _handleTap(double x, Rect sliderRect, PageSliderController controller) {
    if (x < sliderRect.left) {
      controller.to(0);
    } else if (x < sliderRect.right) {
      final int tappedPage =
          ((x - sliderRect.left) / sliderRect.width * totalPages).toInt();
      final int? nearestPageWithNote = _findNearestPageWithNote(tappedPage);
      if (nearestPageWithNote != null) {
        controller.to(nearestPageWithNote);
      }
    } else {
      controller.to(-1);
    }
  }

  int? _findNearestPageWithNote(int currentPage) {
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PageSliderController>(
      init: PageSliderController(
        totalPages: totalPages,
        notes: notes,
        onPageTurn: onPageTurn,
      ),
      builder: (controller) {
        controller.loadCoverImage(coverImageUrl);
        return LayoutBuilder(builder: (context, constraints) {
          final double widgetWidth = constraints.maxWidth;
          final double widgetHeight = constraints.maxHeight;

          final double coverHeight = widgetHeight;
          final double coverWidth = coverHeight * (2.0 / 3.0);
          final Rect frontCoverRect =
              Rect.fromLTWH(0, 0, coverWidth, coverHeight);
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
                onHorizontalDragStart: (DragStartDetails details) => _handleTap(
                    details.localPosition.dx, sliderRect, controller),
                onHorizontalDragUpdate: (DragUpdateDetails details) =>
                    _handleTap(
                        details.localPosition.dx, sliderRect, controller),
                onTapUp: (TapUpDetails details) => _handleTap(
                    details.localPosition.dx, sliderRect, controller),
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
                  child: CustomPaint(
                    painter: PageSliderPainter(
                      coverImage: controller.coverImage.value,
                      page: controller.page.value,
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
      },
    );
  }
}

class NotePosition {
  final int page;

  NotePosition({required this.page});
}

class PageSliderPainter extends CustomPainter {
  int page;
  final ui.Image? coverImage;
  final int totalPages;
  final List<NotePosition> notePositions;
  final Color noteColor = const Color(0xFF228822);
  final Rect sliderRect;
  final Rect frontCoverRect;
  final Rect backCoverRect;

  PageSliderPainter({
    required this.coverImage,
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
    final double coverImageHeight = size.height;
    final double coverImageWidth = coverImageHeight * (2.0 / 3.0);

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

    // Draw slider
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as PageSliderPainter).page != page;
  }
}
