class LocationModel {
  final String locationId;
  final String latitude;
  final String longitude;

  LocationModel({
    required this.locationId,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      locationId: json['locationId'],
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
    );
  }
}