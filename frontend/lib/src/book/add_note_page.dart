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
                bool cameraIsInitialized = controller.cameraIsInitialized.value;
                return ListView.builder(
                  itemBuilder: (context, index) => buildPictureListItem(
                    context,
                    index,
                    cameraIsInitialized,
                  ),
                  itemCount: controller.pictures.length + 1,
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(),
                );
              }),
              height: MediaQuery.of(context).size.width,
            ),
            Center(
              child: Text('AddNotePage'),
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
              print('Initizlied: ${cameraIsInitialized}');
              if (cameraIsInitialized) {
                return cameraPreviewBox(cardSize, controller);
              } else {
                return uninitializedCameraBox(cardSize);
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

  Widget uninitializedCameraBox(double cardSize) {
    return SizedBox(
      width: cardSize,
      height: cardSize,
      child: const Center(
        child: Icon(
          Icons.add_a_photo_outlined,
          size: 30,
        ),
      ),
    );
  }

  Widget cameraPreviewBox(double cardSize, AddNoteController controller) {
    return InkWell(
        child: SizedBox(
          width: cardSize,
          height: cardSize,
          child: CameraPreview(
            controller.cameraController!,
          ),
        ),
        onTap: controller.takePicture);
  }
}
