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

  Future<void> sendPushNotification(
      String token, String title, String body) async {
    final url =
        'https://api-production-37c6.up.railway.app/api/push-notifications/$token';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'body': body,
      }),
    );
    debugPrint("token-->$fCMToken");
    if (response.statusCode == 200) {
      debugPrint("Notificación enviada correctamente.");
    } else {
      debugPrint("Error al enviar la notificación: ${response.body}");
    }
  }

  Future<String> initNotifications() async {
    try {
      await _firebaseMesagging.requestPermission();
      String? fCMToken = await _firebaseMesagging.getToken();
      
      if (fCMToken != null) {
        debugPrint("Token de notificación: $fCMToken");
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

