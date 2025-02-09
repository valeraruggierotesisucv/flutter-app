import '../services/api_client.dart';
import '../../models/notification_model.dart';
import '../../utils/result.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository(this._apiClient);

  Future<Result<List<NotificationModel>>> getNotifications(String userId) async {
    return await _apiClient.getNotifications(userId);
  }
}