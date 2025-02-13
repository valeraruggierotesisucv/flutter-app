import 'package:eventify/data/repositories/comment_repository.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/follow_user_repository.dart';
import 'package:eventify/data/repositories/notification_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/view_models/edit_profile_view_model.dart';
import 'package:eventify/view_models/event_details_model_view.dart';
import 'package:eventify/view_models/followers_view_model.dart';
import 'package:eventify/view_models/profile_view_model.dart';
import 'package:eventify/views/configuration_view.dart';
import 'package:eventify/views/edit_profile_view.dart';
import 'package:eventify/views/event_details_view.dart';
import 'package:eventify/views/followed_view.dart';
import 'package:eventify/views/followers_view.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/profile_card.dart';
import 'package:eventify/widgets/event_thumbnail_list.dart';
import 'package:provider/provider.dart';
import 'package:eventify/view_models/followed_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => ProfileHomeScreen(viewModel: viewModel),
        );
      },
    );
  }
}

class ProfileHomeScreen extends StatefulWidget {
  final ProfileViewModel viewModel;
  const ProfileHomeScreen({super.key, required this.viewModel});

  @override
  State createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  final authService = AuthService();
  

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
    if (userId != null) {
      widget.viewModel.initLoad.execute(userId);
    }
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
      appBar: AppHeader(),
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
              child: Text(t.profileLoadError),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileCard(
                  username: user.fullname,
                  biography: user.biography ?? "",
                  events: user.eventsCounter ?? 0,
                  followers: user.followersCounter,
                  following: user.followingCounter,
                  profileImage: user.profileImage,
                  eventsLabel: t.profileDetailsEvents,
                  followersLabel: t.profileDetailsFollowers,
                  followingLabel: t.profileDetailsFollowing,
                  followButtonLabel: t.profileDetailsFollow,
                  editButtonLabel: t.profileEditButton,
                  configButtonLabel: t.profileConfigButton,
                  onFollowers: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FollowersView(
                              userId: user.userId,
                              viewModel: FollowersViewModel(
                                  context: context,
                                  notificationRepository: NotificationRepository(
                                    Provider.of<ApiClient>(context, listen: false)
                                  ),
                                  followUserRepository: FollowUserRepository(
                                      Provider.of<ApiClient>(context,
                                          listen: false))))),
                    );
                  },
                  onFollowed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowedView(
                          userId: user.userId,
                          viewModel: FollowedViewModel(
                            context: context,
                            followUserRepository: FollowUserRepository(
                              Provider.of<ApiClient>(context, listen: false),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  onConfigureProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConfigurationView()),
                    );
                  },
                  onEditProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileView(
                          viewModel: EditProfileViewModel(
                              context: context,
                              userRepository: UserRepository(
                                  Provider.of<ApiClient>(context,
                                      listen: false))),
                          onProfileUpdated: () {
                            final userId = Provider.of<UserProvider>(context,
                                    listen: false)
                                .user
                                ?.id;
                            if (userId != null) {
                              widget.viewModel.initLoad.execute(userId);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
                EventThumbnailList(
                  events: widget.viewModel.events,
                  onEventTap: (String eventId) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsView(
                          eventId: eventId,
                          canEdit: true,
                          viewModel: EventDetailsViewModel(
                            context: context,
                            userRepository: UserRepository(
                              Provider.of<ApiClient>(context, listen: false)
                            ),
                            eventRepository: EventRepository(
                              Provider.of<ApiClient>(context, listen: false)
                            ),
                            notificationRepository: NotificationRepository(
                              Provider.of<ApiClient>(context, listen: false)
                            ),
                            commentRepository: CommentRepository(
                              Provider.of<ApiClient>(context, listen: false)
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
