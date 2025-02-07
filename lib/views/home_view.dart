import 'package:eventify/services/auth_service.dart';
import 'package:eventify/view_models/home_view_model.dart';
import 'package:eventify/views/event_details_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key,
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
    print('HomeScreen initialized');
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
                        .map((event) => EventCard(
                              eventId: event.eventId,
                              profileImage: event.profileImage,
                              username: event.username,
                              eventImage: event.eventImage,
                              title: event.title,
                              description: event.description,
                              isLiked: event.isLiked,
                              date: event.date,
                              userComment: {},
                              onPressUser: () {},
                              onComment: (eventId, comment) async {
                                debugPrint(eventId);
                                debugPrint(comment);
                              },                              
                              onMoreDetails: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventDetailsView(
                                      eventId: event.eventId, 
                                      canEdit: false,
                                    ),
                                  ),
                                );
                              }, 
                              onShare: () {},
                              fetchComments: () async => [],
                              handleLike: () async {
                                await widget.viewModel.handleLike.execute(event.eventId);
                                
                              },
                            ))
                        .toList(),
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
    
  }

  void _onLike() {
    
  }

}
