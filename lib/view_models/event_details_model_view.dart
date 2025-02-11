import 'package:eventify/data/repositories/comment_repository.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/models/comment_model.dart';
import 'package:eventify/models/event_model.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class EventDetailsViewModel extends ChangeNotifier{

  EventDetailsViewModel({required BuildContext context, required EventRepository eventRepository, required CommentRepository commentRepository, required UserRepository userRepository})
  : _context = context,
    _eventRepository = eventRepository,
    _commentRepository = commentRepository,
    _userRepository = userRepository
    {
      getEventDetails = Command1<void, String>(_getEventDetails);
      loadComments = Command1<void, String>(_loadComments);
      submitComment = Command2<void, String, String>(_submitComment);
      handleLike = Command1<void, String>(_handleLike);
    }

  final BuildContext _context;
  final EventRepository _eventRepository;
  final CommentRepository _commentRepository;
  final UserRepository _userRepository;

  final _log = Logger('EventDetailsViewModel');
  late final Command1<void, String> getEventDetails;
  late final Command1<void, String> loadComments;
  late final Command2<void, String, String> submitComment;
  late final Command1<void, String> handleLike;

  final _commentsListenable = ValueNotifier<List<CommentModel>>([]);
  EventModel? _event;
  String _commentsEventId = "";
  

  EventModel? get event => _event;
  ValueNotifier<List<CommentModel>> get commentsListenable => _commentsListenable;

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

      
      
      switch (result) {
        case Ok():
          _event?.isLiked = !_event!.isLiked;
          
          notifyListeners();
          return const Result.ok(null);
        case Error():
          _log.warning('Failed to like event', result.error);
          return Result.error(result.error);
      }
    } catch (e) {
      _log.severe('Error in handleLike', e);
      return Result.error(Exception('Failed to like event'));
    }
  }

}