import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:eventify/widgets/custom_search_bar.dart';
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

  void _handleSearch(String value) {
    setState(() {
      _searchValue = value;
    });
    debugPrint('Search value from main: $_searchValue');
  }

  void _handleCategoryPress(String category) {
    setState(() {
      _selectedCategory = category;
    });
    debugPrint('Category pressed: $_selectedCategory');
  }

  Future<void> onComment(String eventId, String comment) async {
    // Implementar lógica para manejar comentarios
    debugPrint('Nuevo comentario en evento $eventId: $comment');
  }

  Future<List<Comment>> fetchComments() async {
    // Simular obtención de comentarios
    return [
      Comment(
        username: "Usuario1",
        comment: "¡Gran evento!",
        profileImage: "https://avatars.githubusercontent.com/u/1",
        timestamp: DateTime.now(),
      ),
      Comment(
        username: "Usuario2",
        comment: "¡No puedo esperar!",
        profileImage: "https://avatars.githubusercontent.com/u/2",
        timestamp: DateTime.now(),
      ),
    ];
  }

  void handleLike() {
    debugPrint('Like presionado');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user; 
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          ProfileCard(
            username: user!.email,
            biography: 'ID --> ${user.id}, \n Access token ---> ${user.accessToken}',
            events: 10,
            followers: 150,
            following: 120,
            isFollowing: false,
            onFollow: () {
              debugPrint('Follow pressed');
            },
            onEditProfile: () {
              debugPrint('Edit profile pressed');
            },
            onEvents: () {
              debugPrint('Events pressed');
            },
            onFollowers: () {
              debugPrint('Followers pressed');
            },
            onFollowed: () {
              debugPrint('Following pressed');
            },
          ),
          const SizedBox(height: 20),
          CustomSearchBar(onSearch: _handleSearch),
          const SizedBox(height: 20),
          UserCard(
            username: 'John Doe',
            profileImage: 'https://avatars.githubusercontent.com/u/82007072',
            onPressUser: () {
              debugPrint('User pressed');
            },
            onPressButton: () {
              debugPrint('Button pressed');
            },
          ),
          const SizedBox(height: 20),
          CustomButton(
            label: 'Button',
            onPress: () {
              debugPrint('Button pressed');
            },
          ),
          const SizedBox(height: 20),
          CategoryButton(
            onPress: _handleCategoryPress,
            category: 'Category 1',
            icon: Icons.camera_alt,
          ),
          const SizedBox(height: 20),
          SocialInteractions(
            isLiked: false,
            onLike: () {
              debugPrint('Like pressed');
            },
            onComment: () {
              debugPrint('Comment pressed');
            },
            onShare: () {
              debugPrint('Share pressed');
            },
          ),
          const SizedBox(height: 20),
          CustomChip(
            label: 'Chip',
            onPress: () {
              debugPrint('Chip pressed');
            },
          ),
          const SizedBox(height: 20),
          EventCard(
            eventId: "1",
            profileImage: "https://avatars.githubusercontent.com/u/82007072",
            username: "John Doe",
            eventImage: "https://picsum.photos/800/600",
            title: "Evento de Programación Flutter",
            description:
                "Únete a nosotros para aprender sobre el desarrollo de aplicaciones móviles con Flutter. ¡Será una experiencia increíble!",
            isLiked: false,
            date: "10/02/2001",
            latitude: "19.4326",
            longitude: "-99.1332",
            startsAt: "10:00",
            endsAt: "18:00",
            category: "Tecnología",
            variant: EventCardVariant.defaultCard,
            userComment: {
              "username": "CurrentUser",
              "profileImage": "https://avatars.githubusercontent.com/u/3",
            },
            onPressUser: () {
              debugPrint('Usuario presionado');
            },
            onComment: onComment,
            onShare: () {
              debugPrint('Compartir presionado');
            },
            onMoreDetails: () {
              debugPrint('Ver más detalles presionado');
            },
            fetchComments: fetchComments,
            handleLike: handleLike,
          ),
          Tabs(
            tabs: [
              TabItem(id: 1, title: 'Tab 1'),
              TabItem(id: 2, title: 'Tab 2'),
              TabItem(id: 3, title: 'Tab 3'),
            ],
            onTabTap: (index) {
              debugPrint('Tab ${index} tapped');
            },
          ),
          InputField(
            label: 'Label',
            hint: 'Hint',
            controller: _controller,
            error: '',
            onChanged: (value) {
              debugPrint('Value changed: $value');
            },
            onIconTap: () {
              debugPrint('Icon tapped');
            },
            icon: Icons.calendar_today,
          ),
          Text('Current search: $_searchValue'),
        ],
      ),
    ));
  }
}
