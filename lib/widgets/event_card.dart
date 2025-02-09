import 'package:eventify/models/comment_model.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/widgets/audio_player.dart';
import 'package:eventify/widgets/comment_input.dart';
import 'package:eventify/widgets/comment_item.dart';
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

// Widgets auxiliares
class Pill extends StatelessWidget {
  final String startsAt;
  final String endsAt;
  final String date;

  const Pill({
    super.key,
    required this.startsAt,
    required this.endsAt,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomChip(label: startsAt, variant: ChipVariant.defaultChip),
        const SizedBox(width: 8),
        CustomChip(label: endsAt, variant: ChipVariant.defaultChip),
        const SizedBox(width: 8),
        CustomChip(label: date, variant: ChipVariant.defaultChip),
      ],
    );
  }
}

class LocationPill extends StatelessWidget {
  final String latitude;
  final String longitude;

  const LocationPill({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        CustomChip(label: latitude, variant: ChipVariant.defaultChip),
        const SizedBox(width: 8),
        CustomChip(label: longitude, variant: ChipVariant.defaultChip),
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
        if (musicUrl != null && musicUrl!.isNotEmpty)
          CustomAudioPlayer(audioUrl: musicUrl!),
        DisplayInput(
          label: 'LOCATION', // Usar i18n aquí
          data: LocationPill(
            latitude: latitude ?? '',
            longitude: longitude ?? '',
          ),
        ),
        DisplayInput(
          label: 'WHEN', // Usar i18n aquí
          data: Pill(
            startsAt: startsAt ?? '',
            endsAt: endsAt ?? '',
            date: date ?? '',
          ),
        ),
        DisplayInput(
          label: 'CATEGORY', // Usar i18n aquí
          data: CustomChip(
            label: category ?? '',
            variant: ChipVariant.defaultChip,
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
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback? onMoreDetails;
  final String? musicUrl;
  final VoidCallback handleLike;
  final List<CommentModel> comments;
  final bool isLoadingComments;
  final Function(String) onCommentSubmit;
  final VoidCallback onCommentPress;
  final Command1<void, String> fetchComments;

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
    this.musicUrl,
    required this.handleLike,
    required this.comments,
    this.isLoadingComments = false,
    required this.onCommentSubmit,
    required this.onCommentPress,
    required this.fetchComments,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  
  @override
  void initState() {
    super.initState();
    widget.fetchComments.execute(widget.eventId);
  }
  

  void _showCommentsModal() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0)
        ),
      ),
      constraints: BoxConstraints.tight(Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height * .8
      )),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 5,
                  width: 50,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[500],
                  ),
                ),
                const Text("Comments"),
                Expanded(
                  child: widget.isLoadingComments 
                    ? const Center(child: CircularProgressIndicator())
                    : widget.comments.isEmpty
                      ? const Center(child: Text('No comments yet'))
                      : ListView.builder(
                          itemCount: widget.comments.length,
                          itemBuilder: (ctx, index) => CommentItem(
                            username: widget.comments[index].username,
                            timeAgo: widget.comments[index].timestamp,
                            comment: widget.comments[index].comment,
                            profileImage: widget.comments[index].profileImage,
                          ),
                        ),
                ),
                CommentInput(
                  onSubmit: (message) async {
                    widget.onCommentSubmit(message);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
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
          onComment: () {
            widget.onCommentPress();
            _showCommentsModal();
          },
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
