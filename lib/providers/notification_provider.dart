import 'package:eventify/data/repositories/notification_repository.dart';
import 'package:eventify/services/push_notifications.dart';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationRepository _notificationRepository;
  String? notificationToken;
  List<NotificationModel> _notifications = [];

  NotificationProvider(this._notificationRepository);

  Future<void> fetchNotificationToken(String userId) async {
    final result = await _notificationRepository.getNotificationToken(userId);
    debugPrint("[notification_provider]: dbToken:$result");

    final fcmToken = await FirebaseApi().getFirebaseToken();
    debugPrint("[notificationProvider] fcmToken:-->$fcmToken");

    // Comparar result con fcmToken
    if (result != fcmToken) {
      debugPrint("Se debe actualizar el token");
      notificationToken = fcmToken; // Actualizar notificationToken
      await _notificationRepository.updateNotificationToken(userId, fcmToken); 
    } else {
      debugPrint("No se debe actualizar el token");
    }

    notifyListeners(); // Notifica a los oyentes sobre el cambio
  }

  Future<void> sendNotification(
      String toNotificationToken, String title, String body) async {
    final result = await _notificationRepository.sendNotification(
        toNotificationToken, title, body);
    debugPrint("[notification_provider]: $result");
  }

  List<NotificationModel> get notifications => _notifications;
}
