import 'package:eventify/view_models/followed_view_model.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/user_card.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:eventify/widgets/custom_search_bar.dart';

class FollowedView extends StatefulWidget {
  const FollowedView({
    super.key,
    required this.viewModel,
    required this.userId,
  }); 

  final FollowedViewModel viewModel;
  final String userId;
  
  @override
  State createState() => _FollowedViewState();
}

class _FollowedViewState extends State<FollowedView> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    widget.viewModel.getFollowed.addListener(_onLoad);
    widget.viewModel.getFollowed.execute();
  }

  @override
  void dispose() {
    widget.viewModel.getFollowed.removeListener(_onLoad);
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
        title: "Seguidos",
        goBack: () => Navigator.of(context).pop(),
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
                  if (widget.viewModel.getFollowed.running) {
                    return Loading();
                  }

                  final followed = widget.viewModel.followed;
                  if (followed.isEmpty) {
                    return const Center(
                      child: Text('No sigues a nadie'),
                    );
                  }

                  final filteredFollowed = followed.where((follow) =>
                    follow.followedName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false
                  ).toList();

                  return ListView.builder(
                    itemCount: filteredFollowed.length,
                itemBuilder: (context, index) {
                      final follow = filteredFollowed[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: UserCard(
                          profileImage: follow.followedProfileImage,
                          username: follow.followedName ?? "Usuario",
                          onPressButton: () {
                            widget.viewModel.unfollowUser.execute(follow.userIdFollowedBy);
                          },
                      variant: UserCardVariant.withButton,
                          actionLabel: "Dejar de seguir",
                          isFollowing: true,
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
