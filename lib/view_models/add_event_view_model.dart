import 'package:flutter/material.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/utils/result.dart';
import 'package:eventify/models/event_model.dart';
import 'package:provider/provider.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/data/repositories/location_repository.dart';
import 'package:eventify/models/location_model.dart';

class AddViewModel extends ChangeNotifier {
  AddViewModel({
    required BuildContext context,
    required EventRepository eventRepository,
    required LocationRepository locationRepository,
  })  : _eventRepository = eventRepository,
        _locationRepository = locationRepository,
        _context = context;

  final EventRepository _eventRepository;
  final LocationRepository _locationRepository;
  final BuildContext _context;

  // Form data
  String? imageUri;
  String? title;
  String? description;
  DateTime? date;
  DateTime? startsAt;
  DateTime? endsAt;
  int? categoryId;
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
      debugPrint("[AddViewModel] Validation failed");
      return Result.error(Exception('Please fill all required fields'));
    }

    try {
      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        debugPrint("[AddViewModel] No user logged in");
        return Result.error(Exception('User not logged in'));
      }

      print("[AddViewModel] Creating location...");
      final locationResult = await _locationRepository.createLocation(
        latitude: latitude!,
        longitude: longitude!,
      );

      if (locationResult is Error) {
        debugPrint(
            "[AddViewModel] Location creation failed: ${locationResult.toString()}");
        return Result.error(Exception('Failed to create location'));
      }

      final location = (locationResult as Ok<LocationModel>).value;
      print(
          "[AddViewModel] Location created successfully: ${location.locationId}");

      print("[AddViewModel] Creating event...");
      
      final result = await _eventRepository.createEvent(
        userId: userId,
        eventImage: imageUri!,
        categoryId: categoryId!,
        locationId: location.locationId,
        title: title!,
        description: description!,
        date: date!,
        startsAt: startsAt!,
        endsAt: endsAt!,
        eventMusic: musicUri,
      );

      debugPrint("[AddViewModel] Event creation result: $result");
      if (result is Ok) {
        _clearForm();
      }
       
      return result;
    } catch (e) {
      debugPrint("[AddViewModel] Error in createEvent: $e");
      debugPrint("titulo: $title");
      debugPrint("image: $imageUri");
      debugPrint("description: $description");
      debugPrint("category: $categoryId");
      debugPrint("date: $date, $startsAt, $endsAt");
      debugPrint("music $musicUri"); 
      return Result.error(Exception('Failed to create event: $e'));
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
