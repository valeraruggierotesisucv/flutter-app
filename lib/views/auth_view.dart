import 'package:eventify/services/auth_service.dart';
import 'package:eventify/view_models/auth_view_model.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/date_time_picker_field.dart';
import 'package:eventify/widgets/icon_logo.dart';
import 'package:eventify/widgets/input_field.dart';
import 'package:eventify/widgets/tabs.dart';
import 'package:flutter/material.dart';

class AuthView extends StatefulWidget {
  final AuthViewModel viewModel;

  const AuthView({super.key, required this.viewModel});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late AuthViewModel _viewModel;
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordControler = TextEditingController();
  final _nameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime _dateOfBirthController = DateTime.now();
  bool passwordVisibility = false;

  final tabs = [
    TabItem(id: 1, title: 'Iniciar Sesión'),
    TabItem(id: 2, title: 'Registrarse'),
  ];
  int selectedTab = 1;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    // login button pressed
    void login() async {
      // prepare data
      final email = _emailController.text;
      final password = _passwordControler.text;

      debugPrint(email);
      debugPrint(password);

      try {
        await authService.signInWithEmailPassword(email, password, context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Error: $e")));
        }
      }
    }

    void register() async {
      final name = _nameController.text;
      final fullName = _fullNameController.text;
      final email = _emailController.text;
      final password = _passwordControler.text;
      final confirmPassword = _confirmPasswordController.text;
      final dateOfBirth = _dateOfBirthController;

      _viewModel.name = _nameController.text;
      _viewModel.fullName = _fullNameController.text;
      _viewModel.email = _emailController.text;
      _viewModel.dateOfBirth = _dateOfBirthController;
      try {
        await authService.signUpWithEmailPassword(
            _emailController.text, _passwordControler.text, context);

        debugPrint("Datos del registro");
        debugPrint(
            "$name, $fullName, $email, $password, $confirmPassword, $dateOfBirth");
        await _viewModel.signUp();
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                  height: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: IconLogo(
                          width: 200,
                          height: 200,
                        ),
                      ),
                      Tabs(
                          tabs: tabs,
                          onTabTap: (id) {
                            setState(() {
                              selectedTab = id;
                            });
                          })
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: selectedTab == 1
                    ? LayoutBuilder(builder: (context, constraints) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                InputField(
                                  label: 'Correo electrónico',
                                  hint: 'Correo electrónico',
                                  error: '',
                                  controller: _emailController,
                                ),
                                const SizedBox(height: 20),
                                InputField(
                                  label: 'Contraseña',
                                  hint: 'Contraseña',
                                  error: '',
                                  controller: _passwordControler,
                                  secureText: !passwordVisibility,
                                  icon: passwordVisibility
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  onIconTap: () {
                                    setState(() {
                                      passwordVisibility = !passwordVisibility;
                                    });
                                  },
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, '/forgot_password'),
                                  child:
                                      const Text('¿Olvidaste tu contraseña?'),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                            CustomButton(
                              label: "Iniciar Sesión",
                              onPress: login,
                            ),
                          ],
                        );
                      })
                    : Column(
                        children: [
                          Column(
                            spacing: 30,
                            children: [
                              InputField(
                                label: 'Nombre de Usuario',
                                hint: 'Nombre de Usuario',
                                error: '',
                                controller: _nameController,
                              ),
                              InputField(
                                label: 'Nombre Completo',
                                hint: 'Nombre Completo',
                                error: '',
                                controller: _fullNameController,
                              ),
                              InputField(
                                  label: 'Correo electrónico',
                                  hint: 'Correo electrónico',
                                  error: '',
                                  controller: _emailController),
                              DateTimePickerField(
                                  label: 'Fecha de nacimiento',
                                  value: _dateOfBirthController,
                                  onChange: (value) => setState(() {
                                        _dateOfBirthController = value;
                                      })),
                              InputField(
                                  label: 'Contraseña',
                                  hint: 'Contraseña',
                                  error: '',
                                  controller: _passwordControler),
                              InputField(
                                  label: 'Confirmar contraseña',
                                  hint: 'Confirmar contraseña',
                                  error: '',
                                  controller: _confirmPasswordController),
                              const SizedBox(height: 10),
                              CustomButton(
                                  label: 'Registrarse', onPress: register),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
