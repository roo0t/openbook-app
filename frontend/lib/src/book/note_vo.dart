class NoteVo {
  final String authorEmailAddress;
  final String authorNickname;
  final List<String> imageUris;
  final String content;
  final int page;

  NoteVo({
    required this.authorEmailAddress,
    required this.authorNickname,
    required this.imageUris,
    required this.content,
    required this.page,
  });

  NoteVo.fromJson(Map<String, dynamic> json)
      : authorEmailAddress = json['authorEmailAddress'],
        authorNickname = json['authorNickname'],
        imageUris = List<String>.from(json['imageUris']),
        content = json['content'],
        page = json['page'];
}
