import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/notification_item.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key}); 

  @override
  State createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  List notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    // Simulación de la obtención de notificaciones
    notifications = [
      {
        "user": "Usuario1",
        "userAvatar": "https://crnarpvpafbywvdzfukp.supabase.co/storage/v1/object/public/EventImages/1738701932649",
        "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
        "type": NotificationType.follow,
      },
      {
        "user": "Usuario2",
        "userAvatar": "https://crnarpvpafbywvdzfukp.supabase.co/storage/v1/object/public/EventImages/1738701932649",
        "timestamp": DateTime.now().subtract(Duration(hours: 1)),
        "type": NotificationType.likeEvent,
        "eventImage": "https://crnarpvpafbywvdzfukp.supabase.co/storage/v1/object/public/EventImages/1738635570177"
      },
      {
        "user": "Usuario3",
        "userAvatar": "https://crnarpvpafbywvdzfukp.supabase.co/storage/v1/object/public/EventImages/1738701932649",
        "timestamp": DateTime.now().subtract(Duration(days: 1)),
        "type": NotificationType.commentEvent,
        "eventImage": "https://crnarpvpafbywvdzfukp.supabase.co/storage/v1/object/public/EventImages/1738635570177",
      },
    ];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppHeader(),
        body: Column(
          children: [
            isLoading
                ? Loading()
                : Expanded(
                    child: ListView.builder(
                      itemCount: notifications.length ,
                      itemBuilder: (context, index) {
                        final item = notifications[index];
                        return NotificationItem(
                          user: item['user'],
                          timestamp: item['timestamp'],
                          userAvatar: item['userAvatar'],
                          type: item['type'],
                          eventImage: item['eventImage'],
                          onFollow: () => debugPrint("SEGUIR"),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
