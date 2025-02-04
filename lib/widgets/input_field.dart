import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hint;
  final String? error;
  final IconData? icon;
  final Function()? onIconTap;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    this.error,
    this.icon,
    this.onIconTap,
    this.onChanged,
    this.controller,

  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final TextEditingController _controller = TextEditingController();


  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 4),
            child: Text(widget.label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          TextField(
            controller: widget.controller ?? _controller,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: widget.hint,
              border:
                  OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
              suffixIcon: widget.icon != null

                  ? IconButton(
                      icon: Icon(widget.icon),
                      onPressed: () {
                        widget.onIconTap?.call();
                      },
                    )
                  : null,
            ),
          ),
          if (widget.error != '')
            Container(
              padding: const EdgeInsets.only(left: 4),
              child: widget.error != null ? Text(widget.error!,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)) : null,

            ),
        ],
      );
  }
}
