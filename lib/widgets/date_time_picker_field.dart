import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateTimePickerVariant {
  defaultStyle,
  grayBackground,
}

class DateTimePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final Function(DateTime) onChange;
  final String? placeholder;
  final String? error;
  final IconData? icon;
  final DateTimePickerVariant variant;
  final EdgeInsets? margin;
  final Color? iconColor;

  const DateTimePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChange,
    this.placeholder,
    this.error,
    this.icon,
    this.variant = DateTimePickerVariant.defaultStyle,
    this.margin,
    this.iconColor,
  });

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onChange(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: variant == DateTimePickerVariant.grayBackground
                    ? const Color(0xFFE0E0E0)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: error != null ? Colors.red : const Color(0xFFE1E1E1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value != null
                        ? DateFormat.yMd().format(value!)
                        : placeholder ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  if (icon != null)
                    Icon(
                      icon,
                      size: 24,
                      color: iconColor ?? const Color(0xFF666666),
                    ),
                ],
              ),
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 