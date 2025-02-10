import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/view_models/profile_view_model.dart';
import 'package:eventify/views/configuration_view.dart';
import 'package:eventify/views/edit_profile_view.dart';
import 'package:eventify/views/followed_view.dart';
import 'package:eventify/views/folowers_view.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/profile_card.dart';
import 'package:eventify/widgets/event_thumbnail_list.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (context) => ProfileHomeScreen( viewModel: viewModel ),
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
            return const Center(
              child: Text('Failed to load profile'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileCard(
                  username: user.username,
                  biography: user.biography ?? "",
                  events: user.eventsCounter ?? 0,
                  followers: user.followersCounter,
                  following: user.followingCounter,
                  onFollowers: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FollowersView()),
                    );
                  },
                  onFollowed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FollowedView()),
                    );
                  },
                  onConfigureProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ConfigurationView()),
                    );
                  },
                  onEditProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileView()),
                    );
                  },
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
}
