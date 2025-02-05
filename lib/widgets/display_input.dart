import 'package:flutter/material.dart';

class DisplayInput extends StatelessWidget {
  final String label;
  final Widget data;

  const DisplayInput({
    super.key,
    required this.label,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Color(0xFFE9E8E8), // Ajusta este color según tu theme
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 45, // equivalente a flex: 0.45
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                // fontFamily: 'SF-Pro-Rounded', // Necesitas configurar esta fuente en pubspec.yaml
              ),
            ),
          ),
          Expanded(
            flex: 100, // equivalente a flex: 1
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.grey,
                // fontFamily: 'SF-Pro-Text', // Necesitas configurar esta fuente en pubspec.yaml
              ),
              child: data,
            ),
          ),
        ],
      ),
    );
  }
}
