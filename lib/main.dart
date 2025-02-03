import 'package:eventify/services/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:eventify/views/add_view.dart';
import 'package:eventify/views/auth_view.dart';
import 'package:eventify/views/onboarding_view.dart';
import 'package:eventify/views/forgot_password_view.dart';
import 'package:eventify/views/forgot_password_login_view.dart';
import 'package:eventify/views/success_view.dart';
import 'package:eventify/views/event_details_view.dart';
import 'package:eventify/views/profile_details_view.dart';
import 'package:eventify/views/folowers_view.dart';
import 'package:eventify/views/followed_view.dart';
import 'package:eventify/views/edit_profile_view.dart';
import 'package:eventify/views/edit_event_view.dart';
import 'package:eventify/views/configuration_view.dart';
import 'package:eventify/views/change_password_view.dart';
import 'package:eventify/views/search_view.dart';
import 'package:eventify/views/notifications_view.dart';
import 'package:eventify/views/profile_view.dart';
import 'package:eventify/views/home_view.dart';

import 'package:eventify/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // supabase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNybmFycHZwYWZieXd2ZHpmdWtwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU4NTgwNDAsImV4cCI6MjA1MTQzNDA0MH0.SThw_RVKOggwgR0OzUcA40y66ZIPO21wqJygsJQxk6I",
      url: "https://crnarpvpafbywvdzfukp.supabase.co"); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventify',
      home: AuthGate(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      routes: {
        // AppScreens routes
        '/${AppScreens.auth.name}': (context) => const AuthView(),
        '/${AppScreens.onboarding.name}': (context) => const OnboardingView(),
        '/${AppScreens.forgotPassword.name}': (context) =>
            const ForgotPasswordView(),
        '/${AppScreens.forgotPasswordLogin.name}': (context) =>
            const ForgotPasswordLoginView(),
        '/${AppScreens.success.name}': (context) => const SuccessView(),
        '/${AppScreens.eventDetails.name}': (context) =>
            const EventDetailsView(),
        '/${AppScreens.profileDetails.name}': (context) =>
            const ProfileDetailsView(),
        '/${AppScreens.folowers.name}': (context) => const FollowersView(),
        '/${AppScreens.folowed.name}': (context) => const FollowedView(),
        '/${AppScreens.editProfile.name}': (context) => const EditProfileView(),
        '/${AppScreens.editEvent.name}': (context) => const EditEventView(),
        '/${AppScreens.configuration.name}': (context) =>
            const ConfigurationView(),
        '/${AppScreens.changePassword.name}': (context) =>
            const ChangePasswordView(),

        // AppTabs routes
        '/${AppTabs.home.name}': (context) => const MainView(),
        '/${AppTabs.search.name}': (context) => const SearchView(),
        '/${AppTabs.add.name}': (context) => const AddView(),
        '/${AppTabs.notifications.name}': (context) =>
            const NotificationsView(),
        '/${AppTabs.profile.name}': (context) => const ProfileView(),
      },
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const HomeView(),
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
