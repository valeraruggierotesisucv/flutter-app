class UserModel {
  final String userId;
  final String username;
  final String fullname;
  final String email;
  final String? profileImage;
  final DateTime birthDate;
  final String? biography;
  final int followersCounter;
  final int followingCounter;
  final int eventsCounter;

  UserModel(
      {required this.userId,
      required this.username,
      required this.fullname,
      required this.email,
      this.profileImage,
      required this.birthDate,
      this.biography,
      required this.followersCounter,
      required this.followingCounter,

      required this.eventsCounter});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json['userId'],
        username: json['username'],
        fullname: json['fullname'],
        email: json['email'],
        profileImage: json['profileImage'],
        birthDate: json['birthDate'],
        biography: json['biography'],
        followersCounter: json['followersCounter'],
        followingCounter: json['followingCounter'],
        eventsCounter: json['eventsCounter']);
  }
}
