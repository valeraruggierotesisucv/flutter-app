import 'package:eventify/data/repositories/comment_repository.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/follow_user_repository.dart';
import 'package:eventify/data/repositories/notification_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/models/notification_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:eventify/utils/notification_types.dart';
import 'package:eventify/view_models/event_details_model_view.dart';
import 'package:eventify/view_models/home_view_model.dart';
import 'package:eventify/view_models/profile_details_view_model.dart';
import 'package:eventify/views/event_details_view.dart';
import 'package:eventify/views/profile_details_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => HomeScreen(viewModel: viewModel),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    debugPrint('HomeScreen initialized');
    widget.viewModel.load.addListener(_onResult);
    widget.viewModel.handleLike.addListener(_onLike);
    widget.viewModel.load.execute();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.load.removeListener(_onResult);
    widget.viewModel.load.addListener(_onResult);
    oldWidget.viewModel.handleLike.removeListener(_onLike);
    widget.viewModel.handleLike.addListener(_onLike);
  }

  @override
  void dispose() {
    widget.viewModel.load.removeListener(_onResult);
    widget.viewModel.handleLike.removeListener(_onLike);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, child) {
                  if (widget.viewModel.load.running) {
                    return Loading();
                  }

                  return Column(
                    children: widget.viewModel.events
                        .map((event) {
                          
                          return EventCard(
                            eventId: event.eventId,
                            profileImage: event.profileImage,
                            username: event.username,
                            eventImage: event.eventImage,
                            title: event.title,
                            description: event.description,
                            isLiked: event.isLiked,
                            date: DateTime.parse(event.date),
                            userComment: {},
                            onPressUser: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileDetailsView(
                                    userId: event.userId, 
                                    viewModel: ProfileDetailsViewModel(
                                      context: context,
                                      userRepository: UserRepository(
                                        Provider.of<ApiClient>(context, listen: false)
                                      ),
                                      eventRepository: EventRepository(
                                        Provider.of<ApiClient>(context, listen: false)
                                      ),
                                      followUserRepository: FollowUserRepository(
                                        Provider.of<ApiClient>(context, listen: false)
                                      ),
                                      notificationRepository: NotificationRepository(
                                        Provider.of<ApiClient>(context, listen: false)
                                      )
                                    ),
                                  ),
                                ),
                              );
                            },
                            fetchComments: widget.viewModel.loadComments,
                            commentsListenable: widget.viewModel.commentsListenable,       
                            onMoreDetails: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailsView(
                                    eventId: event.eventId, 
                                    canEdit: false,
                                    viewModel: EventDetailsViewModel(context: context, eventRepository: 
                                      EventRepository(
                                        Provider.of<ApiClient>(context, listen: false)
                                      ),
                                      commentRepository: CommentRepository(
                                          Provider.of<ApiClient>(context,
                                              listen: false)),
                                      notificationRepository: NotificationRepository(
                                        Provider.of<ApiClient>(context,
                                              listen: false)
                                      ),
                                      userRepository: UserRepository(
                                          Provider.of<ApiClient>(context,
                                              listen: false)), )),


                            ),
                          );
                        },
                        handleLike: () async {
                          await widget.viewModel.handleLike
                              .execute(event.eventId);
                          if(event.isLiked){
                             handleSendNotification(event, NotificationType.likeEvent);
                          }                          
                        },
                        onCommentSubmit: (message) async {
                          await widget.viewModel.submitComment
                              .execute(event.eventId, message);
                          handleSendNotification(event, NotificationType.commentEvent); 
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onResult() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onLike() {
    if (mounted) {
      setState(() {});
      widget.viewModel.load.execute();
    }
  }

  void handleSendNotification(event, type) async {
    final toUserToken = await widget.viewModel.fetchNotificationToken(event.userId);
    final fromUserId = Provider.of<UserProvider>(context, listen: false).user?.id;
    final username = Provider.of<UserProvider>(context, listen: false).user?.email;

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
          username: username,
          profileImage: event.profileImage,
          eventImage: event.eventImage));
    }
  }
}
