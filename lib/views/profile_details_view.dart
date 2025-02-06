import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/profile_card.dart';
import 'package:eventify/widgets/event_thumbnail_list.dart';
import 'package:flutter/material.dart';

class ProfileDetailsView extends StatelessWidget {
  final String userId;
  const ProfileDetailsView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Sample events data - replace with your actual data
    final sampleEvents = [
      {
        'id': '1',
        'imageUrl': 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg',
        'title': 'Event 1',
        'location': 'Location 1',
        'date': '2024-01-01',
        'userId': '1',
        'description': 'Description 1',
        'likes': 10,
        'comments': 5,
      },
      // Add more sample events as needed
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppHeader(
        goBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          ProfileCard(
            username: "José Miguel Valera",
            biography: "No 5th street off one palace road eltufun hella state",
            events: 24,
            followers: 32,
            following: 40,
            onFollowers: () {
              // Navigate to followers view
            },
            onFollowed: () {
              // Navigate to following view
            },
            isOtherUser: true,
            isFollowing: false,
            onFollow: () {
              debugPrint("Follow/Unfollow user");
            },
          ),
          Expanded(
            child: EventThumbnailList(
              events: sampleEvents.map((event) => Event(
                id: event['id'] as String,
                imageUrl: event['imageUrl'] as String,
              )).toList(),
              onEventTap: (String eventId) {
                debugPrint("Event tapped: $eventId");
              },
            ),
          ),
        ],
      ),
    );
  }
}
