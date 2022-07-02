import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../backend_uris.dart';
import '../user/sign_in_page.dart';
import '../user/user_controller.dart';
import 'book_vo.dart';
import 'note_vo.dart';

class BookDetailController extends GetxController {
  final RxMap<String, RxList<NoteVo>> notes = RxMap<String, RxList<NoteVo>>();
  final RxMap<String, RxMap<int, GlobalKey>> noteKeys =
      RxMap<String, RxMap<int, GlobalKey>>();
  final ScrollController scrollController = ScrollController();
  final RxnString currentBookIsbn = RxnString();
  final RxInt currentPage = 0.obs;

  BookDetailController();

  void loadNotes(BookVo book) async {
    currentBookIsbn(book.isbn);
    currentPage(0);
    List<NoteVo> loadedNotes = await _loadNotes(book);
    loadedNotes.sort(compareNotesByPageAndCreatedDate);
    notes[book.isbn] = loadedNotes.obs;
    noteKeys[book.isbn] = generateNoteKeys(loadedNotes).obs;
  }

  Map<int, GlobalKey> generateNoteKeys(List<NoteVo> notes) {
    Map<int, GlobalKey> noteKeys = {};
    notes.map((note) => note.page).toSet().forEach((page) {
      noteKeys[page] = GlobalKey(debugLabel: page.toString());
    });
    return noteKeys;
  }

  Future<List<NoteVo>> _loadNotes(BookVo book) async {
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
        return responseJson['_embedded']['noteModelList'].map<NoteVo>(
          (noteJson) {
            return NoteVo.fromJson(noteJson);
          },
        ).toList();
      } else {
        return List.empty();
      }
    } else if (response.statusCode == HttpStatus.forbidden) {
      Get.find<UserController>().signOut();
      Get.offAll(() => const SignInPage());
    }
    return List.empty();
  }

  void addNote(BookVo book, NoteVo note) {
    if (!notes.containsKey(book.isbn)) {
      notes.assign(book.isbn, <NoteVo>[].obs);
    }
    notes[book.isbn]!
      ..add(note)
      ..sort(compareNotesByPageAndCreatedDate);
  }

  int compareNotesByPageAndCreatedDate(NoteVo a, NoteVo b) {
    var pageCompareResult = a.page.compareTo(b.page);
    if (pageCompareResult != 0) {
      return pageCompareResult;
    }
    return -a.createdAt.compareTo(b.createdAt);
  }

  List<NoteVo> getNotesOfCurrentPage() {
    if (currentBookIsbn.value == null) {
      return [];
    }
    return notes[currentBookIsbn.value!]
            ?.where((NoteVo note) => note.page == currentPage.value)
            .toList() ??
        [];
  }

  void turnPage(int page) {
    currentPage(page);
  }
}
