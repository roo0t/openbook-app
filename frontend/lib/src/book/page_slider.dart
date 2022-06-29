import 'dart:async';

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

  to(int page) {
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
  final void Function(PageTurnDetails)? onPageTurn;

  const PageSlider({
    Key? key,
    required this.coverImageUrl,
    required this.totalPages,
    required this.notes,
    this.onPageTurn,
  }) : super(key: key);

  void handleTap(double x, Rect sliderRect, PageSliderController controller) {
    if (x < sliderRect.left) {
      controller.to(0);
    } else if (x < sliderRect.right) {
      controller.to(
        ((x - sliderRect.left) / sliderRect.width * totalPages).toInt(),
      );
    } else {
      controller.to(controller.totalPages);
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
                onHorizontalDragStart: (DragStartDetails details) =>
                    handleTap(details.localPosition.dx, sliderRect, controller),
                onHorizontalDragUpdate: (DragUpdateDetails details) =>
                    handleTap(details.localPosition.dx, sliderRect, controller),
                onTapUp: (TapUpDetails details) =>
                    handleTap(details.localPosition.dx, sliderRect, controller),
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

  double calculateHorizontalPosition(Rect rect, double normalizedValue) {
    return rect.left + rect.width * normalizedValue;
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
    Paint currentPagePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    if (0 < page && page < totalPages) {
      var currentPageX =
          calculateHorizontalPosition(sliderRect, page / totalPages);
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
      var x = calculateHorizontalPosition(
          sliderRect, notePosition.page / totalPages);
      const double y = 10;
      canvas.drawCircle(Offset(x, y), 1, notePositionPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as PageSliderPainter).page != page;
  }
}
