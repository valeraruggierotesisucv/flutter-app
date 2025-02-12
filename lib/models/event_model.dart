class EventModel {
  String eventId;
  String profileImage;
  String username;
  String eventImage;
  String title;
  String description;
  String locationId;
  String latitude;
  String longitude;
  String startsAt;
  String endsAt;
  String date;
  String category;
  String categoryId;
  String musicUrl;
  bool isLiked;
  String userId;

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
    required this.isLiked,
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
      isLiked: json['is_liked'],
      userId: json['user_id'],
    );
  }

  EventModel copyWith({
    String? eventId,
    String? userId,
    String? username,
    String? profileImage,
    String? eventImage,
    String? title,
    String? description,
    String? date,
    String? startsAt,
    String? endsAt,
    String? categoryId,
    String? category,
    String? musicUrl,
    String? locationId,
    String? latitude,
    String? longitude,
    bool? isLiked,
  }) {
    return EventModel(
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      eventImage: eventImage ?? this.eventImage,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      musicUrl: musicUrl ?? this.musicUrl,
      locationId: locationId ?? this.locationId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isLiked: isLiked ?? this.isLiked,
    );
  }
} 