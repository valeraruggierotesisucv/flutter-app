import 'package:flutter/material.dart';
import 'custom_chip.dart';
import 'display_input.dart';
import 'user_card.dart';
import 'social_interactions.dart';

// Enums
enum EventCardVariant {
  defaultCard,
  details,
}

// Models
class Comment {
  final String username;
  final String comment;
  final String profileImage;
  final DateTime timestamp;

  Comment({
    required this.username,
    required this.comment,
    required this.profileImage,
    required this.timestamp,
  });
}

// Widgets auxiliares
class Pills extends StatelessWidget {
  final String startsAt;
  final String endsAt;
  final String date;

  const Pills({
    super.key,
    required this.startsAt,
    required this.endsAt,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomChip(label: startsAt, variant: ChipVariant.light),
        const SizedBox(width: 8),
        CustomChip(label: endsAt, variant: ChipVariant.light),
        const SizedBox(width: 8),
        CustomChip(label: date, variant: ChipVariant.light),
      ],
    );
  }
}

class LocationPills extends StatelessWidget {
  final String latitude;
  final String longitude;

  const LocationPills({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final lat = double.parse(latitude).toStringAsFixed(3);
    final long = double.parse(longitude).toStringAsFixed(3);

    return Row(
      children: [
        CustomChip(label: lat, variant: ChipVariant.light),
        const SizedBox(width: 8),
        CustomChip(label: long, variant: ChipVariant.light),
      ],
    );
  }
}

class DisplayEvent extends StatelessWidget {
  final String? latitude;
  final String? longitude;
  final String? startsAt;
  final String? endsAt;
  final String? date;
  final String? category;
  final String? musicUrl;

  const DisplayEvent({
    super.key,
    this.latitude,
    this.longitude,
    this.startsAt,
    this.endsAt,
    this.date,
    this.category,
    this.musicUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Falta AudioPlayer
        DisplayInput(
          label: 'LOCATION', // Usar i18n aquí
          data: LocationPills(
            latitude: latitude ?? '',
            longitude: longitude ?? '',
          ),
        ),
        DisplayInput(
          label: 'WHEN', // Usar i18n aquí
          data: Pills(
            startsAt: startsAt ?? '',
            endsAt: endsAt ?? '',
            date: date ?? '',
          ),
        ),
        DisplayInput(
          label: 'CATEGORY', // Usar i18n aquí
          data: CustomChip(
            label: category ?? '',
            variant: ChipVariant.light,
          ),
        ),
      ],
    );
  }
}

class EventCard extends StatefulWidget {
  final String eventId;
  final String profileImage;
  final String username;
  final String eventImage;
  final String title;
  final String description;
  final bool isLiked;
  final String date;
  final String? latitude;
  final String? longitude;
  final String? startsAt;
  final String? category;
  final String? endsAt;
  final EventCardVariant variant;
  final Map<String, String> userComment;
  final VoidCallback onPressUser;
  final Future<void> Function(String eventId, String comment) onComment;
  final VoidCallback onShare;
  final VoidCallback? onMoreDetails;
  final Future<List<Comment>> Function() fetchComments;
  final String? musicUrl;
  final VoidCallback handleLike;

  const EventCard({
    super.key,
    required this.eventId,
    required this.profileImage,
    required this.username,
    required this.eventImage,
    required this.title,
    required this.description,
    required this.isLiked,
    required this.date,
    this.latitude,
    this.longitude,
    this.startsAt,
    this.category,
    this.endsAt,
    this.variant = EventCardVariant.defaultCard,
    required this.userComment,
    required this.onPressUser,
    required this.onComment,
    required this.onShare,
    this.onMoreDetails,
    required this.fetchComments,
    this.musicUrl,
    required this.handleLike,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _commentsVisible = false;
  List<Comment> _comments = [];

  Future<void> _handleAddComment(String comment) async {
    try {
      await widget.onComment(widget.eventId, comment);
      setState(() {
        _comments = [
          ..._comments,
          Comment(
            username: widget.userComment['username']!,
            comment: comment,
            profileImage: widget.userComment['profileImage']!,
            timestamp: DateTime.now(),
          ),
        ];
      });
    } catch (e) {
      debugPrint('Error adding comment: $e');
    }
  }

  Future<void> _getComments() async {
    if (_commentsVisible) {
      try {
        final response = await widget.fetchComments();
        setState(() {
          _comments = response;
        });
      } catch (e) {
        debugPrint('Error fetching comments: $e');
      }
    }
  }

  @override
  void didUpdateWidget(EventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_commentsVisible) {
      _getComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserCard(
          profileImage: widget.profileImage,
          username: widget.username,
          variant: UserCardVariant.defaultCard,
          onPressUser: widget.onPressUser,
        ),
        const SizedBox(height: 8),
        Image.network(
          widget.eventImage,
          height: 277,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        SocialInteractions(
          isLiked: widget.isLiked,
          onLike: widget.handleLike,
          onComment: () => setState(() => _commentsVisible = true),
          onShare: widget.onShare,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    // fontFamily: 'SF-Pro-Rounded',
                  ),
                ),
              ),
              if (widget.variant == EventCardVariant.defaultCard)
                CustomChip(
                  label: widget.date,
                  variant: ChipVariant.defaultChip,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            widget.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              // fontFamily: 'SF-Pro-Text',
            ),
          ),
        ),
        if (widget.variant == EventCardVariant.defaultCard)
          Center(
            child: TextButton(
              onPressed: widget.onMoreDetails,
              child: Text(
                'See more details', // Usar i18n aquí
                style: TextStyle(
                  color: Colors.grey[600],
                  // fontFamily: 'SF-Pro-Text',
                ),
              ),
            ),
          )
        else
          DisplayEvent(
            latitude: widget.latitude,
            longitude: widget.longitude,
            startsAt: widget.startsAt,
            endsAt: widget.endsAt,
            date: widget.date,
            category: widget.category,
            musicUrl: widget.musicUrl,
          ),
        // Falta comentarios
      ],
    );
  }
}
