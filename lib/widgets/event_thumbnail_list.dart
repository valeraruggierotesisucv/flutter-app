import 'package:flutter/material.dart';
import 'event_thumbnail.dart';

class Event {
  final String id;
  final String imageUrl;

  Event({required this.id, required this.imageUrl});
}


class EventThumbnailList extends StatelessWidget {
  final List<Event> events;
  final Function(String id)? onEventTap;
  const EventThumbnailList({super.key, required this.events, this.onEventTap});


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
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
            id: events[index].id,
            imageUrl: events[index].imageUrl,
            onTap: () {
              onEventTap?.call(events[index].id);
            },
          );
        },

      ),
    );
  }
}