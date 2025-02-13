import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/models/follow_user_model.dart';
import 'package:eventify/utils/result.dart';

class FollowUserRepository {
  final ApiClient _apiClient;

  FollowUserRepository(this._apiClient);
  
  Future<Result<FollowUserModel>> isFollowing( String userId, String targetUserId) async {
    try {
      final result = await _apiClient.isFollowing(userId, targetUserId);
      return result;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> followUser(String targetUserId, String userId) async {
    try {
      final result = await _apiClient.followUser(targetUserId, userId);
      return result;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> unfollowUser(String targetUserId, String userId) async {
    try {
      final result = await _apiClient.unfollowUser(targetUserId, userId);
      return result;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<FollowUserModel>>> getFollowed(String userId) async {
    try {
      final result = await _apiClient.getFollowed(userId);
      return result;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<FollowUserModel>>> getFollowers(String userId) async {
    try {
      final result = await _apiClient.getFollowers(userId);
      return result;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
