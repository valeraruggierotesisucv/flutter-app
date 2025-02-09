import 'package:eventify/models/event_model.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/models/social_interactions.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/utils/result.dart' show Result, Ok, Error;

class UserRepository {

  UserRepository(this._apiClient);
  final ApiClient _apiClient;
  

  Future<Result<List<UserModel>>> searchUsers(String query) async {
    try {
      final result = await _apiClient.searchUsers(query);
      return result;
    } on Exception catch (error) {
      return Result.error(error);
    }

  }
} 