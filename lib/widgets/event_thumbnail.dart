import 'package:flutter/material.dart';
import 'touchable_opacity.dart';

class EventThumbnail extends StatefulWidget {
  final String id;  
  final String imageUrl;

  final VoidCallback? onTap;

  const EventThumbnail({
    super.key, 
    required this.id, 
    required this.imageUrl,
    this.onTap,
  });

  @override
  State<EventThumbnail> createState() => _EventThumbnailState();
}

class _EventThumbnailState extends State<EventThumbnail> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => widget.onTap?.call(),
      child: Container(
        width: 110,

        height: 110,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(widget.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

