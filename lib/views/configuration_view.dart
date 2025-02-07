import 'package:eventify/models/locale.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfigurationView extends StatelessWidget {
  const ConfigurationView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final t = AppLocalizations.of(context)!;

    final selectedLocale = Localizations.localeOf(context).toString();
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Configuration View'),
            Consumer<LocaleModel>(
              builder: (context, localeModel, child) => ElevatedButton(
                onPressed: () => localeModel.set(const Locale('es')),
                child: const Text('Spanish'),
              ),
            ),
            ElevatedButton(
              onPressed: () => authService.signOut(context),
              child: const Text('Cerrar sesión'),
            )
          ],
        ),
      ),
    );
  }
}
