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
                      latitude: "68.12458",
                      longitude: "-84.3215",
                      startsAt: "8:00 PM",
                      endsAt: "10:00 PM",
                      category: "MUSIC",
                      musicUrl: "https://crnarpvpafbywvdzfukp.supabase.co/storage/v1/object/public/DONT%20DELETE/EventsMusic.mp3",
                      userComment: userComment,
                      variant: EventCardVariant.details,
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
