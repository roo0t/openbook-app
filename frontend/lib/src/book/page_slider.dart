import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageSliderController extends GetxController {
  final int totalPages;
  RxInt page = 0.obs;

  PageSliderController({required this.totalPages});

  nextPage() {
    page(page.value + 1);
  }

  to(int page) {
    this.page(page);
  }
}

class PageTurnDetails {
  final int currentPage;

  PageTurnDetails(this.currentPage);
}

class PageSlider extends StatelessWidget {
  final int totalPages;
  final void Function(PageTurnDetails)? onPageTurn;

  const PageSlider({
    Key? key,
    required this.totalPages,
    this.onPageTurn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PageSliderController(totalPages: totalPages));

    return GetBuilder<PageSliderController>(
      builder: (controller) {
        return LayoutBuilder(builder: (context, constraints) {
          final double widgetWidth = constraints.maxWidth;
          return SizedBox(
            width: widgetWidth,
            child: Obx(
              () => GestureDetector(
                onHorizontalDragStart: (DragStartDetails details) =>
                    controller.to(
                  (details.localPosition.dx / widgetWidth * totalPages).toInt(),
                ),
                onHorizontalDragUpdate: (DragUpdateDetails details) =>
                    controller.to(
                  (details.localPosition.dx / widgetWidth * totalPages).toInt(),
                ),
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
                  child: CustomPaint(
                    painter: PageSliderPainter(
                        page: controller.page.value, totalPages: totalPages),
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

class PageSliderPainter extends CustomPainter {
  int page;
  final int totalPages;

  PageSliderPainter({required this.page, required this.totalPages});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset((page / totalPages * size.width).toDouble(), 0),
      Offset((page / totalPages * size.width).toDouble(), size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as PageSliderPainter).page != page;
  }
}
