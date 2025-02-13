import 'package:eventify/data/repositories/comment_repository.dart';
import 'package:eventify/data/repositories/category_repository.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/view_models/add_event_view_model.dart';
import 'package:eventify/view_models/home_view_model.dart';
import 'package:eventify/view_models/profile_view_model.dart';
import 'package:eventify/view_models/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:eventify/views/add_event_view.dart';
import 'package:eventify/views/search_view.dart';
import 'package:eventify/views/notifications_view.dart';
import 'package:eventify/views/profile_view.dart';
import 'package:eventify/views/home_view.dart';
import 'package:provider/provider.dart';
import 'package:eventify/view_models/notifications_view_model.dart';
import 'package:eventify/data/repositories/notification_repository.dart';
import 'package:eventify/data/repositories/location_repository.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    Builder(
      builder: (context) => HomeView(
        viewModel: HomeViewModel(
          context: context,
          userRepository: UserRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
          eventRepository: EventRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
          commentRepository: CommentRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
          notificationRepository: NotificationRepository(
            Provider.of<ApiClient>(context, listen: false),
          )
        ),
      ),
    ),
    Builder(
      builder: (context) => SearchView(
        viewModel: SearchViewModel(
          context: context,
          userRepository: UserRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
          eventRepository: EventRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
          commentRepository: CommentRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
          categoryRepository: CategoryRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
           notificationRepository: NotificationRepository(
            Provider.of<ApiClient>(context, listen: false),
          )
        ),
      ),
    ),
    Builder(
      builder: (context) => AddView(
        viewModel: AddViewModel(
          context: context,
          eventRepository: EventRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
          locationRepository: LocationRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
        ),
      ),
    ),
     Builder(
      builder: (context) => NotificationsView(
        viewModel: NotificationsViewModel(
          context: context,
          notificationRepository: NotificationRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
        ),
      ),
    ),
    Builder(
      builder: (context) => ProfileView(
        viewModel: ProfileViewModel(
          context: context,
          userRepository: UserRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
          eventRepository: EventRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
        ),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}