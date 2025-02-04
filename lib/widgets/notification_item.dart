import 'package:eventify/utils/date_formatter.dart';
import 'package:flutter/material.dart';


enum NotificationType {
  follow,
  likeEvent,
  commentEvent,
}

const Map<NotificationType, String> notificationMessages = {
  NotificationType.follow: 'Comenzó a seguirte',
  NotificationType.likeEvent: 'Dió me gusta a tu evento',
  NotificationType.commentEvent: 'Comentó en tu evento',
};


class NotificationItem extends StatelessWidget {
  final String user;


  final String userAvatar;
  final DateTime timestamp;
  final NotificationType type;
  final String? eventImage;
  final Function()? onFollow;




  const NotificationItem({
    super.key,
    required this.user,
    required this.userAvatar,
    required this.timestamp,
    required this.type,
    this.eventImage,
    this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                userAvatar,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatDate(timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                  ],
                ),
                Text(notificationMessages[type]!),
              ],
            ),
          ),
          if(type == NotificationType.commentEvent || type == NotificationType.likeEvent)
            SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  eventImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );


  }



}