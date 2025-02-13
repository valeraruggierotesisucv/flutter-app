import 'package:eventify/services/auth_service.dart';
import 'package:eventify/views/forgot_password_login_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/input_field.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }



  void handleSendLink() async {
    try {
      final email = _emailController.text;
      await _authService.sendResetLink(email);
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordLoginView(),
      ),
    );
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppHeader(
        goBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
          ),
          child: Container(
            color: const Color(0xFFD9D9D9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 40),
                              child: Column(
                                children: [
                                  Text(
                                    t.forgotPasswordTitle,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontFamily: 'SFProRounded',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Image.asset(
                                    'assets/images/ForgotPassword.png',
                                    height: 300,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    t.forgotPasswordDescription,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            )
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          InputField(
                            label: t.forgotPasswordEmail,
                            hint: t.forgotPasswordEmailHint,
                            controller: _emailController,
                            error: '',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 60.0),
                  child: CustomButton(
                    label: t.forgotPasswordSendLink,
                    disabled: _emailController.text.isEmpty,
                    onPress: () async {
                      try {
                        handleSendLink();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t.forgotPasswordError(e.toString()))),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
