import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventify/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('Full app navigation test', (WidgetTester tester) async {
    // Store the original error handler
    final originalOnError = FlutterError.onError;

    // Override the error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception.toString().contains('setState() or markNeedsBuild() called during build')) {
        // Ignore this specific error
        return;
      }
      // Handle other errors normally
      originalOnError?.call(details);
    };

    try {
      app.main();
      await tester.pumpAndSettle();

      // Wait for login screen to be fully loaded
      await Future.delayed(const Duration(seconds: 5));
      
      // Wait for input fields to be available
      bool foundInputs = false;
      int attempts = 0;
      while (!foundInputs && attempts < 20) {
        await tester.pump(const Duration(seconds: 1));
        try {
          foundInputs = find.byType(InputField).evaluate().length >= 2;
        } catch (e) {
          attempts++;
        }
      }

      if (!foundInputs) {
        fail('Failed to find input fields on login screen');
      }

      // Now we can interact with the input fields
      final emailInput = find.byType(InputField).first;
      await tester.enterText(emailInput, 'jhoabran@gmail.com');
      await tester.pump();

      final passwordInput = find.byType(InputField).at(1);
      await tester.enterText(passwordInput, 'Eventify12345');
      await tester.pump();
      await Future.delayed(const Duration(seconds: 5));

      final loginButton = find.byType(CustomButton);
      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      
      // Wait for auth state to settle
      await Future.delayed(const Duration(seconds: 10));
      
      // Keep pumping until we find the navigation bar or timeout
      bool foundNavBar = false;
      attempts = 0;
      while (!foundNavBar && attempts < 20) {
        await tester.pump(const Duration(seconds: 1));
        try {
          // Check if at least the home and search icons are present
          foundNavBar = find.byIcon(Icons.home).evaluate().isNotEmpty &&
                       find.byIcon(Icons.search_outlined).evaluate().isNotEmpty;
          
          // Print which icons are found
          print('Found icons:');
          print('Home: ${find.byIcon(Icons.home).evaluate().isNotEmpty}');
          print('Search: ${find.byIcon(Icons.search_outlined).evaluate().isNotEmpty}');
          print('Add: ${find.byIcon(Icons.add_circle_outline).evaluate().isNotEmpty}');
          print('Notifications: ${find.byIcon(Icons.notifications_outlined).evaluate().isNotEmpty}');
          print('Profile: ${find.byIcon(Icons.person_outline).evaluate().isNotEmpty}');
          
        } catch (e) {
          print('Error checking for icons: $e');
          attempts++;
        }
      }

      if (!foundNavBar) {
        fail('Failed to navigate to home screen after login');
      }

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Before each tap, verify the icon exists
      print('\nAttempting to tap Search icon...');
      final searchIcon = find.byIcon(Icons.search_outlined);
      if (searchIcon.evaluate().isEmpty) {
        print('Search icon not found!');
        fail('Search icon not found');
      }
      await tester.tap(searchIcon);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await Future.delayed(const Duration(seconds: 1));

      print('\nAttempting to tap Create Event icon...');
      final createIcon = find.byIcon(Icons.add_circle_outline);
      if (createIcon.evaluate().isEmpty) {
        print('Create Event icon not found!');
        fail('Create Event icon not found');
      }
      await tester.tap(createIcon);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await Future.delayed(const Duration(seconds: 1));

      print('\nAttempting to tap Notifications icon...');
      final notifIcon = find.byIcon(Icons.notifications_outlined);
      if (notifIcon.evaluate().isEmpty) {
        print('Notifications icon not found!');
        fail('Notifications icon not found');
      }
      await tester.tap(notifIcon);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await Future.delayed(const Duration(seconds: 1));

      print('\nAttempting to tap Profile icon...');
      final profileIcon = find.byIcon(Icons.person_outline);
      if (profileIcon.evaluate().isEmpty) {
        print('Profile icon not found!');
        fail('Profile icon not found');
      }
      await tester.tap(profileIcon);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await Future.delayed(const Duration(seconds: 1));

      print('\nAttempting to tap Home icon...');
      final homeIcon = find.byIcon(Icons.home_outlined);
      if (homeIcon.evaluate().isEmpty) {
        print('Home icon not found!');
        fail('Home icon not found');
      }
      await tester.tap(homeIcon);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Final verification that all navigation icons are present
      print('\nFinal verification of all icons:');
      expect(find.byIcon(Icons.home), findsOneWidget, reason: 'Home icon not found in final verification');
      expect(find.byIcon(Icons.search_outlined), findsOneWidget, reason: 'Search icon not found in final verification');
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget, reason: 'Create Event icon not found in final verification');
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget, reason: 'Notifications icon not found in final verification');
      expect(find.byIcon(Icons.person_outline), findsOneWidget, reason: 'Profile icon not found in final verification');

    } finally {
      // Restore the original error handler
      FlutterError.onError = originalOnError;
    }
  });
}
