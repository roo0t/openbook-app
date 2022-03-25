class ReadingRecordVo {
  final int id;
  final int startPage;
  final int endPage;
  final DateTime recordedAt;

  ReadingRecordVo({
    required this.id,
    required this.startPage,
    required this.endPage,
    required this.recordedAt,
  });

  ReadingRecordVo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        startPage = json['startPage'],
        endPage = json['endPage'],
        recordedAt = DateTime.parse(json['recordedAt']);
}
