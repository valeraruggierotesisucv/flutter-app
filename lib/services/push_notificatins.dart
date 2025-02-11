import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final _firebaseMesagging = FirebaseMessaging.instance;


  Future<void> initNotifications() async {
    try {
      await _firebaseMesagging.requestPermission();
      final fCMToken = await _firebaseMesagging.getToken();
      if (fCMToken != null) {
        debugPrint("token-->$fCMToken");
      } else {
        debugPrint("No se pudo obtener el token.");
      }
    } catch (e) {
      debugPrint("Error al inicializar las notificaciones: $e");
    }
  }
}
