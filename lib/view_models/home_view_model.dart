import 'dart:async';

import 'package:eventify/data/repositories/comment_repository.dart';
import 'package:eventify/models/comment_model.dart';
import 'package:eventify/providers/auth_provider.dart';
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
    required CommentRepository commentRepository,
  }) : _eventRepository = eventRepository,
       _commentRepository = commentRepository,
       _context = context {
    load = Command0(_loadEvents)..execute();
    handleLike = Command1<void, String>(_handleLike);
    loadComments = Command1<void, String>(_loadComments);
  }

  final EventRepository _eventRepository;
  final BuildContext _context;
  final _log = Logger('HomeViewModel');
  List<EventModel> _events = [];
  late final Command0<dynamic> load;
  late final Command1<void, String> handleLike;
  late final Command1<void, String> loadComments;
  List<EventModel> get events => _events;
  final CommentRepository _commentRepository;
  List<CommentModel> _comments = [];
  List<CommentModel> get comments => _comments;



  Future<Result<List<EventModel>>> _loadEvents() async {
    try {
        
        final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
        if (userId == null) {
          return Result.error(Exception('User not logged in'));
        }

        final result = await _eventRepository.getHomeEvents(userId);
        switch (result) {
          case Ok<List<EventModel>>():
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
    }
  }

  Future<Result<List<CommentModel>>> _loadComments(String eventId) async {
    try {
      final result = await _commentRepository.getComments(eventId);
      print("result $result");
      switch (result) {
        case Ok<List<CommentModel>>():
          _comments = result.value;
          notifyListeners();
          return Result.ok(_comments);
        case Error<List<CommentModel>>():
          _log.warning('Failed to load comments', result.error);
          return Result.error(result.error);
      } 
    } catch (e) {
      _log.severe('Error in loadComments', e);
      return Result.error(Exception('Failed to load comments'));
    }
  }
} 