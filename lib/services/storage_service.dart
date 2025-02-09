import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum FileType {
  image,
  audio
}

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> uploadFile(String filePath, FileType type) async {
    try {
      final String bucketName = type == FileType.image ? 'EventImages' : 'EventMusic';
      
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}';
      final file = File(filePath);

      await _supabase
          .storage
          .from(bucketName)
          .upload(fileName, file);

      final String fileUrl = _supabase
          .storage
          .from(bucketName)
          .getPublicUrl(fileName);

      debugPrint("url-->$fileUrl");
      return fileUrl;
    } catch (e) {
      debugPrint('Error uploading ${type.name}: $e');
      return null;
    }
  }
}
