class BackendUris {
  static const String BASE = "http://127.0.0.1:8080";

  static final Uri SIGN_IN = Uri.parse(BASE + "/member/signin");
  static final Uri SIGN_UP = Uri.parse(BASE + "/member/signup");
  static final Uri BOOK_SEARCH = Uri.parse(BASE + "/book");
}
