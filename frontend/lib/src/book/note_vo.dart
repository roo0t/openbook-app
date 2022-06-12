class NoteVo {
  final int id;
  final String authorEmailAddress;
  final String authorNickname;
  final DateTime createdAt;
  final List<String> imageUris;
  final String content;
  final int page;

  NoteVo({
    required this.id,
    required this.authorEmailAddress,
    required this.authorNickname,
    required this.createdAt,
    required this.imageUris,
    required this.content,
    required this.page,
  });

  NoteVo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        authorEmailAddress = json['authorEmailAddress'],
        authorNickname = json['authorNickname'],
        createdAt = DateTime.parse(json['createdAt']),
        imageUris = List<String>.from(json['imageUris']),
        content = json['content'],
        page = json['page'];
}
