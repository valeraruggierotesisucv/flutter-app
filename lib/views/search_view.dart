import 'package:eventify/data/repositories/comment_repository.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/follow_user_repository.dart';
import 'package:eventify/data/repositories/notification_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/models/locale.dart';
import 'package:eventify/view_models/event_details_model_view.dart';
import 'package:eventify/view_models/profile_details_view_model.dart';
import 'package:eventify/models/notification_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/utils/notification_types.dart';
import 'package:eventify/view_models/search_view_model.dart';
import 'package:eventify/views/event_details_view.dart';
import 'package:eventify/views/profile_details_view.dart';
import 'package:eventify/widgets/custom_search_bar.dart';
import 'package:eventify/widgets/pills.dart';
import 'package:eventify/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:eventify/routes.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/user_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  final SearchViewModel viewModel;
  const SearchView({super.key, required this.viewModel});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isLoading = false;
  int selectedTab = 1;
  String query = '';
  Timer? _debounce;
  late List<TabItem> tabs;

  @override
  void initState() {
    super.initState();
    widget.viewModel.handleLike.addListener(_onLike);
    widget.viewModel.searchEvents.addListener(_onSearch);
    widget.viewModel.searchUsers.addListener(_onSearch);
    widget.viewModel.getCategories.execute();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final t = AppLocalizations.of(context)!;
    tabs = [
      TabItem(id: 1, title: t.searchViewTabEvents),
      TabItem(id: 2, title: t.searchViewTabUsers),
    ];
  }

  @override
  void didUpdateWidget(covariant SearchView oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.searchEvents.removeListener(_onSearch);
    oldWidget.viewModel.searchUsers.removeListener(_onSearch);
    widget.viewModel.searchEvents.addListener(_onSearch);
    widget.viewModel.searchUsers.addListener(_onSearch);
  }

  @override
  void dispose( ) {
    _searchController.dispose();
    widget.viewModel.handleLike.removeListener(_onLike);
    widget.viewModel.searchEvents.removeListener(_onSearch);
    widget.viewModel.searchUsers.removeListener(_onSearch);
    _debounce?.cancel();
    super.dispose();
  }

  void _performSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        this.query = query;
      });
      
      switch (selectedTab) {
        case 1:
          widget.viewModel.searchEvents.execute(query);
          break;
        case 2:
          widget.viewModel.searchUsers.execute(query);
          break;
      }
    });
  }
  
  void onTabTap(int id) {
    setState(() {
      selectedTab = id;
    });
    if (id == 1) {
      widget.viewModel.searchEvents.execute(query);
    } else {
      widget.viewModel.searchUsers.execute(query);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    LocaleModel localeModel = Provider.of<LocaleModel>(context, listen: false);
    
    return Scaffold(
      appBar: AppHeader(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                CustomSearchBar(
                  onSearch: _performSearch,
                ),
                const SizedBox(height: 16),
                Tabs(tabs: tabs, onTabTap: onTabTap),
                const SizedBox(height: 16),
                
                selectedTab == 1
                ? Column(  
                    
                    children: [
                      Container(
                        child: ListenableBuilder(
                          listenable: widget.viewModel.getCategories,
                          builder: (context, child) {
                            if (widget.viewModel.getCategories.running) return const SizedBox();
                            return Pills(
                              categories: widget.viewModel.categories,
                              selectedCategories: widget.viewModel.selectedCategories,
                              onSelectCategories: (categoryIds) {
                                  widget.viewModel.selectCategory(categoryIds);
                              },
                              language: localeModel.locale?.languageCode,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _isLoading 
                        ? const Center(child: CircularProgressIndicator())
                        : ListenableBuilder(
                            listenable: widget.viewModel,
                            builder: (context, child) {
                              if (widget.viewModel.searchEvents.running) {
                                return Loading();
                              }
                              
                              if (query.isEmpty && widget.viewModel.selectedCategories.isEmpty) {
                                return Center(
                                  child: Text(
                                    t.searchViewInitialEvents,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }

                              if(widget.viewModel.events.isEmpty) {
                                return Center(child: Text(t.searchViewNoEvents));
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
                                        commentsListenable: widget.viewModel.commentsListenable,
                                        fetchComments: widget.viewModel.loadComments,
                                        onPressUser: () {},
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
                                                    Provider.of<ApiClient>(context, listen: false)
                                                  ),
                                                  notificationRepository: NotificationRepository(
                                                    Provider.of<ApiClient>(context, listen: false)
                                                  ),
                                                  userRepository: UserRepository(
                                                    Provider.of<ApiClient>(context, listen: false)
                                                  )
                                                  )
                                              ),
                                            ),
                                          );
                                        },
                                        handleLike: () async {
                                          await widget.viewModel.handleLike.execute(event.eventId);
                                          if(event.isLiked){
                                            handleSendNotification(event, NotificationType.likeEvent);
                                          } 
                                        },
                                        onCommentSubmit: (message) async {
                                          await widget.viewModel.submitComment.execute(event.eventId, message);
                                          handleSendNotification(event, NotificationType.commentEvent); 
                                        },
                                      );
                                    })
                                    .toList(),
                              );
                            },
                          ),
                    ],
                  )
                : ListenableBuilder(  // Users tab content
                    listenable: widget.viewModel.searchUsers,
                    builder: (context, child) {
                      if (widget.viewModel.searchUsers.running) {
                        return Loading();
                      }

                      if (query.isEmpty) {
                        return Center(
                            child: Text(
                              t.searchViewInitialUsers,
                              style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      } 

                      if(widget.viewModel.users.isEmpty) {
                        return Center(child: Text(t.searchViewNoUsers));
                      }

                      return Column(
                        spacing: 10,
                        children: widget.viewModel.users.map((user) => UserCard(
                          username: user.username,
                          profileImage: user.profileImage,
                          onPressUser: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileDetailsView(
                                  userId: user.userId,
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
                          variant: UserCardVariant.defaultCard,
                        )).toList(),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLike() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onSearch() {
    setState(() {
      _isLoading = widget.viewModel.searchEvents.running || 
                   widget.viewModel.searchUsers.running;
    });
  }

    void handleSendNotification(event, type) async {
    final toUserToken = await widget.viewModel.fetchNotificationToken(event.userId);
    final fromUserId = Provider.of<UserProvider>(context, listen: false).user?.id;
    final t = AppLocalizations.of(context)!;

    final message = type == NotificationType.likeEvent 
      ? t.searchViewLikedEvent 
      : t.searchViewCommentedEvent;

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
