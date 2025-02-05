import 'package:flutter/material.dart';

enum InputVariant {
  defaultInput,
  arrow,
}

class CustomInput extends StatefulWidget {
  final String label;
  final String? placeholder;
  final bool multiline;
  final InputVariant variant;
  final bool required;
  final VoidCallback? onPress;
  final String? value;
  final Function(String)? onChangeValue;

  const CustomInput({
    super.key,
    required this.label,
    this.placeholder,
    this.multiline = true,
    this.variant = InputVariant.defaultInput,
    this.required = false,
    this.onPress,
    this.value,
    this.onChangeValue,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        height: 51,
        padding: const EdgeInsets.only(left: 16, bottom: 6, right: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: widget.placeholder != null ? 35 : 100,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: widget.label,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (widget.required)
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (widget.variant == InputVariant.defaultInput && widget.placeholder != null)
              Expanded(
                flex: 75,
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onChangeValue,
                  maxLines: widget.multiline ? 3 : 1,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 9),
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            else 
              Expanded(
                flex: 65,
                child: Text(
                  widget.placeholder!,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
            if (widget.variant == InputVariant.arrow)
              const Icon(
                Icons.keyboard_arrow_right,
                size: 24,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
} 