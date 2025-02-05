import 'package:flutter/material.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/profile_card.dart';
import 'package:eventify/widgets/event_thumbnail_list.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => const ProfileHomeScreen(),
        );
      },
    );
  }
}

class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({super.key});

  @override
  State createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  final authService = AuthService();
  // Lista de eventos de ejemplo
  List<Event> sampleEvents = [
    Event(id: '1', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '2', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '3', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '4', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '5', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '1', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '2', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '3', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '4', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '5', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '2', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '3', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '4', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
    Event(id: '5', imageUrl: 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg'),
  ];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(),
      backgroundColor: Colors.white,
      body: 
        Column(
          children: [
            ProfileCard(
              username: "John Doe",
              biography: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              events: 0,
              followers: 0,
              following: 0,
              onFollowers: () {
                // Navegar a la pantalla de seguidores
              },
              onFollowed: () {
                // Navegar a la pantalla de seguidos
              },
              onConfigureProfile: () {
                // Navegar a la configuración del perfil
              },
              onEditProfile: () {
                // Navegar a la edición del perfil
              },
            ),
            Expanded( 
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 400, 
                  child: EventThumbnailList(
                    events: sampleEvents,
                    onEventTap: (String eventId) {
                      debugPrint("Evento tapped: $eventId");
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
