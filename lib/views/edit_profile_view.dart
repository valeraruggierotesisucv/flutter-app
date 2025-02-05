import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/input_field.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppHeader(
        title: t.editProfileTitle,
        goBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                      child: GestureDetector(
                              onTap: () {
                                print('tapped');
                                // Handle image selection
                              },
                              child:Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg',
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child:  Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF050F71),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    InputField(
                      label: t.editProfileName,
                      hint: t.editProfileNameHint,
                      controller: TextEditingController(),
                      error: '',
                      variant: InputFieldVariant.grayBackground,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: t.editProfileBio,
                      hint: t.editProfileBioHint,
                      controller: TextEditingController(),
                      error: '',
                      variant: InputFieldVariant.grayBackground,
                      icon: Icons.person,
                    ),
                  ],
                ),
                ),
              ),
            ),
            CustomButton(
              label: t.editProfileSubmit,
              onPress: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
