import 'package:eventify/models/event_model.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/models/event_summary_model.dart';
import 'package:eventify/models/social_interactions.dart';
import 'package:eventify/utils/result.dart' show Result, Ok;

class EventRepository {

  EventRepository(this._apiClient);
  final ApiClient _apiClient;
  List<EventModel>? _cachedEvents;


  Future<Result<List<EventModel>>> getHomeEvents(String userId) async {
    if (_cachedEvents == null) {
      final result = await _apiClient.getEvents(userId);
      

      if (result is Ok<List<EventModel>>) {
        _cachedEvents = result.value;
      }
      return result;
    }else{
      return Result.ok(_cachedEvents!);
    }
  }

  Future<Result<SocialInteractions>> likeEvent({required String eventId, required String userId}) async {
      final result = await _apiClient.likeEvent(eventId, userId);
      return result;
  }

  Future<Result<List<EventModel>>> searchEvents(String query, String userId) async {
    try {
      final result = await _apiClient.searchEvents(query, userId);
      return result;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> createEvent({
    required String userId,
    required String eventImage,
    required int categoryId,
    required String locationId,
    required String title,
    required String description,
    required DateTime date,
    required DateTime startsAt,
    required DateTime endsAt,
    String? eventMusic,
  }) async {
    return await _apiClient.createEvent(
      userId: userId,
      eventImage: eventImage,
      categoryId: categoryId,
      locationId: locationId,
      title: title,
      description: description,
      date: date,
      startsAt: startsAt,
      endsAt: endsAt,
      eventMusic: eventMusic,
    );
  }

  Future<Result<List<EventSummaryModel>>> getUserEvents(String userId) async {
    try {
      final result = await _apiClient.getUserEvents(userId);
      print(result);
      return result;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<EventModel>> getEventDetails(String eventId, String userId) async {
    final result = await _apiClient.getEventDetails(eventId, userId);
    return result;
  }
} 