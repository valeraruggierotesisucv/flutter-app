// lib/view_models/auth_model_view.dart
import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/models/user_model.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required BuildContext context,
    required UserRepository userRepository,
  })  : _context = context,
        _userRepository = userRepository;

  final BuildContext _context;
  final UserRepository _userRepository;

  String name = '';
  String fullName = '';
  String email = '';
  DateTime dateOfBirth = DateTime.now();
  bool isLoading = false;
  String? errorMessage;

  Future<void> signUp() async {
    isLoading = true;
    notifyListeners();
    try {
      debugPrint("[viewModel]-->$name, $fullName, $email, $dateOfBirth");
      final userId =
          Provider.of<UserProvider>(_context, listen: false).user?.id;
      if (userId == null) {
        debugPrint("No user logged in");
        return; 
      }

      final result = await _userRepository.registerUser(UserModel(
          userId: userId,
          username: name,
          fullname: fullName,
          email: email,
          birthDate: dateOfBirth,
          eventsCounter: 0,
          followersCounter: 0,
          followingCounter: 0));

      debugPrint("result--> $result");
    } catch (e) {
      errorMessage = e.toString();
      ScaffoldMessenger.of(_context)
          .showSnackBar(SnackBar(content: Text("Error: $errorMessage")));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
