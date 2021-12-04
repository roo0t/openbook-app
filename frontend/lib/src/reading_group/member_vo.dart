class MemberVo {
  final String name;
  final String profilePictureUrl;

  MemberVo({
    required this.name,
    required this.profilePictureUrl,
  });

  MemberVo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        profilePictureUrl = json['profilePictureUrl'];
}
