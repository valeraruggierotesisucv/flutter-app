import 'dart:async';

import 'package:eventify/providers/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/models/event_model.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required BuildContext context,
    required EventRepository eventRepository,
  }) : _eventRepository = eventRepository,
       _context = context {
    load = Command0(() async {
      try {
        print('Loading events...');
        final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
        if (userId == null) {
          print('No user ID found');
          return Result.error(Exception('User not logged in'));
        }
        print('User ID: $userId');

        final result = await _eventRepository.getEvents(userId);
        switch (result) {
          case Ok<List<EventModel>>():
            _events = result.value;
            print('Events loaded: ${_events.length}');
            notifyListeners();
          case Error<List<EventModel>>():
            print('Error loading events: ${result.error}');
        }
        return result;
      } finally {
        notifyListeners();
      }
    })..execute();
  }

  final EventRepository _eventRepository;
  final BuildContext _context;
  final _log = Logger('HomeViewModel');
  List<EventModel> _events = [];

  late Command0<dynamic> load;

  List<EventModel> get events => _events;
} 