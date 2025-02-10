import 'package:eventify/view_models/event_details_model_view.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:flutter/material.dart';

class EventDetailsView extends StatefulWidget {
  final String eventId;
  final bool canEdit; 
  final EventDetailsViewModel viewModel;

  const EventDetailsView({
    super.key, 
    required this.eventId,
    this.canEdit = false,
    required this.viewModel,
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
  void initState() {
    super.initState();
    widget.viewModel.getEventDetails.execute(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: "Event Details",
        goBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: isLoading
            ? Loading()
            : SingleChildScrollView(
                child: Column(
                  children: [ 
                    ListenableBuilder(
                      listenable: widget.viewModel,
                      builder: (context, child) {
                        if(widget.viewModel.getEventDetails.running) {
                          return Loading();
                        }

                        return EventCard(
                          eventId: widget.viewModel.event?.eventId ?? "",
                          profileImage: widget.viewModel.event?.profileImage ?? "",
                          username: widget.viewModel.event?.username ?? "",
                          eventImage: widget.viewModel.event?.eventImage ?? "",
                          title: widget.viewModel.event?.title ?? "",
                          description: widget.viewModel.event?.description ?? "",
                          isLiked: widget.viewModel.event?.isLiked ?? false,
                          date: widget.viewModel.event?.date ?? "",
                          latitude: widget.viewModel.event?.latitude ?? "",
                          longitude: widget.viewModel.event?.longitude ?? "",
                          startsAt: widget.viewModel.event?.startsAt ?? "",
                          endsAt: widget.viewModel.event?.endsAt ?? "",
                          category: widget.viewModel.event?.category ?? "",
                          musicUrl: widget.viewModel.event?.musicUrl ?? "",
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
                        );
                      },
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
