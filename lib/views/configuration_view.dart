import 'package:eventify/models/locale.dart';
import 'package:eventify/views/change_password_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_input.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfigurationView extends StatelessWidget {
  const ConfigurationView({super.key});

  void _showLanguageDialog(BuildContext context, LocaleModel localeModel) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.configLanguage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SFProRounded',
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                onTap: () {
                  localeModel.set(const Locale('es'));
                  Navigator.pop(context);
                },
                title: const Text(
                  'Español',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              ListTile(
                onTap: () {
                  localeModel.set(const Locale('en'));
                  Navigator.pop(context);
                },
                title: const Text(
                  'English',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppHeader(
        title: t.configTitle,
        goBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
          child: Consumer<LocaleModel>(
            builder: (context, localeModel, child) => Column(
              children: [
                CustomInput(
                  label: t.configLanguage,
                  variant: InputVariant.arrow,
                  onPress: () => _showLanguageDialog(context, localeModel),
                ),
                const SizedBox(height: 20),
                CustomInput(
                  label: t.configChangePassword,
                  variant: InputVariant.arrow,
                  onPress: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordView()),
                  ),
                ),
                const SizedBox(height: 20),
                CustomInput(
                  label: t.configLogout,
                  variant: InputVariant.arrow,
                  onPress: () => authService.signOut(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
