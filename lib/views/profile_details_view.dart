import 'package:eventify/models/notification_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/notification_types.dart';
import 'package:eventify/view_models/profile_details_view_model.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/profile_card.dart';
import 'package:eventify/widgets/event_thumbnail_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileDetailsView extends StatefulWidget {
  final String userId;
  final ProfileDetailsViewModel viewModel;

  const ProfileDetailsView({
    super.key,
    required this.userId,
    required this.viewModel,
  });

  @override
  State<ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<ProfileDetailsView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.initLoad.execute(widget.userId);
    widget.viewModel.initLoad.addListener(_onLoad);
  }

  @override
  void dispose() {
    widget.viewModel.initLoad.removeListener(_onLoad);
    super.dispose();
  }

  void _onLoad() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppHeader(
        title: t.profileDetailsTitle,
        goBack: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.white,
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.initLoad.running) {
            return const Center(child: Loading());
          }

          final user = widget.viewModel.user;
          if (user == null) {
            return Center(
              child: Text(t.profileDetailsLoadError),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileCard(
                  editButtonLabel: t.profileDetailsEdit,
                  configButtonLabel: t.profileDetailsConfig,
                  username: user.fullname,
                  biography: user.biography ?? "",
                  events: user.eventsCounter ?? 0,
                  followers: user.followersCounter,
                  following: user.followingCounter,
                  profileImage: user.profileImage,
                  onFollowers: () {},
                  onFollowed: () {},
                  isOtherUser: true,
                  isFollowing:
                      widget.viewModel.followUserModel?.isActive ?? false,
                  onFollow: () {
                    widget.viewModel.followUserModel?.isActive == true
                        ? widget.viewModel.unfollowUser.execute(widget.userId)
                        : widget.viewModel.followUser.execute(widget.userId);
                    
                    if(widget.viewModel.followUserModel?.isActive == false){
                      handleSendNotification(user);
                    }
                    
                  },
                  eventsLabel: t.profileDetailsEvents,
                  followersLabel: t.profileDetailsFollowers,
                  followingLabel: t.profileDetailsFollowing,
                  followButtonLabel: widget.viewModel.followUserModel?.isActive == true 
                    ? t.profileDetailsUnfollow 
                    : t.profileDetailsFollow,
                ),
                EventThumbnailList(
                  events: widget.viewModel.events,
                  onEventTap: (String eventId) {
                    debugPrint("Event tapped: $eventId");
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void handleSendNotification(user) async {
    final toUserToken =
        await widget.viewModel.fetchNotificationToken(user.userId);
    final fromUserId =
        Provider.of<UserProvider>(context, listen: false).user?.id;

    final message = "Comenzó a seguirte";

    if(toUserToken != null){
      await widget.viewModel.sendNotification(toUserToken, user.username, message);
    }
    if (fromUserId != null) {      
      await widget.viewModel.createNotification(NotificationModel(
        notificationId: "",
        fromUserId: fromUserId,
        toUserId: widget.userId,
        type: NotificationType.follow,
        message: message,
        createdAt: DateTime.now(),
        username: user.username,
        profileImage: user.profileImage));
    }
  }
}
