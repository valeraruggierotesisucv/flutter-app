import 'package:flutter/material.dart';

class SocialInteractions extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const SocialInteractions({
    super.key,
    this.isLiked = false,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onLike,
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: 22,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 19),
          GestureDetector(
            onTap: onComment,
            child: const Icon(
              Icons.comment_outlined,
              size: 21,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 19),
          GestureDetector(
            onTap: onShare,
            child: const Icon(
              Icons.send,
              size: 21,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
