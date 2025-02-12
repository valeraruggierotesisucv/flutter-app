import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint("Title: ${message.notification?.title}");
  debugPrint("Body: ${message.notification?.body}");
  debugPrint("Payload: ${message.data}");
}

class FirebaseApi {
  final _firebaseMesagging = FirebaseMessaging.instance;
  String? fCMToken;

  void setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📲 [Foreground] Notificación recibida!");
      debugPrint("🎯 Title: ${message.notification?.title}");
      debugPrint("📝 Body: ${message.notification?.body}");
      debugPrint("📦 Payload: ${message.data}");

      // Aquí podrías mostrar una notificación local con flutter_local_notifications
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("🚀 [onMessageOpenedApp] La notificación fue tocada!");
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<String> initNotifications() async {
    try {
      await _firebaseMesagging.requestPermission();
      String? fCMToken = await _firebaseMesagging.getToken();

      if (fCMToken != null) {
        debugPrint("Token de notificación: $fCMToken");
        setupFirebaseListeners();
        FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
        return fCMToken;
      } else {
        throw Exception("No se pudo obtener el token de notificación.");
      }
    } catch (e) {
      debugPrint("Error al inicializar las notificaciones: $e");
      throw Exception("Error al inicializar las notificaciones: $e");
    }
  }

  Future<String> getFirebaseToken() async {
    try {
      String? fCMToken = await _firebaseMesagging.getToken();

      if (fCMToken != null) {
        debugPrint("Token de notificación: $fCMToken");
        return fCMToken;
      } else {
        throw Exception("No se pudo obtener el token de notificación.");
      }
    } catch (e) {
      debugPrint("Error al inicializar las notificaciones: $e");
      throw Exception("Error al inicializar las notificaciones: $e");
    }
  }
}
