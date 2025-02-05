import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/routes.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:eventify/views/event_details_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_search_bar.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/profile_card.dart';
import 'package:eventify/widgets/user_card.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/category_button.dart';
import 'package:eventify/widgets/social_interactions.dart';
import 'package:eventify/widgets/custom_chip.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:eventify/widgets/tabs.dart';
import 'package:eventify/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _searchValue = '';
  String _selectedCategory = '';
  TextEditingController _controller = TextEditingController();
  final authService = AuthService();

  Future<void> onComment(String eventId, String comment) async {
    // Implementar lógica para manejar comentarios
    debugPrint('Nuevo comentario en evento $eventId: $comment');
  }

  Future<List<dynamic>> fetchEvents() async {
    // Add artificial delay of 2 seconds
    await Future.delayed(const Duration(seconds: 8));

    return [
      {
        'id': '1',
        'title': 'Evento 1',
        'description': 'Descripción del evento 1',
        'image':
            'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg',
        'location': 'Ciudad, País',
        'date': DateTime.now(),
      },
      {
        'id': '2',
        'title': 'Evento 2',
        'description': 'Descripción del evento 2',
        'image':
            'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg',
        'location': 'Ciudad, País',
        'date': DateTime.now(),
      },
    ];
  }

  void handleLike() {
    debugPrint('Like presionado');
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
              FutureBuilder(
                future: fetchEvents(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Loading();
                  }

                  return Column(
                    children: snapshot.data!
                        .map((event) => EventCard(
                              eventId: event['id'],
                              profileImage: event['image'],
                              username: 'Usuario 1',
                              eventImage: event['image'],
                              title: event['title'],
                              description: 'Descripción del evento 1',
                              isLiked: false,
                              date: '2024-01-01',
                              userComment: {},
                              onPressUser: () {},
                              onComment: (eventId, comment) async {
                                debugPrint(eventId);
                                debugPrint(comment);
                              },
                              onMoreDetails: () {
                                Navigator.pushNamed(
                                  context,
                                  '/${AppScreens.eventDetails.name}',
                                  arguments: {
                                    'insideMainView': true,
                                    'eventData': event,
                                  }
                                );
                              },
                              onShare: () {},
                              fetchComments: () async => [],
                              handleLike: () {},
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
}
