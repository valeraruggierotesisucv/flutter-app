import 'package:eventify/data/repositories/category_repository.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/models/category_model.dart';
import 'package:eventify/models/event_model.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';
import 'package:flutter/material.dart';

import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel({required BuildContext context, required EventRepository eventRepository, required UserRepository userRepository, required CategoryRepository categoryRepository})
  : _eventRepository = eventRepository,
    _userRepository = userRepository,
    _categoryRepository = categoryRepository,
    _context = context {
      searchEvents = Command1<void, String>(_searchEvents);
      getCategories = Command0<void>(_getCategories);
      searchUsers = Command1<void, String>(_searchUsers);
    }

  final BuildContext _context;
  final EventRepository _eventRepository;
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;

  final _log = Logger('SearchViewModel');
  List<EventModel> _events = [];
  List<UserModel> _users = [];
  List<CategoryModel> _categories = [];

  late final Command1<void, String> searchEvents;
  late final Command1<void, String> searchUsers;
  late final Command0<void> getCategories;

  List<EventModel> get events => _events;
  List<UserModel> get users => _users;
  List<CategoryModel> get categories => _categories;

  List<int> _selectedCategories = [];
  List<int> get selectedCategories => _selectedCategories;

  List<EventModel> _unfilteredEvents = []; // Store original search results

  void selectCategory(List<int> categoryIds) {
    _selectedCategories = categoryIds;
    
    // Filter existing events without making new API call
    if (_selectedCategories.isEmpty) {
      _events = List.from(_unfilteredEvents); // Create new list to trigger update
    } else {
      _events = _unfilteredEvents.where((event) {
        try {
          final eventCategoryId = int.parse(event.categoryId);
          return _selectedCategories.contains(eventCategoryId);
        } catch (e) {
          debugPrint("Error parsing category ID: ${event.categoryId}");
          return false;
        }
      }).toList();
    }
    
    notifyListeners();
  }

  String _lastQuery = '';

  Future<Result<List<EventModel>>> _searchEvents(String query) async {
    try {
      _lastQuery = query;
      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      if(query.isEmpty && _selectedCategories.isEmpty) {
        _events = [];
        _unfilteredEvents = [];
        notifyListeners();
        return Result.ok(_events);
      }

      final result = await _eventRepository.searchEvents(query, userId);

      switch (result) {
        case Ok<List<EventModel>>():
          _unfilteredEvents = result.value;
          _events = _unfilteredEvents;
          
          if (_selectedCategories.isNotEmpty) {
            _events = _events.where((event) {
              debugPrint("Filtering event ${event.title} with category ${event.categoryId}");
              
              return _selectedCategories.contains(int.parse(event.categoryId));
            }).toList();
          }
          notifyListeners();
        case Error<List<EventModel>>():
          _log.warning('Error loading events: ${result.error}');
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
      

      switch (result) {
        case Ok<List<UserModel>>():
          _users = result.value;
          notifyListeners();
        case Error<List<UserModel>>():
          _log.warning('Error loading users: ${result.error}');
      }
      return result;

    } finally {
      notifyListeners();
    }
  }

  Future<Result<List<CategoryModel>>> _getCategories() async {
    try {
      final result = await _categoryRepository.getCategories();
      switch (result) {
        case Ok<List<CategoryModel>>():
          _categories = result.value;

          notifyListeners();
          return Result.ok(_categories);
        case Error<List<CategoryModel>>():
          _log.warning('Error loading categories: ${result.error}');
          return Result.error(Exception('Failed to load categories'));
      }
    } catch (e) {
      _log.severe('Error loading categories: $e');
      return Result.error(Exception('Failed to load categories'));
    }
  }
}