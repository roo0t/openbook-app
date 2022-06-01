import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_note_controller.dart';

class AddNotePage extends StatelessWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('독서 노트 작성'),
        elevation: 0,
      ),
      body: GetBuilder<AddNoteController>(
        init: AddNoteController(),
        builder: (controller) => Column(
          children: [
            SizedBox(
              child: Obx(() {
                bool shouldShowCameraPreview =
                    controller.shouldShowCameraPreview.value;
                return ListView.builder(
                  itemBuilder: (context, index) => buildPictureListItem(
                    context,
                    index,
                    shouldShowCameraPreview,
                  ),
                  itemCount: controller.pictures.length + 1,
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(),
                );
              }),
              height: MediaQuery.of(context).size.width,
            ),
            Center(
              child: TextField(
                controller: controller.textEditingController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPictureListItem(context, index, cameraIsInitialized) {
    AddNoteController controller = Get.find<AddNoteController>();

    final double screenWidth = MediaQuery.of(context).size.width;
    const double cardPadding = 24.0;
    final double cardSize = screenWidth - 2 * cardPadding - 8;
    return Padding(
      padding: const EdgeInsets.all(cardPadding),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Builder(
          builder: (context) {
            if (index >= controller.pictures.length) {
              if (cameraIsInitialized) {
                return cameraPreviewBox(context, cardSize, controller);
              } else {
                return newPictureBox(cardSize);
              }
            } else {
              var imageFile = File(controller.pictures[index]);
              return pictureBox(cardSize, imageFile);
            }
          },
        ),
      ),
    );
  }

  SizedBox pictureBox(double cardSize, File imageFile) {
    return SizedBox(
      width: cardSize,
      height: cardSize,
      child: Image.file(imageFile),
    );
  }

  Widget newPictureBox(double cardSize) {
    return InkWell(
      onTap: () => Get.find<AddNoteController>().showCameraPreview(),
      child: SizedBox(
        width: cardSize,
        height: cardSize,
        child: const Center(
          child: Icon(
            Icons.add_a_photo_outlined,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget cameraPreviewBox(
      context, double cardSize, AddNoteController controller) {
    return InkWell(
        child: Stack(
          children: [
            SizedBox(
              width: cardSize,
              height: cardSize,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                      width: cardSize,
                      height: cardSize *
                          controller.cameraController!.value.aspectRatio,
                      child: CameraPreview(
                        controller.cameraController!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Icon(Icons.close),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      primary: Colors.white, // <-- Button color
                      onPrimary: Colors.grey, // <-- Splash color
                    ),
                    onPressed: () => controller.hideCameraPreview(),
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: controller.takePicture);
  }
}
