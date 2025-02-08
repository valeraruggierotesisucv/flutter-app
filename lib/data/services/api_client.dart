// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'package:eventify/models/social_interactions.dart';
import 'package:eventify/utils/result.dart';
import 'package:eventify/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eventify/models/location_model.dart';

/// Adds the `Authentication` header to a header configuration.
typedef AuthHeaderProvider = String? Function();

class ApiClient {
  ApiClient({
    required String baseUrl,
    HttpClient Function()? clientFactory,
  })  : _baseUrl = baseUrl,
        _clientFactory = clientFactory ?? HttpClient.new;

  final String _baseUrl;
  final HttpClient Function() _clientFactory;

  Future<void> _authHeader(HttpHeaders headers) async {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;

    if (token != null) {
      headers.add(HttpHeaders.authorizationHeader, 'Bearer $token');
    }
  }

  Future<Result<List<EventModel>>> getEvents(String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/home/$userId/events');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as List<dynamic>;

        return Result.ok(jsonData.map((element) {
          // Transform nested data into flat structure
          final user = element['user'] as Map<String, dynamic>;
          final location = element['location'] as Map<String, dynamic>;
          print(element);
          return EventModel.fromJson({
            'event_id': element['eventId'],
            'user_id': element['userId'],
            'username': user['username'],
            'profile_image': user['profileImage'],
            'event_image': element['eventImage'],
            'title': element['title'],
            'description': element['description'],
            'location_id': element['locationId'],
            'latitude': location['latitude'].toString(),
            'longitude': location['longitude'].toString(),
            'starts_at': element['startsAt'],
            'ends_at': element['endsAt'],
            'date': element['date'],
            'category': element['category'] ?? '',
            'category_id': element['categoryId'].toString(),
            'music_url': element['eventMusic'],
            'is_liked': element['isLiked'] ?? false,
          });
        }).toList());
      } else {
        final errorBody = await response.transform(utf8.decoder).join();
        print('Error response: $errorBody');
        return Result.error(
            HttpException("Failed to load events: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      print('Error: $error');
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<SocialInteractions>> likeEvent(
      String eventId, String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/events/$eventId/like');
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({'userId': userId}));
      final response = await request.close();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as Map<String, dynamic>;

        return Result.ok(SocialInteractions.fromJson({
          'userId': jsonData['userId'],
          'eventId': jsonData['eventId'],
          'isActive': jsonData['isActive'],
          'createdAt': DateTime.parse(jsonData['createdAt']),
        }));
      } else {
        return Result.error(
            HttpException("Failed to like event: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> addComment(String eventId, String comment) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/events/$eventId/comments');
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({'content': comment}));

      final response = await request.close();
      if (response.statusCode == 201) {
        return const Result.ok(null);
      } else {
        return Result.error(
            HttpException("Failed to add comment: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<EventModel>> createEvent({
    required String userId,
    required String eventImage,
    required int categoryId,
    required String locationId,
    required String title,
    required String description,
    required DateTime date,
    required DateTime startsAt,
    required DateTime endsAt,
    String? eventMusic,
  }) async {
    final client = _clientFactory();
    debugPrint("[api_client]");
    try {
      final uri = Uri.parse('$_baseUrl/events');
      debugPrint(uri.toString());
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;

      final body = {
        'userId': userId,
        'eventImage': "https://crnarpvpafbywvdzfukp.supabase.co/storage/v1/object/public/EventImages/1738529176438",
        'categoryId': categoryId,
        'locationId': locationId,
        'title': title,
        'description': description,
        'date': date.toUtc().toIso8601String(),
        'startsAt': startsAt.toUtc().toIso8601String(),
        'endsAt': endsAt.toUtc().toIso8601String(),
        'eventMusic': "https://crnarpvpafbywvdzfukp.supabase.co/storage/v1/object/public/EventImages/1738529176438",
      };
      debugPrint("body $body"); 

      request.write(jsonEncode(body));
      final response = await request.close();
      debugPrint("result--->$response");

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as Map<String, dynamic>;
        debugPrint("API created event: $jsonData");
        return Result.ok(EventModel.fromJson(jsonData));
      } else {
        debugPrint("not ok--> Failed to create event: ${response.statusCode}");
        return Result.error(
            HttpException("Failed to create event: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<LocationModel>> createLocation({
    required String latitude,
    required String longitude,
  }) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/locations');
      debugPrint(uri.toString());
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;

      final body = {
        'latitude': double.parse(latitude),
        'longitude': double.parse(longitude),
      };

      request.write(jsonEncode(body));
      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as Map<String, dynamic>;
        debugPrint("[API LOCATION] $jsonData");
        return Result.ok(LocationModel.fromJson(jsonData));
      } else {
        debugPrint(
            "[API LOCATION] Failed to create location: ${response.statusCode}");
        return Result.error(
            HttpException("Failed to create location: ${response.statusCode}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      client.close();
    }
  }
}
