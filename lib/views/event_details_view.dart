import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:flutter/material.dart';

class EventDetailsView extends StatefulWidget {
  final String eventId;
  final bool canEdit; 

  const EventDetailsView({
    super.key, 
    required this.eventId,
    this.canEdit = false,
  });

  @override
  State createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  bool isLoading = false;
  final userComment = {
    "username": "John",
    "profileImage":
        "https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: "Event Details",
        goBack: () => Navigator.pop(context)),
        backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Loading()
            : SingleChildScrollView(
                child: Column(
                  children: [                    
                    EventCard(
                      eventId: "1",
                      profileImage:
                          "https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg",
                      username: 'Ejemplo Usuario',
                      eventImage:
                          "https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg",
                      title: widget.eventId,
                      description: "description",
                      isLiked: true,
                      date: "10-02-2025",
                      userComment: userComment,
                  
                      onPressUser: () {},
                      onComment: (eventId, comment) async {
                        debugPrint(eventId);
                        debugPrint(comment);
                      },
                      onShare: () {},
                      fetchComments: () async => [],
                      handleLike: () {},
                    ),
                    if (widget.canEdit)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: CustomButton(
                          label: "Edit",
                          onPress: () {
                            // Navigate to edit event
                          },
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
