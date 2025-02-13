import 'package:flutter/material.dart';
import '../utils/date_formatter.dart';

class CommentItem extends StatelessWidget {
  final String username;
  final DateTime timeAgo;
  final String comment;
  final String profileImage;

  const CommentItem({
    super.key,
    required this.username,
    required this.timeAgo,
    required this.comment,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(profileImage),
            onBackgroundImageError: (_, __) {
              // Fallback to initial if image fails to load
              Text(username[0].toUpperCase());
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatDate(timeAgo, context),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 