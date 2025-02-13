class FollowUserModel {
  final String userIdFollows;
  final String userIdFollowedBy;
  final DateTime createdAt;
  bool isActive;
  String? followerName;
  String? followerProfileImage;
  String? followedName;
  String? followedProfileImage;

  FollowUserModel({
    required this.userIdFollows,
    required this.userIdFollowedBy,
    required this.createdAt,
    required this.isActive,
    this.followerName,
    this.followerProfileImage,
    this.followedName,
    this.followedProfileImage,
  });

  factory FollowUserModel.fromJson(Map<String, dynamic> json) {
    return FollowUserModel(
      userIdFollows: json['userIdFollows'],
      userIdFollowedBy: json['userIdFollowedBy'],
      createdAt: json['createdAt'],
      isActive: json['isActive'],
      followerName: json['followerName'],
      followerProfileImage: json['followerProfileImage'],
      followedName: json['followedName'],
      followedProfileImage: json['followedProfileImage'],
    );
  }
}
