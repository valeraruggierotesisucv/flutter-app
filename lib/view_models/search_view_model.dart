import 'package:eventify/data/repositories/category_repository.dart';
import 'package:eventify/data/repositories/comment_repository.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/models/category_model.dart';
import 'package:eventify/models/comment_model.dart';
import 'package:eventify/models/event_model.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';
import 'package:flutter/material.dart';

import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel({required BuildContext context, required EventRepository eventRepository, required UserRepository userRepository, required CommentRepository commentRepository, required CategoryRepository categoryRepository})
  : _eventRepository = eventRepository,
    _userRepository = userRepository,
    _categoryRepository = categoryRepository,
    _commentRepository = commentRepository,
    _context = context {
      searchEvents = Command1<void, String>(_searchEvents);
      getCategories = Command0<void>(_getCategories);
      searchUsers = Command1<void, String>(_searchUsers);
      loadComments = Command1<void, String>(_loadComments);
      submitComment = Command2<void, String, String>(_submitComment);
      handleLike = Command1<void, String>(_handleLike);
    }

  final BuildContext _context;
  final EventRepository _eventRepository;
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;

  final _log = Logger('SearchViewModel');
  List<EventModel> _events = [];
  List<UserModel> _users = [];
  List<CategoryModel> _categories = [];
  final CommentRepository _commentRepository;
  late final Command1<void, String> searchEvents;
  late final Command1<void, String> searchUsers;
  late final Command1<void, String> loadComments;
  late final Command2<void, String, String> submitComment;
  late final Command1<void, String> handleLike;
  List<CommentModel> _comments = [];
  String _commentsEventId = "";

  late final Command0<void> getCategories;

  List<EventModel> get events => _events;
  List<UserModel> get users => _users;
  List<CommentModel> get comments => _comments;
  ValueNotifier<List<CommentModel>> get commentsListenable => _commentsListenable;

  List<CategoryModel> get categories => _categories;

  List<int> _selectedCategories = [];
  List<int> get selectedCategories => _selectedCategories;

  List<EventModel> _unfilteredEvents = [];

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


  final _commentsListenable = ValueNotifier<List<CommentModel>>([]);

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

   Future<Result<void>> _handleLike(String eventId) async {
    try {
      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result = await _eventRepository.likeEvent(
        eventId: eventId, 
        userId: userId
      );

      final event = _events.firstWhere((e) => e.eventId == eventId);
      
      switch (result) {
        case Ok():
          event.isLiked = !event.isLiked;
          notifyListeners();
          return const Result.ok(null);
        case Error():
          _log.warning('Failed to like event', result.error);
          return Result.error(result.error);
      }
    } catch (e) {
      _log.severe('Error in handleLike', e);
      return Result.error(Exception('Failed to like event'));
    } finally {
      notifyListeners();
    }
  }

  Future<Result<List<CommentModel>>> _loadComments(String eventId) async {
    try {
      _commentsListenable.value = [];
      
      final result = await _commentRepository.getComments(eventId);
      switch (result) {
        case Ok<List<CommentModel>>():
          _commentsListenable.value = result.value;
          _commentsEventId = eventId;
          return Result.ok(_commentsListenable.value);
        case Error<List<CommentModel>>():
          _log.warning('Failed to load comments', result.error);
          return Result.error(result.error);
      } 
    } catch (e) {
      _log.severe('Error in loadComments', e);
      return Result.error(Exception('Failed to load comments'));
    }
  }

  Future<Result<void>> _submitComment(String eventId, String comment) async {
    try {

      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      
      final user = await _userRepository.getUser(userId);
      
      if( user is !Ok<UserModel>) {
        
        return Result.error(Exception('Failed to get user'));
      }
      
      final newComment = CommentModel(username: user.value.username, timestamp: DateTime.now(), comment: comment, profileImage: user.value.profileImage ?? "");
      final result = await _commentRepository.submitComment(eventId, userId, newComment);
      switch (result) {
        case Ok():
          if(_commentsEventId == eventId) {
            _commentsListenable.value = _commentsListenable.value.toList()..add(newComment);
          }
          return Result.ok(null);
          
        case Error():
          _log.warning('Failed to submit comment', result.error);
          return Result.error(result.error);
      }
    } catch (e) {
      _log.severe('Error in submitComment', e);
      return Result.error(Exception('Failed to submit comment'));
    }
  }

}