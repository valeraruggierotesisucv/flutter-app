import 'package:flutter/material.dart';

class EventDetailsView extends StatelessWidget {
  final String eventId;
  final bool canEdit;

  const EventDetailsView({super.key, required this.eventId, required this.canEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Event Details View for event ID: $eventId'),
      ),
    );
  }
}
