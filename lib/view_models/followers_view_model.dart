import 'package:eventify/data/repositories/follow_user_repository.dart';
import 'package:eventify/models/follow_user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class FollowersViewModel extends ChangeNotifier {

  FollowersViewModel(
      {required BuildContext context,
      required FollowUserRepository followUserRepository})
      : _followUserRepository = followUserRepository,
        _context = context {
        getFollowers = Command0(_getFollowers);
        followUser = Command1<void, String>(_followUser);
        unfollowUser = Command1<void, String>(_unfollowUser);
  }

  final BuildContext _context;
  final FollowUserRepository _followUserRepository;
  final _log = Logger('FollowersViewModel');

  late final Command0<dynamic> getFollowers;
  late final Command1<void, String> followUser;
  late final Command1<void, String> unfollowUser;

  List<FollowUserModel> _followers = [];
  List<FollowUserModel> get followers => _followers;


  Future<Result<List<FollowUserModel>>> _getFollowers() async {
    try {
      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }
      final result = await _followUserRepository.getFollowers(userId);
      switch (result) {
        case Ok<List<FollowUserModel>>():
          _followers = result.value;
          notifyListeners();
        case Error():
          _log.severe('Error loading followers: ${result.error}');
      }
      return result;
    } catch (e) {
      _log.severe('Error loading followers: $e');
      return Result.error(Exception(e));
    }
  }
  
  Future<Result<void>> _followUser(String targetUserId) async {
    try {
      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result = await _followUserRepository.followUser(targetUserId, userId);
      if (result case Ok()) {
        await getFollowers.execute();
      }
      return result;
    } catch (e) {
      _log.severe('Error in followUser', e);
      return Result.error(Exception('Failed to follow user'));
    }
  }

  Future<Result<void>> _unfollowUser(String targetUserId) async {
    try {
      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result = await _followUserRepository.unfollowUser(targetUserId, userId);
      if (result case Ok()) {
        await getFollowers.execute();
      }
      return result;
    } catch (e) {
      _log.severe('Error in unfollowUser', e);
      return Result.error(Exception('Failed to unfollow user'));
    }
  }
}
