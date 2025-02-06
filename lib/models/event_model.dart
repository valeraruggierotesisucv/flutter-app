class EventModel {
  final String eventId;
  final String profileImage;
  final String username;
  final String eventImage;
  final String title;
  final String description;
  final String locationId;
  final String latitude;
  final String longitude;
  final String startsAt;
  final String endsAt;
  final String date;
  final String category;
  final String categoryId;
  final String musicUrl;
  final bool isLiked;
  final String userId;

  EventModel({
    required this.eventId,
    required this.profileImage,
    required this.username,
    required this.eventImage,
    required this.title,
    required this.description,
    required this.locationId,
    required this.latitude,
    required this.longitude,
    required this.startsAt,
    required this.endsAt,
    required this.date,
    required this.category,
    required this.categoryId,
    required this.musicUrl,
    required this.userId,
    this.isLiked = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['event_id'],
      profileImage: json['profile_image'],
      username: json['username'],
      eventImage: json['event_image'],
      title: json['title'],
      description: json['description'],
      locationId: json['location_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      startsAt: json['starts_at'],
      endsAt: json['ends_at'],
      date: json['date'],
      category: json['category'],
      categoryId: json['category_id'],
      musicUrl: json['music_url'],
      isLiked: json['is_liked'] ?? false,
      userId: json['user_id'],
    );
  }
} 