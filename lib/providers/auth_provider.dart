// user_provider.dart
import 'package:eventify/models/supabase_user_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  // Variable privada para almacenar la información del usuario
  SupabaseUserModel? _user;

  // Obtener el usuario actual
  SupabaseUserModel? get user => _user;

  // Establecer el usuario (se llama cuando el usuario inicia sesión)
  void setUser(SupabaseUserModel user) {
    _user = user;
    notifyListeners();  // Notifica a los widgets para que se actualicen
  }

  // Limpiar el usuario (cuando el usuario cierra sesión)
  void clearUser() {
    _user = null;
    notifyListeners();  // Notifica a los widgets para que se actualicen
  }
}
