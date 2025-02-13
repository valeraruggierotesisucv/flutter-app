import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/location_repository.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/models/notification_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/notification_types.dart';
import 'package:eventify/view_models/edit_event_view_model.dart';
import 'package:eventify/view_models/event_details_model_view.dart';
import 'package:eventify/views/edit_event_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppHeader(
        title: t.eventDetailsTitle,
        goBack: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
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
                          date: DateTime.parse(widget.viewModel.event?.date ?? ""),
                          latitude: widget.viewModel.event?.latitude ?? "",
                          longitude: widget.viewModel.event?.longitude ?? "",
                          startsAt: DateTime.parse(widget.viewModel.event?.startsAt ?? ""),
                          endsAt: DateTime.parse(widget.viewModel.event?.endsAt ?? ""),
                          category: widget.viewModel.event?.category ?? "",
                          musicUrl: widget.viewModel.event?.musicUrl ?? "",
                          userComment: userComment,
                          variant: EventCardVariant.details,
                          onPressUser: () {},
                          fetchComments: widget.viewModel.loadComments,
                          commentsListenable: widget.viewModel.commentsListenable,
                          onCommentSubmit: (message) async {
                              await widget.viewModel.submitComment.execute(widget.eventId, message);
                              handleSendNotification(widget.viewModel.event, NotificationType.commentEvent);
                            },
                          handleLike: () async {
                            await widget.viewModel.handleLike.execute(widget.eventId);
                            if(widget.viewModel.event?.isLiked == true){
                              handleSendNotification(widget.viewModel.event, NotificationType.likeEvent);
                            } 
                          },
                        );
                      },
                    ),
                    if (widget.canEdit)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: CustomButton(
                          label: t.eventDetailsEditButton,
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEventView(
                                  viewModel: EditViewModel(
                                    context: context,
                                    eventId: widget.eventId,
                                    eventRepository: EventRepository(
                                      Provider.of<ApiClient>(context, listen: false)
                                    ),
                                    locationRepository: LocationRepository(
                                      Provider.of<ApiClient>(context, listen: false)
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
      );
  }

  void handleSendNotification(event, type) async {
    final toUserToken =
        await widget.viewModel.fetchNotificationToken(event.userId);
    final fromUserId =
        Provider.of<UserProvider>(context, listen: false).user?.id;

    final message = type == NotificationType.likeEvent ? "Le gustó tu evento" : "Comentó en tu evento"; 

    if(toUserToken != null){
      await widget.viewModel.sendNotification(toUserToken, event.username, message);
    }
    if (fromUserId != null) {      
      await widget.viewModel.createNotification(NotificationModel(
          notificationId: "",
          fromUserId: fromUserId,
          toUserId: event.userId,
          type: type,
          message: message,
          createdAt: DateTime.now(),
          username: event.username,
          profileImage: event.profileImage,
          eventImage: event.eventImage));
    }
  }
}
