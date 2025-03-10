// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'package:eventify/models/comment_model.dart';
import 'package:eventify/models/category_model.dart';
import 'package:eventify/models/event_summary_model.dart';
import 'package:eventify/models/follow_user_model.dart';
import 'package:eventify/models/notification_model.dart';
import 'package:eventify/models/social_interactions.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/utils/notification_types.dart';
import 'package:eventify/utils/result.dart';
import 'package:eventify/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eventify/models/location_model.dart';
import 'package:http/http.dart' as http;

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
          final user = element['user'] as Map<String, dynamic>;
          final location = element['location'] as Map<String, dynamic>;
          bool isLiked = false;
          if (element['socialInteractions'] != null) {
            final socialInteractions = element['socialInteractions'] as List<dynamic>;
            if (socialInteractions.isNotEmpty) {
              isLiked = (socialInteractions[0] as Map<String, dynamic>)['isActive'] ?? false;
            }
          }
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
            'is_liked': isLiked,
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

  Future<Result<List<EventModel>>> searchEvents(
      String query, String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/search/events');
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({'search': query, 'userId': userId}));

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as List<dynamic>;
        return Result.ok(jsonData.map((element) {
          final user = element['user'] as Map<String, dynamic>;
          final location = element['location'] as Map<String, dynamic>;
          
          bool isLiked = false;
          if (element['socialInteractions'] != null) {
            final socialInteractions = element['socialInteractions'] as List<dynamic>;
            print(socialInteractions);
            if (socialInteractions.isNotEmpty) {
              isLiked = (socialInteractions[0] as Map<String, dynamic>)['isActive'] ?? false;
            }
          }
          
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
            'is_liked': isLiked,
          });
        }).toList());
      } else {
        return Result.error(
            HttpException("Failed to search events: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<List<UserModel>>> searchUsers(String query) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/search/users');
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({'search': query}));

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;

        final jsonData = jsonResponse['data'] as List<dynamic>;

        return Result.ok(jsonData.map((element) {
          print("ELEMENT");
          print(element);

          return UserModel.fromJson({
            'userId': element['userId'],
            'username': element['username'],
            'fullname': "test",
            'email': "test",
            'profileImage': element['profileImage'],
            'birthDate': DateTime.now(),
            'biography': "test",
            'followersCounter': 0,
            'followingCounter': 0,
            'eventsCounter': 0,
          });
        }).toList());
      } else {
        return Result.error(
            HttpException("Failed to search events: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> createEvent({
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
        'eventImage': eventImage,
        'categoryId': categoryId,
        'locationId': locationId,
        'title': title,
        'description': description,
        'date': date.toUtc().toIso8601String(),
        'startsAt': startsAt.toUtc().toIso8601String(),
        'endsAt': endsAt.toUtc().toIso8601String(),
        'eventMusic': eventMusic,
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
        return Result.ok(null);
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

  Future<Result<List<NotificationModel>>> getNotifications(
      String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId/notifications');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as List<dynamic>;
        debugPrint(" notifications data $jsonData");
        return Result.ok(
            jsonData.map((item) => NotificationModel.fromJson(item)).toList());
      } else {
        return Result.error(HttpException(
            "Failed to load notifications: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> registerUser(UserModel user) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/signUp');
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;

      final body = {
        'userId': user.userId,
        'username': user.username,
        'fullName': user.fullname,
        'email': user.email,
        'birthDate': user.birthDate.toIso8601String(),
      };

      request.write(jsonEncode(body));
      final response = await request.close();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result.ok(null);
      } else {
        return Result.error(
            HttpException("Failed to register user: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<EventModel>> getEventDetails(String eventId, String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/events/$eventId/$userId');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as Map<String, dynamic>;
        print("jsonData $jsonData");
        
        bool isLiked = false;
          if (jsonData['socialInteractions'] != null) {
            final socialInteractions = jsonData['socialInteractions'] as List<dynamic>;
            if (socialInteractions.isNotEmpty) {
              isLiked = (socialInteractions[0] as Map<String, dynamic>)['isActive'] ?? false;
            }
          }
        return Result.ok(EventModel.fromJson({
          'event_id': jsonData['eventId'],
          'user_id': jsonData['userId'],
          'username': jsonData['user']['username'],
          'profile_image': jsonData['user']['profileImage'],
          'event_image': jsonData['eventImage'],
          'title': jsonData['title'],
          'description': jsonData['description'],
          'location_id': jsonData['location']['locationId'],
          'latitude': jsonData['location']['latitude'].toString(),
          'longitude': jsonData['location']['longitude'].toString(),
          'starts_at': jsonData['startsAt'],
          'ends_at': jsonData['endsAt'],
          'date': jsonData['date'],
          'category': jsonData['category']['nameEs'],
          'category_id': jsonData['categoryId'].toString(),
          'music_url': jsonData['eventMusic'],
          'is_liked': isLiked,
        }));
      } else {
        return Result.error(HttpException("Failed to get event details: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<UserModel>> getUser(String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);

      final response = await request.close();

      if(response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson({
          'userId': jsonData['userId'],
          'username': jsonData['username'],
          'fullname': jsonData['fullName'],
          'email': jsonData['email'],
          'profileImage': jsonData['profileImage'],
          'birthDate': DateTime.parse(jsonData['birthDate']),
          'biography': jsonData['biography'] ?? "",
          'followersCounter': jsonData['followers_counter'],
          'followingCounter': jsonData['following_counter'],
          'eventsCounter': 0,
        });
        return Result.ok(user);
      } else {
        return Result.error(HttpException("Failed to get user: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }  

  Future<Result<List<EventSummaryModel>>> getUserEvents(String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId/events');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);

      final response = await request.close();

      if(response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as List<dynamic>;
        return Result.ok(jsonData.map((element) => EventSummaryModel.fromJson({
          'eventId': element['eventId'],
          'imageUrl': element['eventImage'],
        })).toList());
      } else {
        return Result.error(HttpException("Failed to get user events: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<UserModel>> updateProfile(UserModel user) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/users/${user.userId}');
      final request = await client.putUrl(uri);
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;

      final body = {
        'fullName': user.fullname,
        if (user.profileImage != null) 'profileImage': user.profileImage,
        if (user.biography != null) 'biography': user.biography,
      };
      print("body $body");
      print(user.userId);
      request.write(jsonEncode(body));
      final response = await request.close();
      
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as Map<String, dynamic>;
        print("API updated profile: $jsonData");
        return Result.ok(UserModel.fromJson({
          'userId': jsonData['userId'],
          'username': jsonData['username'],
          'fullname': jsonData['fullName'],
          'email': jsonData['email'],
          'profileImage': jsonData['profileImage'],
          'birthDate': DateTime.parse(jsonData['birthDate']),
          'biography': jsonData['biography'],
          'followersCounter': jsonData['followers_counter'],
          'followingCounter': jsonData['following_counter'],
        }));
      } else {
        return Result.error(HttpException("Failed to update profile: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<List<CategoryModel>>> getCategories() async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/categories');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);

      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as List<dynamic>;
        
        return Result.ok(jsonData.map((element) => CategoryModel.fromJson({
          'id': element['categoryId'],
          'name_es': element['nameEs'],
          'name_en': element['nameEn'],
          'description': element['description'],
        })).toList());
        
      } else {
        return Result.error(HttpException("Failed to get categories: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
  Future<Result<List<CommentModel>>> getComments(String eventId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/comments/events/$eventId');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);

      final response = await request.close();

      if(response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as List<dynamic>;
        
        return Result.ok(jsonData.map((element) {
          final user = element['user'] as Map<String, dynamic>;

          return CommentModel.fromJson({
            'username': user['username'],
            'comment': element['text'],
            'profileImage': user['profileImage'],
            'timestamp': DateTime.parse(element['createdAt']),
          });
        }).toList());  
      } else {
        return Result.error(HttpException("Failed to get comments: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> submitComment(String eventId, String userId, CommentModel comment) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/events/$eventId/comment');
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;

      final body = {
        'userId': userId,
        'text': comment.comment,
      };

      request.write(jsonEncode(body));
      final response = await request.close();

      if (response.statusCode == 200) {
        return Result.ok(null);
      } else {
        return Result.error(HttpException("Failed to submit comment: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

    Future<Result<void>> sendNotification(
      String toNotificationToken, Map<String, dynamic> data) async {
    final client = _clientFactory();

    try {
      final uri =
          Uri.parse('$_baseUrl/push-notifications/$toNotificationToken');
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;

      final body = {'title': data['title'], 'body': data['body']};
      request.write(jsonEncode(body));
      final response = await request.close();
      debugPrint("-->$uri");
      debugPrint("sending notification to $toNotificationToken, $body");
      if (response.statusCode != 200) {
        debugPrint("ERROR ENVIANDO LA NOTIFICACION");
        return Result.error(
            Exception('Failed to send notification: ${response.statusCode}'));
      } else {
        debugPrint("Notificaion enviada");
        return Result.ok(null);
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<String?> getNotificationToken(String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId/push-notification');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);
      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;

        if (jsonResponse['success'] == true) {
          return jsonResponse['data']; // Devuelve directamente el token FCM
        } else {
          throw Exception(
              'Failed to fetch notification token: ${jsonResponse['error']}');
        }
      } else {
        throw Exception(
            'Failed to fetch notification token: ${response.statusCode}');
      }
    } finally {
      client.close();
    }
  }

  Future<Result<void>> updateNotificationToken(
      String userId, String notificationToken) async {
    final client = _clientFactory();

    try {
      final uri =
          Uri.parse('$_baseUrl/users/$userId/notifications/$notificationToken');
      final request = await client.putUrl(uri);
      debugPrint("uri-->$uri");
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;
      final response = await request.close();

      if (response.statusCode != 200) {
        debugPrint(
            'Failed to update notification token: ${response.statusCode}');
        return Result.error(Exception(
            'Failed to update notification token: ${response.statusCode}'));
      } else {
        debugPrint("Token actualizado");
        return Result.ok(null);
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<FollowUserModel>> isFollowing(String userId, String targetUserId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId/isFollowing/$targetUserId');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);

      final response = await request.close();
      
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'];  // This can be null
        bool isActive = false;
        if (jsonData != null) {
          isActive = (jsonData as Map<String, dynamic>)['isActive'];
        }

        return Result.ok(FollowUserModel.fromJson({
          'isActive': isActive,
          'userIdFollows': userId,
          'userIdFollowedBy': targetUserId,
          'createdAt': DateTime.now(),
        }));
      } else {
        return Result.error(HttpException("Failed to check if following: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> createNotification(
      NotificationModel notificationData) async {
    final client = _clientFactory();

    try {
      final uri = Uri.parse('$_baseUrl/notifications');
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;
      debugPrint("type ${notificationData.type}");

      String type; 
      switch (notificationData.type) {
        case NotificationType.likeEvent:
          type = "LIKE";
          break;
        case NotificationType.follow:
          type = "FOLLOW";
          break;
        case NotificationType.commentEvent:
          type = "COMMENT";
          break;
        default:
          type = "UNKNOWN"; // Valor por defecto en caso de error
      }

      final body = {
        "fromUserId": notificationData.fromUserId,
        "toUserId": notificationData.toUserId,
        "type": type,
        "message": notificationData.message,
        "eventImage": notificationData.eventImage
      };

      request.write(jsonEncode(body));
      final response = await request.close();
      debugPrint("$uri->$body");

      if (response.statusCode != 200) {
        debugPrint("Error creando la notificacion");
        return Result.error(
            Exception('Failed to send notification: ${response.statusCode}'));
      } else {
        debugPrint("Notificaion creada");
        return Result.ok(null);
      }
    } on Exception catch (error) {
      debugPrint("Error $error");
      return Result.error(error);
    } finally {
      client.close();
    }
  }

Future<Result<void>> followUser(String targetUserId, String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId/follow/$targetUserId');
      final request = await client.postUrl(uri);
      await _authHeader(request.headers);
  
      final response = await request.close();
      print("response $response");
      print("response.statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
      
        if (jsonResponse['success'] == true) {
          return Result.ok(null);
        } else {
          return Result.error(HttpException("Failed to follow user: ${response.statusCode}"));
        }
      } else {
        return Result.error(HttpException("Failed to follow user: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close(); 
    }
  }



  Future<Result<void>> unfollowUser(String targetUserId, String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId/unfollow/$targetUserId');
      final request = await client.deleteUrl(uri);
      await _authHeader(request.headers);
  
      final response = await request.close();
      print("response $response");
      print("response.statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        
        
        if (jsonResponse['success'] == true) {
          return Result.ok(null);
        } else {
          return Result.error(HttpException("Failed to unfollow user: ${response.statusCode}"));
        }
      } else {
        return Result.error(HttpException("Failed to unfollow user: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<List<FollowUserModel>>> getFollowed(String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId/followed');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);

      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as List<dynamic>;
        return Result.ok(jsonData.map((element) => FollowUserModel.fromJson({
          'userIdFollows': userId,
          'userIdFollowedBy': element['followedId'],
          'createdAt': DateTime.now(),
          'isActive': element['followed'],
          'followedName': element['followedName'],
          'followedProfileImage': element['followedProfileImage'],
        })).toList());
      } else {
        return Result.error(HttpException("Failed to get followed: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<List<FollowUserModel>>> getFollowers(String userId) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId/followers');
      final request = await client.getUrl(uri);
      await _authHeader(request.headers);

      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData) as Map<String, dynamic>;
        final jsonData = jsonResponse['data'] as List<dynamic>;
        return Result.ok(jsonData.map((element) => FollowUserModel.fromJson({
          'userIdFollows': element['followerId'],
          'userIdFollowedBy': userId,
          'createdAt': DateTime.now(),
          'isActive': element['followed'],
          'followerName': element['followerName'],
          'followerProfileImage': element['followerProfileImage'],
        })).toList());
      } else {
        return Result.error(HttpException("Failed to get followers: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
  Future<Result<void>> updateEvent(String eventId, EventModel event) async {
    final client = _clientFactory();
    try {
      final uri = Uri.parse('$_baseUrl/events/$eventId');
      final request = await client.putUrl(uri);
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;
      print("event ${event.date} ${event.startsAt} ${event.endsAt}");
      final body = {
        'userId': event.userId,
        'title': event.title,
        'description': event.description,
        'date': event.date,
        'startsAt': event.startsAt,
        'endsAt': event.endsAt,
        'eventImage': event.eventImage,
        'eventMusic': event.musicUrl,
        'categoryId': int.parse(event.categoryId),
        'latitude': event.latitude,
        'longitude': event.longitude,
        'locationId': event.locationId,
      };

      request.write(jsonEncode(body));
      final response = await request.close();

      if (response.statusCode == 200) {
        return Result.ok(null);
      } else {
        return Result.error(HttpException("Failed to update event: ${response.statusCode}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
}