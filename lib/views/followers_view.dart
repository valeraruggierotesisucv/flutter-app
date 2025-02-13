import 'package:eventify/models/notification_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/notification_types.dart';
import 'package:eventify/view_models/followers_view_model.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/user_card.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:eventify/widgets/custom_search_bar.dart';
import 'package:provider/provider.dart';

class FollowersView extends StatefulWidget {
  const FollowersView({
    super.key,
    required this.viewModel,
    required this.userId,
  });

  final FollowersViewModel viewModel;
  final String userId;

  @override
  State createState() => _FollowersViewState();
}

class _FollowersViewState extends State<FollowersView> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    widget.viewModel.getFollowers.addListener(_onLoad);
    widget.viewModel.getFollowers.execute();
  }

  @override
  void dispose() {
    widget.viewModel.getFollowers.removeListener(_onLoad);
    super.dispose();
  }

  void _onLoad() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
          title: "Seguidores", goBack: () => Navigator.of(context).pop()),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomSearchBar(
              onSearch: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  if (widget.viewModel.getFollowers.running) {
                    return Loading();
                  }

                  final followers = widget.viewModel.followers;
                  if (followers.isEmpty) {
                    return const Center(
                      child: Text('No hay seguidores'),
                    );
                  }

                  final filteredFollowers = followers
                      .where((follower) =>
                          follower.followerName
                              ?.toLowerCase()
                              .contains(searchQuery.toLowerCase()) ??
                          false)
                      .toList();

                  return ListView.builder(
                    itemCount: filteredFollowers.length,
                    itemBuilder: (context, index) {
                      final follower = filteredFollowers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: UserCard(
                          profileImage: follower.followerProfileImage,
                          username: follower.followerName ?? "Usuario",
                          onPressButton: () {
                            // Handle follow/unfollow
                            follower.isActive
                                ? widget.viewModel.unfollowUser
                                    .execute(follower.userIdFollows)
                                : widget.viewModel.followUser
                                    .execute(follower.userIdFollows);

                            if (follower.isActive == false) {
                              handleSendNotification(follower.userIdFollows);
                            } 
                          },
                          variant: UserCardVariant.withButton,
                          actionLabel:
                              follower.isActive ? "Dejar de seguir" : "Seguir",
                          isFollowing: follower.isActive,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleSendNotification(toUserId) async {
    debugPrint("ENVIANDO NOTIFICACION");
    final toUserToken = await widget.viewModel.fetchNotificationToken(toUserId);
    final fromUserId =
        Provider.of<UserProvider>(context, listen: false).user?.id;
    final username =
        Provider.of<UserProvider>(context, listen: false).user?.email; 

    final message = "Comenzó a seguirte";

    if (toUserToken != null && username != null) {
      await widget.viewModel.sendNotification(toUserToken, username, message);
    }
    if (fromUserId != null) {
      await widget.viewModel.createNotification(NotificationModel(
          notificationId: "",
          fromUserId: fromUserId,
          toUserId: widget.userId,
          type: NotificationType.follow,
          message: message,
          createdAt: DateTime.now(),
          username: username,
          profileImage: ""));
    }
  }
}
