import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/models/location_model.dart';
import 'package:eventify/utils/result.dart';

class LocationRepository {
  LocationRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<Result<LocationModel>> createLocation({
    required String latitude,
    required String longitude,
  }) async {
    return await _apiClient.createLocation(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
