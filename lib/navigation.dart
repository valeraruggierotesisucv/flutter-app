import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:eventify/views/add_view.dart';
import 'package:eventify/views/search_view.dart';
import 'package:eventify/views/notifications_view.dart';
import 'package:eventify/views/profile_view.dart';
import 'package:eventify/views/home_view.dart';
import 'package:provider/provider.dart';

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
          eventRepository: EventRepository(
            Provider.of<ApiClient>(context, listen: false),
          ),
        ),
      ),
    ),
    const SearchView(),
    const AddView(),
    const NotificationsView(),
    const ProfileView(),
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