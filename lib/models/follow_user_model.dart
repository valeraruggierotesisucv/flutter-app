class FollowUserModel {
  final String userIdFollows;
  final String userIdFollowedBy;
  final DateTime createdAt;
  bool isActive;

  FollowUserModel({
    required this.userIdFollows,
    required this.userIdFollowedBy,
    required this.createdAt,
    required this.isActive,
  });

  factory FollowUserModel.fromJson(Map<String, dynamic> json) {
    return FollowUserModel(
      userIdFollows: json['userIdFollows'],
      userIdFollowedBy: json['userIdFollowedBy'],
      createdAt: json['createdAt'],
      isActive: json['isActive'],
    );
  }
}
