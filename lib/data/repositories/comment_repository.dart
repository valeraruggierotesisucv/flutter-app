import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/models/comment_model.dart';
import 'package:eventify/utils/result.dart';

class CommentRepository {
  final ApiClient _apiClient;
  List<CommentModel>? _cachedComments;
  final String _cachedEventId = '';
  CommentRepository(this._apiClient);


  Future<Result<List<CommentModel>>> getComments(String eventId) async {
    if( _cachedComments == null || _cachedEventId != eventId) {
      final result = await _apiClient.getComments(eventId);

      if(result is Ok<List<CommentModel>>) {
        _cachedComments = result.value;
      }
      // print("result $result");
      return result;

    } else {
      return Result.ok(_cachedComments!);
    }
  }

  Future<Result<void>> submitComment(String eventId, String userId, CommentModel comment) async {
    print("submitComment");
    print(eventId);
    print(userId);
    print(comment);
    final result = await _apiClient.submitComment(eventId, userId, comment);
    return result;
  }
  
  

}
