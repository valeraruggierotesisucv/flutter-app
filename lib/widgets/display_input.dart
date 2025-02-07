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
      height: 51,
      padding: const EdgeInsets.only(left:16, bottom: 10, right: 16, top: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Color(0xFFD9D9D9), // Use 8-digit hexadecimal format
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 48, // equivalente a flex: 0.45
            child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: label,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
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
