import 'package:flutter/material.dart';

enum ChipVariant {
  defaultChip,
  light,
}

class CustomChip extends StatelessWidget {
  final String label;
  final VoidCallback? onPress;
  final ChipVariant variant;

  const CustomChip({
    super.key,
    required this.label,
    this.onPress,
    this.variant = ChipVariant.defaultChip,
  });

  Color _getTextColor() {
    switch (variant) {
      case ChipVariant.defaultChip:
        return Colors
            .blue; // Ajusta este color según tu theme.colors["primary"]
      case ChipVariant.light:
        return Colors
            .grey; // Ajusta este color según tu theme.colors["secondary"]
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 60,
      ),
      height: 37,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color:
            Colors.grey[200], // Ajusta este color según tu theme.colors["gray"]
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600, // Semibold
            // fontFamily: 'SF-Pro-Text', // Necesitas configurar esta fuente en pubspec.yaml
            color: _getTextColor(),
          ),
        ),
      ),
    );
  }
}
