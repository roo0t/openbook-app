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
        startPage = json['start_page'],
        endPage = json['end_page'],
        recordedAt = DateTime.parse(json['recorded_at']);
}
