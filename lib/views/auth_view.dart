import 'package:eventify/services/auth_service.dart';
import 'package:eventify/view_models/auth_view_model.dart';
import 'package:eventify/views/forgot_password_view.dart';
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
  late DateTime _dateOfBirthController;
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  String nameError = '';
  String fullNameError = '';
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  final tabs = [
    TabItem(id: 1, title: 'Iniciar Sesión'),
    TabItem(id: 2, title: 'Registrarse'),
  ];
  int selectedTab = 1;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    DateTime now = DateTime.now();
    _dateOfBirthController = DateTime(now.year - 18, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    void login() async {
      final email = _emailController.text;
      final password = _passwordControler.text;

      try {
        await authService.signInWithEmailPassword(email, password, context);
      } catch (e) {
        
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Error: $e")));
        
      }
    }

    void register() async {
      setState(() {
        nameError = '';
        fullNameError = '';
        emailError = '';
        passwordError = '';
        confirmPasswordError = '';
      });

      bool isValid = true;

    if (_nameController.text.isEmpty) {
      nameError = 'Este campo es obligatorio';
      isValid = false;
    }

    if (_fullNameController.text.isEmpty) {
      fullNameError = 'Este campo es obligatorio';
      isValid = false;
    }

    if (_emailController.text.isEmpty) {
      emailError = 'Este campo es obligatorio';
      isValid = false;
    } else {
      // Validación de formato de correo electrónico
      String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(_emailController.text)) {
        emailError = 'Ingrese un correo electrónico válido';
        isValid = false;
      }
    }

    if (_passwordControler.text.isEmpty) {
      passwordError = 'Este campo es obligatorio';
      isValid = false;
    }

    if (_confirmPasswordController.text.isEmpty) {
      confirmPasswordError = 'Este campo es obligatorio';
      isValid = false;
    } 
    
    if (_confirmPasswordController.text != _passwordControler.text) {
      confirmPasswordError = 'Las contraseñas no coinciden';
      isValid = false;
    }

    if(isValid){
      _viewModel.name = _nameController.text;
      _viewModel.fullName = _fullNameController.text;
      _viewModel.email = _emailController.text;
      _viewModel.dateOfBirth = _dateOfBirthController;
      try {
        await authService.signUpWithEmailPassword(
            _emailController.text, _passwordControler.text, context);

        debugPrint("Datos del registro");
        await _viewModel.signUp();
      } catch (e) {
        debugPrint(e.toString());
      }
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
                                  icon: Icons.email,
                                ),
                                const SizedBox(height: 20),
                                InputField(
                                  label: 'Contraseña',
                                  hint: 'Contraseña',
                                  error: '',
                                  controller: _passwordControler,
                                  secureText: !passwordVisibility,
                                  icon: passwordVisibility
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  onIconTap: () {
                                    setState(() {
                                      passwordVisibility = !passwordVisibility;
                                    });
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ForgotPasswordView(),
                                      ),
                                    );
                                  },
                                  child: const Text('¿Olvidaste tu contraseña?'),
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
                                error: nameError,
                                controller: _nameController,
                                icon: Icons.person,
                              ),
                              InputField(
                                label: 'Nombre Completo',
                                hint: 'Nombre Completo',
                                error: fullNameError,
                                controller: _fullNameController,
                                icon: Icons.person_add,
                              ),
                              InputField(
                                  label: 'Correo electrónico',
                                  hint: 'Correo electrónico',
                                  error: emailError,
                                  controller: _emailController,
                                  icon: Icons.email),
                              DateTimePickerField(
                                  label: 'Fecha de nacimiento',
                                  value: _dateOfBirthController,
                                  onChange: (value) => setState(() {
                                        _dateOfBirthController = value;
                                      })),
                              InputField(
                                label: 'Contraseña',
                                hint: 'Contraseña',
                                error: passwordError,
                                controller: _passwordControler,
                                secureText: !passwordVisibility,
                                icon: passwordVisibility
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                onIconTap: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                },
                              ),
                              InputField(
                                label: 'Confirmar contraseña',
                                hint: 'Confirmar contraseña',
                                error: confirmPasswordError,
                                controller: _confirmPasswordController,
                                secureText: confirmPasswordVisibility,
                                icon: confirmPasswordVisibility
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                onIconTap: () {
                                  setState(() {
                                    confirmPasswordVisibility =
                                        !confirmPasswordVisibility;
                                  });
                                },
                              ),
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
