import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/follow_user_repository.dart';
import 'package:eventify/data/repositories/notification_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/models/event_summary_model.dart';
import 'package:eventify/models/follow_user_model.dart';
import 'package:eventify/models/notification_model.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class ProfileDetailsViewModel extends ChangeNotifier {
  ProfileDetailsViewModel(
      {required BuildContext context,
      required UserRepository userRepository,
      required EventRepository eventRepository,
      required FollowUserRepository followUserRepository,
      required NotificationRepository notificationRepository})
      : _userRepository = userRepository,
        _eventRepository = eventRepository,
        _followUserRepository = followUserRepository,
        _notificationRepository = notificationRepository, 
        _context = context {
    initLoad = Command1<void, String>(_initLoad);
    followUser = Command1<void, String>(_followUser);
    unfollowUser = Command1<void, String>(_unfollowUser);
  }

  final BuildContext _context;
  final UserRepository _userRepository;
  final EventRepository _eventRepository;
  final FollowUserRepository _followUserRepository;
  final NotificationRepository _notificationRepository; 

  List<EventSummaryModel> _events = [];
  List<EventSummaryModel> get events => _events;
  FollowUserModel? _followUserModel;

  late final Command1<void, String> initLoad;
  late final Command1<void, String> followUser;
  late final Command1<void, String> unfollowUser;

  FollowUserModel? get followUserModel => _followUserModel;
  UserModel? _user;
  UserModel? get user => _user;

  final _log = Logger('ProfileDetailsViewModel');

  Future<Result<UserModel>> _initLoad(String targetUserId) async {
    try {
      final result = await _userRepository.getUser(targetUserId);
      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }
      switch (result) {
        case Ok<UserModel>():
          _user = result.value;
          _log.fine('User loaded: ${_user!.fullname}');

          final eventsResult =
              await _eventRepository.getUserEvents(targetUserId);
          switch (eventsResult) {
            case Ok<List<EventSummaryModel>>():
              _events = eventsResult.value;
              _user!.eventsCounter = _events.length;
              _log.fine('User events loaded: ${_events.length}');
            case Error<List<EventSummaryModel>>():
              _log.warning('Failed to load user events', eventsResult.error);
          }

          final followUserResult =
              await _followUserRepository.isFollowing(userId, targetUserId);
          switch (followUserResult) {
            case Ok<FollowUserModel>():
              _followUserModel = followUserResult.value;
              _log.fine(
                  'Follow user model loaded: ${_followUserModel!.isActive}');
            case Error<FollowUserModel>():
              _log.warning(
                  'Failed to check if following', followUserResult.error);
          }

          notifyListeners();
          return Result.ok(_user!);

        case Error<UserModel>():
          _log.warning('Failed to load user', result.error);
          return Result.error(result.error);
      }
    } catch (e) {
      _log.severe('Error in initLoad', e);
      return Result.error(Exception('Failed to load user'));
    }
  }

  Future<Result<void>> _followUser(String targetUserId) async {
    try {
      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result =
          await _followUserRepository.followUser(targetUserId, userId);
      switch (result) {
        case Ok<void>():
          _followUserModel!.isActive = true;
          return const Result.ok(null);
        case Error<void>():
          _log.warning('Failed to follow user', result.error);
          return Result.error(result.error);
      }
    } catch (e) {
      _log.severe('Error in followUser', e);
      return Result.error(Exception('Failed to follow user'));
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _unfollowUser(String targetUserId) async {
    try {
      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result =
          await _followUserRepository.unfollowUser(targetUserId, userId);
      switch (result) {
        case Ok<void>():
          _followUserModel!.isActive = false;
          return const Result.ok(null);
        case Error<void>():
          _log.warning('Failed to unfollow user', result.error);
          return Result.error(result.error);
      }
    } catch (e) {
      _log.severe('Error in followUser', e);
      return Result.error(Exception('Failed to follow user'));
    } finally {
      notifyListeners();
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
