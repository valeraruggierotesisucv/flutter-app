import 'package:eventify/services/auth_service.dart';
import 'package:eventify/views/event_details_view.dart';
import 'package:eventify/views/profile_details_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      },
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        'userId': '1',
      },
      {
        'id': '2',
        'title': 'Evento 2',
        'description': 'Descripción del evento 2',
        'image':
            'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg',
        'location': 'Ciudad, País',
        'date': DateTime.now(),
        'userId': '2',
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
                              onPressUser: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileDetailsView(
                                      userId: event['userId'], 
                                    ),
                                  ),
                                );
                              },
                              onComment: (eventId, comment) async {
                                debugPrint(eventId);
                                debugPrint(comment);
                              },                              
                              onMoreDetails: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventDetailsView(
                                      eventId: event['id'], 
                                      canEdit: false,
                                    ),
                                  ),
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
