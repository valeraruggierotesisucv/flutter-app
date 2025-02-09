import 'package:eventify/models/supabase_user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart'; // Importamos Provider

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Sign in
  // Iniciar sesión con email y contraseña
  Future<void> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    
    if (response.user != null) {
      // Crear un modelo de usuario
      final user = SupabaseUserModel(
        id: response.user!.id, 
        email: response.user!.email!,
        accessToken: response.session!.accessToken
      );

      // Verificar si el widget está montado antes de acceder al contexto
      if (!context.mounted) return;

      // Actualizar el estado del usuario usando el UserProvider
      Provider.of<UserProvider>(context, listen: false).setUser(user);
    }
  }

  // Sign Up
  Future<void> signUpWithEmailPassword(
      String email, String password, BuildContext context) async {
    final response = await _supabaseClient.auth.signUp(email: email, password: password);

    if (response.user != null) {
      // Crear un modelo de usuario
      final user = SupabaseUserModel(
        id: response.user!.id, 
        email: response.user!.email!,
        accessToken: response.session!.accessToken
      );

      // Verificar si el widget está montado antes de acceder al contexto
      if (!context.mounted) return;

      // Actualizar el estado del usuario usando el UserProvider
      Provider.of<UserProvider>(context, listen: false).setUser(user);
    }
  }

  // Sign Out
  Future<void> signOut(BuildContext context) async {
    await _supabaseClient.auth.signOut();
    // Verificar si el widget está montado antes de acceder al contexto
      if (!context.mounted) return;

    // Limpiar el estado del usuario
    Provider.of<UserProvider>(context, listen: false).clearUser();
  }

   // Obtener el usuario actual
  SupabaseUserModel? getCurrentUser(BuildContext context) {
    return Provider.of<UserProvider>(context, listen: false).user;
  }
}
