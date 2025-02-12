import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import '../data/repositories/notification_repository.dart';
import '../models/notification_model.dart';
import '../providers/auth_provider.dart';
import '../utils/result.dart';

class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel({
    required BuildContext context,
    required NotificationRepository notificationRepository,
  })  : _notificationRepository = notificationRepository,
        _context = context {
    loadNotifications();
  }

  final NotificationRepository _notificationRepository;
  final BuildContext _context;
  final _log = Logger('NotificationsViewModel');
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNotifications() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        _error = 'Usuario no autenticado';
        return;
      }
      debugPrint("Usuario-->$userId");

      final result = await _notificationRepository.getNotifications(userId);
      debugPrint("Resultado de notificaciones-->");

      switch (result) {
        case Ok<List<NotificationModel>>():
          _notifications = result.value;
          debugPrint("Notificaciones cargadas: ${_notifications.length}");
          for (var notification in _notifications) {
            debugPrint("""
              Notificación:
              - ID: ${notification.notificationId}
              - De: ${notification.username}
              - Avatar: ${notification.profileImage}
              - Tipo: ${notification.type}
              - Mensaje: ${notification.message}
              - Fecha: ${notification.createdAt}
              - EventImage: ${notification.eventImage}
              """);
          }
          _error = null;
        case Error<List<NotificationModel>>():
          debugPrint("Error al cargar notificaciones: ${result.error}");
          _error = 'Error al cargar las notificaciones';
          _notifications = [];
      }
    } catch (e) {
      _log.severe('Error loading notifications', e);
      _error = 'Error inesperado';
      _notifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendNotification(
      String toNotificationToken, String title, String body) async {
    final result = await _notificationRepository.sendNotification(
        toNotificationToken, title, body);

    debugPrint("[notifications_view_model] sendNotification: $result");
  }

  Future<void> fetchNotificationToken(String userId) async {
    final result = await _notificationRepository.getNotificationToken(userId);
    debugPrint("[notifications_view_model] fetchNotificationToken: $result"); 
  }
}
