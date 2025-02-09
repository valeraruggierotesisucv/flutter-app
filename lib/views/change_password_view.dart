import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/input_field.dart';
import 'package:flutter/material.dart';


class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  bool secureTextNewPassword = true;
  bool secureTextConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppHeader(
        title: 'Cambiar contraseña',
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
                      label: "Nueva contraseña",
                      hint: "Nueva contraseña",
                      variant: InputFieldVariant.grayBackground,
                      secureText: secureTextNewPassword,
                      icon: secureTextNewPassword ? Icons.visibility_off : Icons.visibility,
                      onIconTap: () {
                        setState(() {
                          secureTextNewPassword = !secureTextNewPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: "Confirmar contraseña",
                      hint: "Confirmar contraseña",
                      variant: InputFieldVariant  .grayBackground,
                      secureText: secureTextConfirmPassword,
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
                label: "Cambiar contraseña",
                onPress: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
