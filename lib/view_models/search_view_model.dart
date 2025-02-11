import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/models/event_model.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel({required BuildContext context, required EventRepository eventRepository, required UserRepository userRepository})
  : _eventRepository = eventRepository,
    _userRepository = userRepository,
    _context = context {
      searchEvents = Command1<void, String>(_searchEvents);
      searchUsers = Command1<void, String>(_searchUsers);
    }
  final BuildContext _context;
  final EventRepository _eventRepository;
  final UserRepository _userRepository;
  final _log = ('SearchViewModel');
  List<EventModel> _events = [];
  List<UserModel> _users = [];
  late final Command1<void, String> searchEvents;
  late final Command1<void, String> searchUsers;
  List<EventModel> get events => _events;
  List<UserModel> get users => _users;


  Future<Result<List<EventModel>>> _searchEvents(String query) async {
    try {
      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      if(query.isEmpty) {
        _events = [];
        notifyListeners();
        return Result.ok(_events);
      }
      final result = await _eventRepository.searchEvents(query, userId);

      switch (result) {
        case Ok<List<EventModel>>():
          _events = result.value;
          notifyListeners();
        case Error<List<EventModel>>():
          print('Error loading events: ${result.error}');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

   Future<Result<List<UserModel>>> _searchUsers(String query) async {
    try {
      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }
      if(query.isEmpty) {
        _users = [];
        notifyListeners();
        return Result.ok(_users);
      }
      final result = await _userRepository.searchUsers(query);
      print(result);

      switch (result) {
        case Ok<List<UserModel>>():
          _users = result.value;
          notifyListeners();
        case Error<List<UserModel>>():
          print('Error loading users: ${result.error}');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}