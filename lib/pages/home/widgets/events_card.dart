import 'package:flutter/material.dart';
import 'package:jahnhalle/services/database/event.dart';
import 'package:jahnhalle/components/themes/colors.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 2.0),
                color: Colors.white,
              ),
              child: event.imageUrl != null
                  ? Image.network(
                      event.eventImage ?? '',
                      fit: BoxFit.cover,
                      height: 160,
                      width: double.infinity,
                    )
                  : Container(
                      height: 160,
                      color: Colors.grey,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                // const SizedBox(height: 2),
                Text(
                  'Sa - ${event.date}',
                  style: const TextStyle(fontSize: 12, color: secondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
