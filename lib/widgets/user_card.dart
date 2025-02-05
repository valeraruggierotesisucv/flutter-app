import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';

enum UserCardVariant {
  defaultCard,
  withButton,
}

class UserCard extends StatelessWidget {
  final String? profileImage;
  final String username;
  final UserCardVariant variant;
  final VoidCallback? onPressUser;
  final VoidCallback? onPressButton;
  final String? actionLabel;
  final bool disabled;

  const UserCard({
    super.key,
    this.profileImage,
    required this.username,
    this.variant = UserCardVariant.defaultCard,
    this.onPressUser,
    this.onPressButton,
    this.actionLabel,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onPressUser,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: profileImage != null
                            ? NetworkImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (variant == UserCardVariant.withButton) 
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CustomButton(
                  label: actionLabel ?? "Action",
                  onPress: onPressButton,
                  size: ButtonSize.extraSmall,
                  fontSize: 14,
                  disabled: disabled,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
