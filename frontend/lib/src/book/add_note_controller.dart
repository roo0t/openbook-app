import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';

import '../backend_uris.dart';
import '../user/sign_in_page.dart';
import '../user/user_controller.dart';
import 'book_vo.dart';
import 'note_vo.dart';

class AddNoteController extends GetxController {
  final BookVo _book;

  final RxBool cameraIsInitialized = false.obs;
  final RxBool shouldShowCameraPreview = false.obs;
  RxList<String> pictures = <String>[].obs;
  late final CameraDescription _camera;
  late final CameraController? cameraController;
  final TextEditingController textEditingController = TextEditingController();

  AddNoteController(this._book);

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
    } else {
      cameraController = null;
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

  submit() async {
    int page = 42;
    try {
      final request = http.MultipartRequest(
        'POST',
        BackendUris.addNoteUri(_book.isbn, page),
      );
      request.fields['content'] = textEditingController.text;
      final multipartFiles = await Future.wait(pictures.map(
        (path) => http.MultipartFile.fromPath('images', path),
      ));
      request.files.addAll(multipartFiles);
      request.headers['Accept'] = 'application/json';
      request.headers['X-AUTH-TOKEN'] = Get.find<UserController>().token!;
      final response = await request.send();

      if (response.statusCode == HttpStatus.created) {
        final responseBody = await response.stream.bytesToString();
        final responseJson = json.decode(responseBody) as Map<String, dynamic>;
        return NoteVo.fromJson(responseJson);
      } else if (response.statusCode == HttpStatus.forbidden) {
        Get.find<UserController>().signOut();
        Get.offAll(() => const SignInPage());
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
