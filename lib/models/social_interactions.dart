class SocialInteractions {
  final String userId;
  final String eventId;
  final bool isActive;
  final DateTime createdAt;

  SocialInteractions(
      {required this.userId,
      required this.eventId,
      required this.isActive,
      required this.createdAt});

  factory SocialInteractions.fromJson(Map<String, dynamic> json) {
    return SocialInteractions(
        userId: json['userId'],
        eventId: json['eventId'],
        isActive: json['isActive'],
        createdAt: json['createdAt']);
  }
}
