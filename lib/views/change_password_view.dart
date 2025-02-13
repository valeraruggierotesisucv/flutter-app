import 'package:eventify/services/auth_service.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String errorNewPassword = '';
  String errorConfirmPassword = '';
  bool secureTextNewPassword = true;
  bool secureTextConfirmPassword = true;
  final authService = AuthService();

  void changePasword() async {
    final t = AppLocalizations.of(context)!;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      errorNewPassword = '';
      errorConfirmPassword = '';
    });

    if (newPassword.length < 6) {
      setState(() {
        errorNewPassword = t.changePasswordError;
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        errorNewPassword = t.changePasswordMismatch;
        errorConfirmPassword = t.changePasswordMismatch;
      });
      return;
    }

    await authService.changePassword(newPassword, confirmPassword);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.changePasswordSuccess)),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppHeader(
        title: t.changePasswordTitle,
        goBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    InputField(
                      label: t.changePasswordNew,
                      hint: t.changePasswordNewHint,
                      variant: InputFieldVariant.grayBackground,
                      controller: _newPasswordController,
                      secureText: secureTextNewPassword,
                      error: errorNewPassword,
                      icon: secureTextNewPassword ? Icons.visibility_off : Icons.visibility,
                      onIconTap: () {
                        setState(() {
                          secureTextNewPassword = !secureTextNewPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: t.changePasswordConfirm,
                      hint: t.changePasswordConfirmHint,
                      variant: InputFieldVariant.grayBackground,
                      controller: _confirmPasswordController,
                      secureText: secureTextConfirmPassword,
                      error: errorConfirmPassword,
                      icon: secureTextConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      onIconTap: () {
                        setState(() {
                          secureTextConfirmPassword = !secureTextConfirmPassword;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(
                label: t.changePasswordButton,
                onPress: changePasword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}