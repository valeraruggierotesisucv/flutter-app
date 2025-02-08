import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> uploadEventImage(String filePath) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}';
      final file = File(filePath);

      final response =
          await _supabase.storage.from('EventImages').upload(fileName, file);

      debugPrint("this is the response $response");
      // Obtener la URL pública de la imagen
      final String imageUrl =
          _supabase.storage.from('EventImages').getPublicUrl(fileName);

      debugPrint("url-->$imageUrl");
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
