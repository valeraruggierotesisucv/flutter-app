import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/notification_item.dart';
import 'package:eventify/view_models/notifications_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsView extends StatelessWidget {
  final NotificationsViewModel viewModel;
  
  const NotificationsView({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppHeader(title: t.notificationsTitle),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: viewModel,
          builder: (context, _) {
            if (viewModel.isLoading) {
              return const Loading();
            }

            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.notificationsError,
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: viewModel.loadNotifications,
                      child: Text(t.notificationsRetry),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.notifications.isEmpty) {
              return Center(
                child: Text(t.notificationsEmpty),
              );
            }

            return RefreshIndicator(
              onRefresh: viewModel.loadNotifications,
              child: ListView.builder(
                itemCount: viewModel.notifications.length,
                itemBuilder: (context, index) {
                  final notification = viewModel.notifications[index];
                  return NotificationItem(
                    user: notification.username ?? t.notificationsUserNotAvailable,
                    timestamp: notification.createdAt,
                    userAvatar: notification.profileImage ?? t.notificationsUserNotAvailable,
                    type: notification.type,
                    eventImage: notification.eventImage ?? "https://placehold.co/600x400/png",
                    onFollow: () => debugPrint("SEGUIR"),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
