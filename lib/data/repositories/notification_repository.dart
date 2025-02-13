import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../../models/notification_model.dart';
import '../../utils/result.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository(this._apiClient);

  Future<Result<List<NotificationModel>>> getNotifications(
      String userId) async {
    return await _apiClient.getNotifications(userId);
  }

  Future<Result<void>> sendNotification(
      String toNotificationToken, String title, String body) async {
    final data = {
      'title': title,
      'body': body,
    };

    return await _apiClient.sendNotification(toNotificationToken, data);
  }

  Future<String?> getNotificationToken(String userId) async {
    final result = await _apiClient.getNotificationToken(userId);
    debugPrint("[notification_repository]: $result");
    return result;
  }

  Future<Result<void>> updateNotificationToken(
      String userId, String notificationToken) async {
    final result =
        await _apiClient.updateNotificationToken(userId, notificationToken);

    return result;
  }

  Future<Result<void>> createNotification(
      NotificationModel notificationData) async {
    final result = await _apiClient.createNotification(notificationData);

    debugPrint("result $result");
    return result; 
  }
}
