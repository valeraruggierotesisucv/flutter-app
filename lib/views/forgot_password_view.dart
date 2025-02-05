import 'package:eventify/widgets/app_header.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        goBack: () => Navigator.pop(context),
      ),
      body: Center(
        child: Text('Forgot Password View'),
      ),
    );
  }
}
