class BackendUris {
  static const String BASE = "http://127.0.0.1:8080";
  // static const String BASE =
  //     "http://openbookbackend-env.eba-edyq3vjz.ap-northeast-2.elasticbeanstalk.com";

  static final Uri SIGN_IN = Uri.parse(BASE + "/member/signin");
  static final Uri SIGN_UP = Uri.parse(BASE + "/member/signup");
  static final Uri BOOK_SEARCH = Uri.parse(BASE + "/book");
  static final Uri READING_BOOK_LIST = Uri.parse(BASE + "/record/books");

  static Uri getReadingRecordsUri(String isbn) {
    return Uri.parse(BASE + '/record/book/$isbn');
  }

  static Uri getNoteUri(String isbn) {
    return Uri.parse(BASE + '/note/?isbn=$isbn');
  }

  static Uri addNoteUri(String isbn, int page) {
    return Uri.parse(BASE + '/note/$isbn/$page');
  }
}
