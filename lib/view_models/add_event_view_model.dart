import 'package:flutter/material.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/utils/result.dart';
import 'package:eventify/models/event_model.dart';
import 'package:provider/provider.dart';
import 'package:eventify/providers/auth_provider.dart';

class AddViewModel extends ChangeNotifier {
  AddViewModel({
    required BuildContext context,
    required EventRepository eventRepository,
  })  : _eventRepository = eventRepository,
        _context = context;

  final EventRepository _eventRepository;
  final BuildContext _context;

  // Form data
  String? imageUri;
  String? title;
  String? description;
  DateTime? date;
  DateTime? startsAt;
  DateTime? endsAt;
  String? categoryId;
  String? latitude;
  String? longitude;
  String? musicUri;

  bool get isValid {
    return imageUri != null &&
        title != null &&
        title!.isNotEmpty &&
        description != null &&
        description!.isNotEmpty &&
        date != null &&
        startsAt != null &&
        endsAt != null &&
        categoryId != null;
  }

  Future<Result<EventModel>> createEvent() async {
    if (!isValid) {
      return Result.error(Exception('Please fill all required fields'));
    }

    try {
      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      debugPrint("[add_event_view_model] user--> $userId");

      const String tempLocationId = "1"; // Temporary for testing

      final result = await _eventRepository.createEvent(
        userId: userId,
        eventImage: imageUri!,
        categoryId: categoryId!,
        locationId: tempLocationId,
        title: title!,
        description: description!,
        date: date!,
        startsAt: startsAt!,
        endsAt: endsAt!,
        eventMusic: musicUri,
      );
      debugPrint(result.toString()); 
      if (result is Ok) {
        debugPrint("ok $result");
        _clearForm();
      }

      return result;
    } catch (e) {
      return Result.error(Exception('Failed to create event'));
    }
  }

  void _clearForm() {
    imageUri = null;
    title = null;
    description = null;
    date = null;
    startsAt = null;
    endsAt = null;
    categoryId = null;
    latitude = null;
    longitude = null;
    musicUri = null;
    notifyListeners();
  }
}
