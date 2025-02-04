import 'package:eventify/models/locale.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/services/auth_gate.dart';
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
import 'package:eventify/navigation.dart';
import 'package:eventify/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:eventify/models/locale.dart';

void main() async {
  // supabase setup
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      url: dotenv.env['SUPABASE_URL']!
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(), 
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleModel(),
      child: Consumer<LocaleModel>(
        builder: (context, localeModel, child) => MaterialApp(
          title: 'Eventify',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
          ],
          locale: localeModel.locale,
          home: const AuthGate(),
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
        ),
      ),
    );
  }
}


