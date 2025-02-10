import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/models/event_summary_model.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required BuildContext context, required UserRepository userRepository, required EventRepository eventRepository})
  : _userRepository = userRepository,
    _eventRepository = eventRepository,
    _context = context {
      initLoad = Command1<void, String>(_initLoad);
    }


    final BuildContext _context;
    final UserRepository _userRepository;
    final EventRepository _eventRepository;

    List<EventSummaryModel> _events = [];
    List<EventSummaryModel> get events => _events;
    late final Command1<void, String> initLoad;
    UserModel? _user;
    UserModel? get user => _user;

    final _log = Logger('ProfileViewModel');

    Future<Result<UserModel>> _initLoad(String userId) async {
      try {
        final result = await _userRepository.getUser(userId);
        


        switch (result) {
          case Ok<UserModel>():
            _user = result.value;

            final eventsResult = await _eventRepository.getUserEvents(userId);
            switch (eventsResult) {
              case Ok<List<EventSummaryModel>>():
                _events = eventsResult.value;
              case Error<List<EventSummaryModel>>():
                _log.warning('Failed to load user events', eventsResult.error);
            }
            
            notifyListeners();
            return Result.ok(_user!);
            
          case Error<UserModel>():
            _log.warning('Failed to load user', result.error);
            return Result.error(result.error);
        }
      } catch (e) {
        _log.severe('Error in initLoad', e);
        return Result.error(Exception('Failed to load user'));
      }
    }
}
