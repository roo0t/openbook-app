import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';

class AddNoteController extends GetxController {
  final RxBool cameraIsInitialized = false.obs;
  final RxBool shouldShowCameraPreview = false.obs;
  RxList<String> pictures = <String>[].obs;
  late final CameraDescription _camera;
  late final CameraController? cameraController;
  final TextEditingController textEditingController = TextEditingController();

  @override
  onInit() async {
    super.onInit();
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );
      cameraController = CameraController(
        _camera,
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );
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

  initializeCamera() async {
    if (cameraController != null) {
      await cameraController!.initialize();
      cameraIsInitialized(true);
    }
  }

  takePicture() async {
    if (cameraIsInitialized.isTrue) {
      try {
        final image = await cameraController!.takePicture();
        final croppedImagePath = await cropPictureToSquare(image.path);
        pictures.add(croppedImagePath);
        hideCameraPreview();
      } catch (e) {
        // If an error occurs, log the error to the console.
        print(e);
      }
    }
  }

  showCameraPreview() async {
    if (cameraIsInitialized.isFalse) {
      await initializeCamera();
    }
    cameraController?.resumePreview();
    shouldShowCameraPreview(true);
  }

  hideCameraPreview() {
    cameraController?.pausePreview();
    shouldShowCameraPreview(false);
  }
}
