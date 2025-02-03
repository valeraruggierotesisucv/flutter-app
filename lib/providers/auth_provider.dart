import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  Session? _session;
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get user => _user;
  Session? get session => _session;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Obtener sesión inicial
    final Session? session = _supabase.auth.currentSession;
    _session = session;
    _user = session?.user;

    // Escuchar cambios en el estado de autenticación
    _supabase.auth.onAuthStateChange.listen((data) {
      _session = data.session;
      _user = data.session?.user;
      notifyListeners();
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'username': username,
        },
      );

      if (response.user != null) {
        _user = response.user;
        _session = response.session;
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _user = response.user;
      _session = response.session;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _user = null;
    _session = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(
          password: password,
        ),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}