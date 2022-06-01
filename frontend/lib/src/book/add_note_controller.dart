import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';

class AddNoteController extends GetxController {
  RxList<String> pictures = <String>[].obs;
  late final CameraDescription _camera;
  late final CameraController? cameraController;
  final RxBool cameraIsInitialized = false.obs;

  @override
  void onInit() async {
    super.onInit();

    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      cameraController = null;
      return;
    } else {
      _camera = cameras.first;
      cameraController = CameraController(
        _camera,
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );
      await cameraController?.initialize();
      cameraIsInitialized(true);
    }
  }

  Future<String> cropPictureToSquare(String filePath) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(filePath);

    int? width = properties.width;
    int? height = properties.height;
    if (width == null || height == null) {
      return filePath;
    }
    var offset = (height - width) / 2;

    File croppedFile = await FlutterNativeImage.cropImage(
        filePath, 0, offset.round(), width, width);

    return croppedFile.path;
  }

  takePicture() async {
    try {
      final image = await cameraController!.takePicture();
      final croppedImagePath = await cropPictureToSquare(image.path);
      pictures.add(croppedImagePath);
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }
}
