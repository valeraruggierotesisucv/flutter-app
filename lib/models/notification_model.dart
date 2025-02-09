import 'package:eventify/utils/notification_types.dart';
import 'package:flutter/material.dart';

class NotificationModel {
  final String notificationId;
  final String fromUserId;
  final String toUserId;
  final NotificationType type;
  final String message;
  final DateTime createdAt;
  final String? eventImage;
  final String username;
  final String profileImage;

  NotificationModel({
    required this.notificationId,
    required this.fromUserId,
    required this.toUserId,
    required this.type,
    required this.message,
    required this.createdAt,
    this.eventImage,
    required this.username,
    required this.profileImage,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final notification = json['notification'];
    final userData = json['userData'];

    final notificationData = NotificationModel(
      notificationId: notification['notificationId'],
      fromUserId: notification['fromUserId'],
      toUserId: notification['toUserId'],
      type: _parseNotificationType(notification['type']),
      message: notification['message'],
      createdAt: DateTime.parse(notification['createdAt']),
      eventImage: notification['eventImage'],
      username: userData['username'],
      profileImage: userData['profileImage'],
    );
    debugPrint("----------------------------------");
    debugPrint(notificationData.toString()); 
    debugPrint("----------------------------------");
    return notificationData;
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type) {
      case 'LIKE':
        return NotificationType.likeEvent;
      case 'FOLLOW':
        return NotificationType.follow;
      case 'COMMENT':
        return NotificationType.commentEvent;
      default:
        throw Exception('Unknown notification type: $type');
    }
  }
}
