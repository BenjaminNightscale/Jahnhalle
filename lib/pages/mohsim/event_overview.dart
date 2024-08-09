import 'package:flutter/material.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/services/database/event.dart';

class EventOverview extends StatefulWidget {
  final Event event;
  const EventOverview({super.key, required this.event});

  @override
  State<EventOverview> createState() => _EventOverviewState();
}

class _EventOverviewState extends State<EventOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: dimensions.height,
        width: dimensions.width,
        padding: const EdgeInsets.all(12),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.event.imageUrl ?? ""))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                  color: const Color(0xffE4EDCA),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: dimensions.width * 0.03),
                  Text(
                    widget.event.eventDetails,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            SizedBox(
              height: dimensions.width * 0.04,
            ),
            Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                  color: const Color(0xffE4EDCA),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.event.tickets ?? "0"}€ Rabatt",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: dimensions.width * 0.045),
                        ),
                        Text(
                          "Voucher für Pizza und Co",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: dimensions.width * 0.035),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(width: 2)),
                    child: const Text(
                      "VOUCHER",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
