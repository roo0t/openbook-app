import 'member_vo.dart';

class ReadingGroupVo {
  final int id;
  final String name;
  final String occurringAt;
  final String imageUrl;
  final List<MemberVo> members;

  ReadingGroupVo({
    required this.id,
    required this.name,
    required this.occurringAt,
    required this.imageUrl,
    required this.members,
  });

  ReadingGroupVo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        occurringAt = json['occurringAt'],
        imageUrl = json['imageUrl'],
        members = (json['members'] as List)
            .map(
              (o) => MemberVo.fromJson(o),
            )
            .toList();
}
