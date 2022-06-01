import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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

  takePicture() async {
    try {
      final image = await cameraController!.takePicture();
      pictures.add(image.path);
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }
}
