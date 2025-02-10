import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/models/event_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class EventDetailsViewModel extends ChangeNotifier{

  EventDetailsViewModel({required BuildContext context, required EventRepository eventRepository})
  : _context = context,
    _eventRepository = eventRepository {
      getEventDetails = Command1<void, String>(_getEventDetails);
    }

  final BuildContext _context;
  final EventRepository _eventRepository;
  final _log = Logger('EventDetailsViewModel');
  late final Command1<void, String> getEventDetails;

  
  EventModel? _event;
  EventModel? get event => _event;

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
          _log.fine('Event details loaded: ${_event?.title}');
        case Error<EventModel>():
          _log.warning('Error loading event details: ${result.error}');
          return result;

      }
      return result;

    } finally {
      notifyListeners();
    }

  }
}