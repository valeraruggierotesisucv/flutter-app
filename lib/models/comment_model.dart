class CommentModel {
  String username;
  String comment;
  String profileImage;
  DateTime timestamp;

  CommentModel({
    required this.username,
    required this.comment,
    required this.profileImage,
    required this.timestamp,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      username: json['username'],
      comment: json['comment'],
      profileImage: json['profileImage'],
      timestamp: json['timestamp'],
    );
  }
}