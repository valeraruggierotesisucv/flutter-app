import 'package:eventify/models/event_model.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/utils/result.dart' show Result, Ok, Error;

class EventRepository {

  EventRepository(this._apiClient);
  final ApiClient _apiClient;
  List<EventModel>? _cachedEvents;


  Future<Result<List<EventModel>>> getEvents(String userId) async {
    if (_cachedEvents == null) {
      final result = await _apiClient.getEvents(userId);
      

      if (result is Ok<List<EventModel>>) {
        _cachedEvents = result.value;
      }
      print(result);
      return result;
    }else{
      return Result.ok(_cachedEvents!);
    }
  }
} 