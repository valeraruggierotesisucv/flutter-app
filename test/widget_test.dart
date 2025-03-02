// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:eventify/widgets/date_time_picker_field.dart';
import 'package:eventify/widgets/icon_logo.dart';
import 'package:eventify/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventify/views/auth_view.dart';
import 'package:eventify/view_models/auth_view_model.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:eventify/widgets/input_field.dart';
import 'package:eventify/widgets/custom_button.dart';

@GenerateNiceMocks([
  MockSpec<AuthViewModel>(),
  MockSpec<AuthService>(),
])
import 'widget_test.mocks.dart';

// Helper widget para proveer el contexto necesario para las pruebas
class TestApp extends StatelessWidget {
  final Widget child;
  final Locale locale;

  const TestApp({
    super.key, 
    required this.child,
    this.locale = const Locale('es'),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Localizations(
        locale: locale,
        delegates: AppLocalizations.localizationsDelegates,
        child: child,
      ),
    );
  }
}

void main() {
  late MockAuthViewModel mockViewModel;
  late MockAuthService mockAuthService;

  setUp(() {
    mockViewModel = MockAuthViewModel();
    mockAuthService = MockAuthService();
  });

  group('AuthView Tests', () {
    testWidgets('should show login form by default', (WidgetTester tester) async {
      final authView = AuthView(
        viewModel: mockViewModel,
        authService: mockAuthService,
      );

      await tester.pumpWidget(TestApp(child: authView));
      await tester.pumpAndSettle();

      expect(find.byType(InputField), findsNWidgets(2)); 
      expect(find.byType(TextButton), findsOneWidget); 
      expect(find.byType(CustomButton), findsOneWidget); 
      expect(find.byType(IconLogo), findsOneWidget); 
      expect(find.byType(Tabs), findsOneWidget);
    });

    testWidgets('should switch to signup form when signup tab is tapped', 
      (WidgetTester tester) async {
      final authView = AuthView(
        viewModel: mockViewModel,
        authService: mockAuthService,
      );

      await tester.pumpWidget(TestApp(child: authView));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Registrarse'));
      await tester.pumpAndSettle();
      expect(find.byType(InputField), findsNWidgets(5)); 
      expect(find.byType(DateTimePickerField), findsOneWidget); 
      expect(find.byType(CustomButton), findsOneWidget); 
    });

    testWidgets('should validate empty fields in signup form', 
      (WidgetTester tester) async {
      final authView = AuthView(
        viewModel: mockViewModel,
        authService: mockAuthService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: MediaQuery(
            data: const MediaQueryData(),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  height: 1200,
                  child: authView,
                ),
              ),
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      await tester.tap(find.text('Registrarse'));
      await tester.pumpAndSettle();

      final button = find.byType(CustomButton);
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      final inputFields = find.byType(InputField);
      expect(inputFields, findsNWidgets(5));

      for (int i = 0; i < 5; i++) {
        final InputField widget = tester.widget(inputFields.at(i));
        expect(widget.error!.isNotEmpty, true);
      }
    });

    testWidgets('should validate email format in signup form', 
      (WidgetTester tester) async {
      final authView = AuthView(
        viewModel: mockViewModel,
        authService: mockAuthService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: MediaQuery(
            data: const MediaQueryData(),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  height: 1200,
                  child: authView,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Registrarse'));
      await tester.pumpAndSettle();

      final emailInput = find.byType(InputField).at(2);
      await tester.enterText(find.descendant(
        of: emailInput,
        matching: find.byType(TextField),
      ), 'invalid-email');
      
      final button = find.byType(CustomButton);
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Ingrese un correo electrónico válido'), findsOneWidget);
    });

    testWidgets('should validate password match in signup form', 
      (WidgetTester tester) async {
      final authView = AuthView(
        viewModel: mockViewModel,
        authService: mockAuthService,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: MediaQuery(
            data: const MediaQueryData(),
            child: Material(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  height: 1200,
                  child: authView,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Registrarse'));
      await tester.pumpAndSettle();

      final passwordInput = find.byType(InputField).at(3);
      final confirmPasswordInput = find.byType(InputField).at(4);
      
      await tester.enterText(find.descendant(
        of: passwordInput,
        matching: find.byType(TextField),
      ), 'password123');
      
      await tester.enterText(find.descendant(
        of: confirmPasswordInput,
        matching: find.byType(TextField),
      ), 'password456');
      
      final button = find.byType(CustomButton);
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    });
  });
}
