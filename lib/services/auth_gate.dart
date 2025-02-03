/* This will constinuosly listen for auth changes */
import 'package:eventify/main.dart';
import 'package:eventify/views/auth_view.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // listen to auth state changes
        stream: Supabase.instance.client.auth.onAuthStateChange,

        // build the appropiate page based on auth state
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            // TO-DO: cambiar por Loading component 
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // check is there is a valid session cunrretly
          final session = snapshot.hasData ? snapshot.data?.session : null;

          if (session != null) {
            return MainView();
          } else {
            return AuthView(); 
          }
        });
  }
}
