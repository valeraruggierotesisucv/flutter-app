import 'package:eventify/models/event_model.dart';
import 'package:eventify/utils/command.dart';
import 'package:flutter/material.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/utils/result.dart';
import 'package:provider/provider.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:logging/logging.dart';
import 'package:eventify/data/repositories/location_repository.dart';
import 'package:eventify/models/location_model.dart';
import 'package:eventify/services/storage_service.dart';
import 'dart:io';


class EditViewModel extends ChangeNotifier {
  EditViewModel({
    required BuildContext context,
    required EventRepository eventRepository,
    required LocationRepository locationRepository,
    required this.eventId,
  })  : _eventRepository = eventRepository,
        _locationRepository = locationRepository,
        _context = context {
    getEventDetails = Command1<void, String>(_getEventDetails);
  }

  final EventRepository _eventRepository;
  final LocationRepository _locationRepository;
  final BuildContext _context;
  final String eventId;
  final StorageService _storageService = StorageService();

  late final Command1<void, String> getEventDetails;

  EventModel? _event;
  EventModel? get event => _event;
  final _log = Logger('EditViewModel');

  bool get isValid {
    if (_event == null) return false;
    
    return _event!.eventImage.isNotEmpty &&
        _event!.title.isNotEmpty &&
        _event!.description.isNotEmpty &&
        _event!.date.isNotEmpty &&
        _event!.startsAt.isNotEmpty &&
        _event!.endsAt.isNotEmpty &&
        _event!.categoryId.isNotEmpty &&
        _event!.musicUrl.isNotEmpty &&
        _event!.latitude.isNotEmpty &&
        _event!.longitude.isNotEmpty;
  }

  Future<Result<EventModel>> _getEventDetails(String eventId) async {
    try {
      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }
      final result = await _eventRepository.getEventDetails(eventId, userId);
      switch (result) {
        case Ok<EventModel>():
          _event = result.value;
          _log.fine("Event details fetched successfully");
          return result;
        case Error<EventModel>():
          _log.warning("Error in getEventDetails: ${result.error}");
          return result;
      }
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> updateEvent() async {
    if (!isValid) {
      _log.warning("Validation failed");
      return Result.error(Exception('Please fill all required fields'));
    }

    try {
      String? publicImageUrl;
      String? publicAudioUrl;

      // Upload new image if it's a local file
      if (_event!.eventImage.isNotEmpty && !_event!.eventImage.startsWith('http')) {
        publicImageUrl = await _storageService.uploadFile(_event!.eventImage, FileType.image);
        _log.fine("Image uploaded: $publicImageUrl");
        if (publicImageUrl == null) {
          throw Exception('Failed to upload image');
        }
        _event!.eventImage = publicImageUrl;
      }

      // Upload new audio if it's a local file
      if (_event!.musicUrl.isNotEmpty && !_event!.musicUrl.startsWith('http')) {
        publicAudioUrl = await _storageService.uploadFile(_event!.musicUrl, FileType.audio);
        _log.fine("Audio uploaded: $publicAudioUrl");
        if (publicAudioUrl == null) {
          throw Exception('Failed to upload audio');
        }
        _event!.musicUrl = publicAudioUrl;
      }

      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      // Create location if needed
      final locationResult = await _locationRepository.createLocation(
        latitude: _event!.latitude,
        longitude: _event!.longitude,
      );

      if (locationResult is Error) {
        _log.warning("Location creation failed: ${locationResult.toString()}");
        return Result.error(Exception('Failed to create location'));
      }

      final location = (locationResult as Ok<LocationModel>).value;
      _event!.locationId = location.locationId;
      _log.fine("Location created: ${location.locationId}");

      // Update event with new data
      

      final result = await _eventRepository.updateEvent(
        eventId: eventId,
        event: _event!,
      );

      if (result is Ok) {
        _log.fine("Event updated successfully");
      }

      return result;
    } catch (e) {
      _log.warning("Error updating event: $e");
      return Result.error(Exception('Failed to update event: $e'));
    }
  }
}
