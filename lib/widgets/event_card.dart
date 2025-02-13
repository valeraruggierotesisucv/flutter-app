import 'package:eventify/models/comment_model.dart';
import 'package:eventify/utils/command.dart';
import 'package:eventify/utils/date_formatter.dart';
import 'package:eventify/widgets/audio_player.dart';
import 'package:eventify/widgets/comment_input.dart';
import 'package:eventify/widgets/comment_item.dart';
import 'package:eventify/widgets/comments_section.dart';
import 'package:flutter/material.dart';
import 'custom_chip.dart';
import 'display_input.dart';
import 'user_card.dart';
import 'social_interactions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        if (musicUrl != null && musicUrl!.isNotEmpty)
          CustomAudioPlayer(audioUrl: musicUrl!),
        DisplayInput(
          label: t.eventCardLocation,
          data: LocationPill(
            latitude: latitude ?? '',
            longitude: longitude ?? '',
          ),
        ),
        DisplayInput(
          label: t.eventCardWhen,
          data: Pill(
            startsAt: startsAt ?? '',
            endsAt: endsAt ?? '',
            date: date ?? '',
          ),
        ),
        DisplayInput(
          label: t.eventCardCategory,
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
  final DateTime date;
  final String? latitude;
  final String? longitude;
  final DateTime? startsAt;
  final String? category;
  final DateTime? endsAt;
  final EventCardVariant variant;
  final Map<String, String> userComment;
  final VoidCallback onPressUser;
  final VoidCallback? onMoreDetails;
  final String? musicUrl;
  final VoidCallback handleLike;
  final Function(String) onCommentSubmit;

  final Command1<void, String>? fetchComments;
  final ValueNotifier<List<CommentModel>>? commentsListenable;

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
    this.onMoreDetails,
    this.musicUrl,
    required this.handleLike,

    required this.onCommentSubmit,
    this.fetchComments,
    this.commentsListenable,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
            if(widget.fetchComments != null) {
              showCommentsModal(context, widget.eventId, widget.fetchComments!, widget.commentsListenable!, (comment) {
                widget.onCommentSubmit(comment);
              });
            }
          },
          onShare: () {
            Share.share(
              t.eventCardShareMessage(
                widget.title,
                formatDateToLocalString(widget.date)
              )
            );
          },
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
                  label: formatDateToLocalString(widget.date),
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
                t.eventCardSeeMore,
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
            startsAt: formatTime(widget.startsAt!),
            endsAt: formatTime(widget.endsAt!),
            date: formatDateToLocalString(widget.date),
            category: widget.category,
            musicUrl: widget.musicUrl,
          ),
        // Falta comentarios
      ],
    );
  }
}
