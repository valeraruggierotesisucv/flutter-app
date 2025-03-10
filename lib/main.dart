import 'package:eventify/data/repositories/comment_repository.dart';
import 'package:eventify/data/repositories/category_repository.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/follow_user_repository.dart';
import 'package:eventify/data/repositories/notification_repository.dart';
import 'package:eventify/data/repositories/location_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/models/locale.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/providers/notification_provider.dart';
import 'package:eventify/services/auth_gate.dart';
import 'package:eventify/view_models/edit_event_view_model.dart';
import 'package:eventify/services/push_notifications.dart';
import 'package:eventify/view_models/edit_profile_view_model.dart';
import 'package:eventify/view_models/followed_view_model.dart';
import 'package:eventify/view_models/followers_view_model.dart';
import 'package:eventify/view_models/profile_details_view_model.dart';
import 'package:eventify/view_models/profile_view_model.dart';
import 'package:eventify/view_models/auth_view_model.dart';
import 'package:eventify/view_models/search_view_model.dart';
import 'package:eventify/views/auth_view.dart';
import 'package:eventify/views/onboarding_view.dart';
import 'package:eventify/views/forgot_password_view.dart';
import 'package:eventify/views/forgot_password_login_view.dart';
import 'package:eventify/views/success_view.dart';
import 'package:eventify/views/profile_details_view.dart';
import 'package:eventify/views/followers_view.dart';
import 'package:eventify/views/followed_view.dart';
import 'package:eventify/views/edit_profile_view.dart';
import 'package:eventify/views/edit_event_view.dart';
import 'package:eventify/views/configuration_view.dart';
import 'package:eventify/views/change_password_view.dart';
import 'package:eventify/views/search_view.dart';
import 'package:eventify/views/profile_view.dart';
import 'package:eventify/navigation.dart';
import 'package:eventify/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/view_models/profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      url: dotenv.env['SUPABASE_URL']!);

  final apiClient = ApiClient(
    baseUrl: dotenv.env['API_URL']!,
  );

  try {
    await Firebase.initializeApp();
    await FirebaseApi().initNotifications(); 
    debugPrint("Firebase inicializado correctamente.");
  } catch (e) {
    debugPrint("Error al inicializar Firebase: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleModel(),
      child: MultiProvider(
        providers: [
          Provider.value(value: apiClient),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider(NotificationRepository(apiClient))) 
        ],
        child: const MyApp(),
      ),
    ),
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
            '/${AppScreens.auth.name}': (context) => AuthView(
                viewModel: AuthViewModel(
                    context: context,
                    userRepository: UserRepository(
                        Provider.of<ApiClient>(context, listen: false)))),
            '/${AppScreens.onboarding.name}': (context) =>
                const OnboardingView(),
            '/${AppScreens.forgotPassword.name}': (context) =>
                const ForgotPasswordView(),
            '/${AppScreens.forgotPasswordLogin.name}': (context) =>
                const ForgotPasswordLoginView(),
            '/${AppScreens.success.name}': (context) => const SuccessView(),
            '/${AppScreens.profileDetails.name}': (context) =>
                ProfileDetailsView(
                  userId: '',
                  viewModel: ProfileDetailsViewModel(
                    context: context,
                    userRepository: UserRepository(
                        Provider.of<ApiClient>(context, listen: false)),
                    eventRepository: EventRepository(
                        Provider.of<ApiClient>(context, listen: false)),
                    followUserRepository: FollowUserRepository(
                        Provider.of<ApiClient>(context, listen: false)),
                    notificationRepository: NotificationRepository(
                      Provider.of<ApiClient>(context, listen: false)),
                    
                  ),
                ),
            '/${AppScreens.followers.name}': (context) => FollowersView(
                userId: '',
                viewModel: FollowersViewModel(
                    context: context,
                    notificationRepository: NotificationRepository(
                      Provider.of<ApiClient>(context, listen: false)
                    ),
                    followUserRepository: FollowUserRepository(
                        Provider.of<ApiClient>(context, listen: false)))),
            '/${AppScreens.followed.name}': (context) => FollowedView(
                userId: '',
                viewModel: FollowedViewModel(
                    context: context,
                    followUserRepository: FollowUserRepository(
                        Provider.of<ApiClient>(context, listen: false)))),
            '/${AppScreens.editProfile.name}': (context) => EditProfileView(
                  viewModel: EditProfileViewModel(
                    context: context,
                    userRepository: UserRepository(
                        Provider.of<ApiClient>(context, listen: false)),
                  ),
                ),
            '/${AppScreens.editEvent.name}': (context) => EditEventView(
              viewModel: EditViewModel(
                context: context,
                eventId: '',
                eventRepository: EventRepository(
                    Provider.of<ApiClient>(context, listen: false)),
                locationRepository: LocationRepository(
                    Provider.of<ApiClient>(context, listen: false)),
              ),
            ),
            '/${AppScreens.configuration.name}': (context) =>
                const ConfigurationView(),
            '/${AppScreens.changePassword.name}': (context) =>
                const ChangePasswordView(),

            // AppTabs routes
            '/${AppTabs.home.name}': (context) => const MainView(),
            '/${AppTabs.search.name}': (context) => SearchView(
                viewModel: SearchViewModel(
                  context: context,
                  userRepository: UserRepository(
                      Provider.of<ApiClient>(context, listen: false)),
                  eventRepository: EventRepository(
                      Provider.of<ApiClient>(context, listen: false)),
                  commentRepository: CommentRepository(
                      Provider.of<ApiClient>(context, listen: false)),
                  categoryRepository: CategoryRepository(
                      Provider.of<ApiClient>(context, listen: false)),
                  notificationRepository: NotificationRepository(
                      Provider.of<ApiClient>(context, listen: false),)
                      ), 
            ),
            // '/${AppTabs.add.name}': (context) => const AddView(),
            // '/${AppTabs.notifications.name}': (context) =>
            // const NotificationsView(),
            '/${AppTabs.profile.name}': (context) => ProfileView(
                viewModel: ProfileViewModel(
                    context: context,
                    userRepository: UserRepository(
                        Provider.of<ApiClient>(context, listen: false)),
                    eventRepository: EventRepository(
                        Provider.of<ApiClient>(context, listen: false)))),
          },
        ),
      ),
    );
  }
}
