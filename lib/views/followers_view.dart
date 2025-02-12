import 'package:eventify/view_models/followers_view_model.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/user_card.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:eventify/widgets/custom_search_bar.dart';

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
        title: "Seguidores", 
        goBack: () => Navigator.of(context).pop()
      ),
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

                  final filteredFollowers = followers.where((follower) =>
                    follower.userIdFollows.toLowerCase().contains(searchQuery.toLowerCase())
                  ).toList();

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
                                ? widget.viewModel.unfollowUser.execute(follower.userIdFollows)
                                : widget.viewModel.followUser.execute(follower.userIdFollows);
                          },
                          variant: UserCardVariant.withButton,
                          actionLabel: follower.isActive ? "Dejar de seguir" : "Seguir",
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
}
