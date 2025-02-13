import 'package:eventify/data/repositories/follow_user_repository.dart';
import 'package:eventify/models/follow_user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class FollowedViewModel extends ChangeNotifier {
  FollowedViewModel({
    required BuildContext context,
    required FollowUserRepository followUserRepository,
  })  : _followUserRepository = followUserRepository,
        _context = context {
    getFollowed = Command0(_getFollowed);
    unfollowUser = Command1<void, String>(_unfollowUser);
  }

  final BuildContext _context;
  final FollowUserRepository _followUserRepository;
  final _log = Logger('FollowedViewModel');

  late final Command0<dynamic> getFollowed;
  late final Command1<void, String> unfollowUser;

  List<FollowUserModel> _followed = [];
  List<FollowUserModel> get followed => _followed;

  Future<Result<List<FollowUserModel>>> _getFollowed() async {
    try {
      final userId = Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        return Result.error(Exception('User not logged in'));
      }
      final result = await _followUserRepository.getFollowed(userId);
      switch (result) {
        case Ok<List<FollowUserModel>>():
          _followed = result.value;
          notifyListeners();
        case Error():
          _log.severe('Error loading followed: ${result.error}');
      }
      return result;
    } catch (e) {
      _log.severe('Error loading followed: $e');
      return Result.error(Exception(e));
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
        await getFollowed.execute();
      }
      return result;
    } catch (e) {
      _log.severe('Error in unfollowUser', e);
      return Result.error(Exception('Failed to unfollow user'));
    }
  }
}
