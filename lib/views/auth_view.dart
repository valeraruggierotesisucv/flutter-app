import 'package:eventify/services/auth_service.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:eventify/models/locale.dart';
import 'package:provider/provider.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final selectedLocale = Localizations.localeOf(context).toString();
    
    // login button pressed
    void login() async {
      // prepare data
      final email = _emailController.text;
      final password = _passwordControler.text;

      try {
        await authService.signInWithEmailPassword(email, password, context);

      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Error: $e")));
        }
      }
    }

    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(16.0), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<LocaleModel>(
              builder: (context, localeModel, child) =>
              ElevatedButton(
                onPressed: () => localeModel.set(Locale('es')),
                child: Text('Spanish'),
              ),
          ),
          Text('${t.helloWorld} $selectedLocale'),
          // email
          TextField(
            controller: _emailController,
            decoration:  InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
          ),
          const SizedBox(height: 20,), 
          // password
          TextField(
            controller: _passwordControler,
            decoration:  InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
          ), 
          const SizedBox(height: 20,), 
          CustomButton(
            label: "Iniciar Sesión", 
            onPress: login,
          )
        ],
      ),
      )
    );
  }
}
