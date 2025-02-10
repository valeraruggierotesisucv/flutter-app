class EventSummaryModel {
  final String eventId;
  final String imageUrl;

  EventSummaryModel({
    required this.eventId,
    required this.imageUrl,
  });
  
  factory EventSummaryModel.fromJson(Map<String, dynamic> json) {
    return EventSummaryModel(
      eventId: json['eventId'],
      imageUrl: json['imageUrl'],
    );
  }
}
