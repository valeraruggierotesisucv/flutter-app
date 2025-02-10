import 'package:eventify/models/event_summary_model.dart';
import 'package:flutter/material.dart';
import 'event_thumbnail.dart';


class EventThumbnailList extends StatelessWidget {
  final List<EventSummaryModel> events;
  final Function(String id)? onEventTap;
  const EventThumbnailList({super.key, required this.events, this.onEventTap});


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,  
        mainAxisSpacing: 16,  
        crossAxisSpacing: 16, 
        childAspectRatio: 1,  
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventThumbnail(
          id: events[index].eventId,
          imageUrl: events[index].imageUrl,
          onTap: () {
            onEventTap?.call(events[index].eventId);
          },
        );
      },
    );
  }
}