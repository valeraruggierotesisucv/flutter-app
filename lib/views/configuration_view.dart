import 'package:eventify/models/locale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfigurationView extends StatelessWidget {
  const ConfigurationView({super.key});

  @override
  Widget build(BuildContext context) {

     final t = AppLocalizations.of(context)!;
    final selectedLocale = Localizations.localeOf(context).toString();
    
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Configuration View'),
            Consumer<LocaleModel>(
              builder: (context, localeModel, child) => ElevatedButton(
                onPressed: () => localeModel.set(const Locale('es')),
                child: const Text('Spanish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
