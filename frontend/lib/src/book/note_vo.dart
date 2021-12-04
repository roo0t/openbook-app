class NoteVo {
  final String author;
  final List<String> pictureUrls;
  final String text;

  NoteVo({
    required this.author,
    required this.pictureUrls,
    required this.text,
  });

  NoteVo.fromJson(Map<String, dynamic> json)
      : author = json['author'],
        pictureUrls = List<String>.from(json['pictureUrls']),
        text = json['text'];
}
