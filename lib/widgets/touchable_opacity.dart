import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final Duration duration = const Duration(milliseconds: 10);
  final double opacity = 0.5;


  const TouchableOpacity({super.key, required this.child, required this.onTap});



  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}



class _TouchableOpacityState extends State<TouchableOpacity> {
  bool isDown = false;

  @override
  void initState() {
    super.initState();
    setState(() => isDown = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isDown = true),
      onTapUp: (_) => setState(() => isDown = false),
      onTapCancel: () => setState(() => isDown = false),
      onTap: () => widget.onTap(),
      child: AnimatedOpacity(
        duration: widget.duration,
        opacity: isDown ? widget.opacity : 1,
        child: widget.child,
      ),
    );
  }
}