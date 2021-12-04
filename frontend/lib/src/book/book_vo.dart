import 'note_vo.dart';

class AuthoringVo {
  final String name;
  final String? role;

  AuthoringVo({
    required this.name,
    required this.role,
  });

  AuthoringVo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        role = json['role'];
}

class BookVo {
  final String isbn;
  final String title;
  final List<AuthoringVo> authors;
  final String publisher;
  final String publishedOn;
  final int totalPages;
  final String coverImageUrl;
  final List<String> tags;
  final String description;
  final List<NoteVo> notes;

  BookVo({
    required this.isbn,
    required this.title,
    required this.authors,
    required this.publisher,
    required this.publishedOn,
    required this.totalPages,
    required this.coverImageUrl,
    required this.tags,
    required this.description,
    required this.notes,
  });

  BookVo.fromJson(Map<String, dynamic> json)
      : isbn = json['isbn'],
        title = json['title'],
        authors = (json['authors'] as List)
            .map((json) => AuthoringVo.fromJson(json))
            .toList(),
        publisher = json['publisher'],
        publishedOn = json['publishedOn'],
        totalPages = json['totalPages'],
        coverImageUrl = json['coverImageUrl'],
        tags = json['tags'].split(';'),
        description = json['description'],
        notes = json['notes'] != null
            ? (json['notes'] as List)
                .map((json) => NoteVo.fromJson(json))
                .toList()
            : [];
}
