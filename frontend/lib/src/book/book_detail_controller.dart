import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../backend_uris.dart';
import '../user/sign_in_page.dart';
import '../user/user_controller.dart';
import 'book_vo.dart';
import 'note_vo.dart';

class BookDetailController extends GetxController {
  final BookVo book;
  final RxList<NoteVo> notes = <NoteVo>[].obs;

  BookDetailController(this.book);

  @override
  onInit() async {
    super.onInit();

    notes(await _loadNotes());
  }

  Future<List<NoteVo>> _loadNotes() async {
    http.Response? response;
    try {
      response = await http.get(
        BackendUris.getNoteUri(book.isbn),
        headers: {
          'Content-Type': 'application/hal+json',
          'X-AUTH-TOKEN': Get.find<UserController>().token!
        },
      );
    } catch (e) {
      return List.empty();
    }
    if (response.statusCode == HttpStatus.ok) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['_embedded'] != null &&
          responseJson['_embedded']['noteModelList'] != null) {
        return responseJson['_embedded']['noteModelList']
            .map<NoteVo>((noteJson) {
          return NoteVo.fromJson(noteJson);
        }).toList();
      } else {
        return List.empty();
      }
    } else if (response.statusCode == HttpStatus.forbidden) {
      Get.find<UserController>().signOut();
      Get.offAll(() => const SignInPage());
    }
    return List.empty();
  }
}
