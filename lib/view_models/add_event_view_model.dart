import 'package:flutter/material.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/utils/result.dart';
import 'package:provider/provider.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/data/repositories/location_repository.dart';
import 'package:eventify/models/location_model.dart';
import 'package:eventify/services/storage_service.dart';

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

  final StorageService _storageService = StorageService();

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
        description != null &&
        date != null &&
        startsAt != null &&
        endsAt != null &&
        categoryId != null &&
        musicUri != null &&
        latitude != null &&
        longitude != null;
  }

  Future<Result<void>> createEvent() async {
    if (!isValid) {
      debugPrint("[AddViewModel] Validation failed");
      return Result.error(Exception('Please fill all required fields'));
    }

    try {
      String? publicImageUrl;

      // Si hay una imagen seleccionada, súbela primero
      if (imageUri != null) {
        publicImageUrl = await _storageService.uploadEventImage(imageUri!);
        debugPrint("imageUrl-->$publicImageUrl"); 
        if (publicImageUrl == null) {
          throw Exception('Failed to upload image');
        }
      }

      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        debugPrint("[AddViewModel] No user logged in");
        return Result.error(Exception('User not logged in'));
      }

      debugPrint("[AddViewModel] Creating location...");
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
      debugPrint(
          "[AddViewModel] Location created successfully: ${location.locationId}");
      debugPrint("[AddViewModel] Creating event...");

      final result = await _eventRepository.createEvent(
        userId: userId,
        eventImage: publicImageUrl ?? imageUri!,
        categoryId: categoryId!,
        locationId: location.locationId,
        title: title!,
        description: description!,
        date: date!,
        startsAt: startsAt!,
        endsAt: endsAt!,
        eventMusic: musicUri,
      );

      debugPrint("[AddViewModel] Event created succesfully");
      if (result is Ok) {
        _clearForm();
      }

      return result;
    } catch (e) {
      debugPrint("[AddViewModel] Error in createEvent: $e");
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
