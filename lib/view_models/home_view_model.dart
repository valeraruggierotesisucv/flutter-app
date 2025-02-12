import 'dart:async';

import 'package:eventify/data/repositories/comment_repository.dart';
import 'package:eventify/data/repositories/notification_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/models/comment_model.dart';
import 'package:eventify/models/notification_model.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/models/event_model.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
      {required BuildContext context,
      required EventRepository eventRepository,
      required CommentRepository commentRepository,
      required UserRepository userRepository,
      required NotificationRepository notificationRepository})
      : _eventRepository = eventRepository,
        _commentRepository = commentRepository,
        _userRepository = userRepository,
        _notificationRepository = notificationRepository, 
        _context = context {
    load = Command0(_loadEvents)..execute();
    handleLike = Command1<void, String>(_handleLike);
    loadComments = Command1<void, String>(_loadComments);
    submitComment = Command2<void, String, String>(_submitComment);
  }

  final BuildContext _context;
  final EventRepository _eventRepository;
  final CommentRepository _commentRepository;
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository; 
  final _log = Logger('HomeViewModel');
  List<EventModel> _events = [];
  String _commentsEventId = "";
  List<CommentModel> _comments = [];
  List<EventModel> get events => _events;
  List<CommentModel> get comments => _comments;
  late final Command0<dynamic> load;
  late final Command1<void, String> handleLike;
  late final Command1<void, String> loadComments;
  late final Command2<void, String, String> submitComment;

  final _commentsListenable = ValueNotifier<List<CommentModel>>([]);
  ValueNotifier<List<CommentModel>> get commentsListenable =>
      _commentsListenable;

  Future<Result<List<EventModel>>> _loadEvents() async {
    try {
      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result = await _eventRepository.getHomeEvents(userId);
      switch (result) {
        case Ok<List<EventModel>>():
          print(result.value[0].isLiked);
          _events = result.value;
          notifyListeners();
        case Error<List<EventModel>>():
          _log.severe('Error loading events: ${result.error}');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _handleLike(String eventId) async {
    try {
      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result =
          await _eventRepository.likeEvent(eventId: eventId, userId: userId);

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
      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      final user = await _userRepository.getUser(userId);

      if (user is! Ok<UserModel>) {
        return Result.error(Exception('Failed to get user'));
      }

      final newComment = CommentModel(
          username: user.value.username,
          timestamp: DateTime.now(),
          comment: comment,
          profileImage: user.value.profileImage ?? "");
      final result =
          await _commentRepository.submitComment(eventId, userId, newComment);
      switch (result) {
        case Ok():
          if (_commentsEventId == eventId) {
            _commentsListenable.value = _commentsListenable.value.toList()
              ..add(newComment);
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

   Future<void> sendNotification(
      String toNotificationToken, String title, String body) async {
    final result = await _notificationRepository.sendNotification(
        toNotificationToken, title, body);

    debugPrint("[home_view_model] sendNotification: $result");
  }

  Future<String?> fetchNotificationToken(String userId) async {
    final result = await _notificationRepository.getNotificationToken(userId);
    debugPrint("[notifications_view_model] fetchNotificationToken: $result");
    return result;
  }

  Future<Result<void>> createNotification(NotificationModel notificationData) async {
    final result =
        await _notificationRepository.createNotification(notificationData);
    return result; 
  }
}
