import 'package:eventify/data/repositories/user_repository.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/routes.dart';
import 'package:eventify/view_models/auth_view_model.dart';
import 'package:eventify/views/auth_view.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:eventify/widgets/icon_logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconLogo(
                  height: 210,
                  width: 230,
                ),
                Image.asset(
                  'assets/images/Onboarding.png',
                  height: height * 0.43, 
                  fit: BoxFit.contain,
                ),
                Text(
                  "Events for Everyone",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'SF-Pro-Rounded-Heavy',
                    fontSize: 45,
                    height: 1,                    
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 20,), 
                CustomButton(
                  label: "Comenzar",
                  onPress: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthView(
                    viewModel: AuthViewModel(
                      context: context, 
                      userRepository: UserRepository(
                        Provider.of<ApiClient>(context, listen: false))
                      )
                    ))),
                  size: ButtonSize.large,
                ),
              ],
            ),
            
          ),
          
        ),
      ),
    );
  }
}
