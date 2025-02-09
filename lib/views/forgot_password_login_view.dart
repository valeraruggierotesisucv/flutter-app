import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/view_models/auth_view_model.dart';
import 'package:eventify/views/auth_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
class ForgotPasswordLoginView extends StatelessWidget {
  const ForgotPasswordLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppHeader(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    t!.forgotPasswordLoginViewTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: 'SFProRounded',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/Success.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    t.forgotPasswordLoginViewDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'SFProText',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: CustomButton(
                label: t.forgotPasswordLoginViewLogin,
                onPress: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthView(
              viewModel: AuthViewModel(
                context: context, 
                userRepository: UserRepository(
                  Provider.of<ApiClient>(context, listen: false))
                )
              ),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
