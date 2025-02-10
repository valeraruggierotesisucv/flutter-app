import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/services/storage_service.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';



class EditProfileViewModel extends ChangeNotifier {

  EditProfileViewModel({required BuildContext context, required UserRepository userRepository})
  : _userRepository = userRepository,
    _context = context {
      initLoad = Command1<void, String>(_initLoad);
      updateProfile = Command1<void, UserModel>(_updateProfile);
    }

  final UserRepository _userRepository;
  final BuildContext _context;

  UserModel? _user;
  UserModel? get user => _user;

  late final Command1<void, String> initLoad;
  late final Command1<void, UserModel> updateProfile;
  final StorageService _storageService = StorageService();


  final _log = Logger('EditProfileViewModel');

  Future<Result<UserModel>> _initLoad(String userId) async {
      try {
        final result = await _userRepository.getUser(userId);
      
        switch (result) {
          case Ok<UserModel>():
            _user = result.value;
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

  Future<Result<UserModel>> _updateProfile(UserModel user) async {
    try {
      String? publicImageUrl;
      if (user.profileImage != null) {
        publicImageUrl =
            await _storageService.uploadFile(user.profileImage!, FileType.image);

        user.profileImage = publicImageUrl;
        
        debugPrint("image url --> $publicImageUrl"); 
        if (publicImageUrl == null) {
          throw Exception('Failed to upload image');
        }
      }

      final result = await _userRepository.updateProfile(user);
      switch (result) {
        case Ok<UserModel>():
          _user = result.value;
          notifyListeners();
          _log.fine('Profile updated successfully');
          return Result.ok(_user!);


        case Error<UserModel>():
          _log.warning('Failed to update profile', result.error);
          return Result.error(result.error);
      }

    } catch (e) {
      _log.severe('Error in updateProfile', e);
      return Result.error(Exception('Failed to update profile'));
  }
}
}
