import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:eventify/widgets/custom_search_bar.dart';

class FollowersView extends StatefulWidget {
  const FollowersView({super.key}); 
  
  @override
  State createState() => _FollowersViewState();
}

class _FollowersViewState extends State<FollowersView> {
  String search = "";
  List<Map<String, dynamic>>? followers;

  @override
  void initState() {
    super.initState();
    getFollowers();
  }

  Future<void> getFollowers() async {
    try {
      // Generar una lista de seguidores de ejemplo
      final response = [
        {
          'followerProfileImage': 'https://example.com/image1.jpg',
          'followerName': 'Usuario1',
          'followed': false,
        },
        {
          'followerProfileImage': 'https://example.com/image2.jpg',
          'followerName': 'Usuario2',
          'followed': true,
        },
        {
          'followerProfileImage': 'https://example.com/image3.jpg',
          'followerName': 'Usuario3',
          'followed': false,
        },
      ];

      setState(() {
        followers = response
            .map((follower) => {
                  ...follower,
                  'isFollowingLoading': false,
                })
            .toList();
      });
    } catch (error) {
      debugPrint("Error in getFollowers: $error");
      _showErrorDialog(error.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFollowers = followers
        ?.where((follower) => follower['followerName']
            .toLowerCase()
            .contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
                title: "Seguidores", goBack: () => Navigator.of(context).pop()),
            CustomSearchBar(
              onSearch: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFollowers?.length ?? 0,
                itemBuilder: (context, index) {
                  final follower = filteredFollowers![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: UserCard(
                      profileImage: follower['followerProfileImage'],
                      username: follower['followerName'],
                      onPressButton: () => debugPrint("ButtonPressed"),
                      variant: UserCardVariant.withButton,
                      actionLabel:
                          follower['followed'] ? "Dejar de seguir" : "Seguir",
                      disabled: follower['isFollowingLoading'],
                    ),
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
